'use strict';

const { FieldPath, FieldValue } = require('firebase-admin/firestore');
const logger = require('firebase-functions/logger');
const {
  AUDIENCE,
  MULTICAST_LIMIT,
  STATUS,
  SUBSCRIPTION_STATUS_FOR_AUDIENCE,
  SendError,
  buildMessage,
  canSendNotifications,
  chunk,
  collectTargets,
  deadTokensByOwner,
  summarize,
  uniqueOwnerIds,
  validateContent,
} = require('./rules');

const ADMINS = 'admin';
const USERS = 'users';
const SHOPS = 'shops';
const OWNER_FIELDS = ['fcmTokens', 'isDeleted', 'isAccountBlocked'];
const GET_ALL_LIMIT = 300;
const WRITE_BATCH_LIMIT = 450;

async function claim(db, ref) {
  return db.runTransaction(async (transaction) => {
    const snapshot = await transaction.get(ref);
    if (!snapshot.exists || snapshot.get('status') !== STATUS.queued) {
      return null;
    }
    transaction.update(ref, {
      status: STATUS.sending,
      sendingStartedAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
    });
    return { id: snapshot.id, ...snapshot.data() };
  });
}

async function verifySender(db, auth, uid) {
  if (typeof uid !== 'string' || !uid) {
    throw new SendError('The notification has no sender.');
  }
  let email;
  try {
    email = (await auth.getUser(uid)).email;
  } catch (error) {
    throw new SendError('The sender account no longer exists.');
  }
  if (!email) throw new SendError('The sender account has no email.');
  const snapshot = await db
    .collection(ADMINS)
    .where('email', '==', email.trim().toLowerCase())
    .limit(1)
    .get();
  const admin = snapshot.docs[0];
  if (!admin || !canSendNotifications(admin.data())) {
    throw new SendError(
      'The sender is not an active admin allowed to send notifications.',
    );
  }
}

async function loadOwners(db, audience) {
  if (audience === AUDIENCE.allOwners) {
    const snapshot = await db
      .collection(USERS)
      .select(...OWNER_FIELDS)
      .get();
    return snapshot.docs.map((doc) => ({ id: doc.id, data: doc.data() }));
  }
  const shops = await db
    .collection(SHOPS)
    .where('subscriptionStatus', '==', SUBSCRIPTION_STATUS_FOR_AUDIENCE[audience])
    .select('ownerId')
    .get();
  const ownerIds = uniqueOwnerIds(shops.docs.map((doc) => doc.data()));
  const owners = [];
  for (const ids of chunk(ownerIds, GET_ALL_LIMIT)) {
    const refs = ids.map((id) => db.collection(USERS).doc(id));
    const snapshots = await db.getAll(...refs, {
      fieldMask: OWNER_FIELDS.map((field) => new FieldPath(field)),
    });
    for (const snapshot of snapshots) {
      if (snapshot.exists) {
        owners.push({ id: snapshot.id, data: snapshot.data() });
      }
    }
  }
  return owners;
}

async function deliver(messaging, notification, tokens) {
  const batches = [];
  for (const tokenBatch of chunk(tokens, MULTICAST_LIMIT)) {
    const response = await messaging.sendEachForMulticast(
      buildMessage(notification, tokenBatch),
    );
    batches.push({ tokens: tokenBatch, responses: response.responses });
  }
  return summarize(batches);
}

async function removeDeadTokens(db, deadTokens, tokenOwner) {
  const byOwner = [...deadTokensByOwner(deadTokens, tokenOwner)];
  for (const entries of chunk(byOwner, WRITE_BATCH_LIMIT)) {
    const batch = db.batch();
    for (const [ownerId, tokens] of entries) {
      batch.update(db.collection(USERS).doc(ownerId), {
        fcmTokens: FieldValue.arrayRemove(...tokens),
      });
    }
    await batch.commit();
  }
}

async function processQueuedNotification({ db, auth, messaging, ref }) {
  const notification = await claim(db, ref);
  if (!notification) return;
  try {
    const { title, message } = validateContent(notification);
    await verifySender(db, auth, notification.queuedByUid);
    const owners = await loadOwners(db, notification.audience);
    const targets = collectTargets(owners);
    const result =
      targets.tokens.length === 0
        ? { delivered: 0, failed: 0, failureReasons: {}, deadTokens: [] }
        : await deliver(
            messaging,
            { id: notification.id, title, message, type: notification.type },
            targets.tokens,
          );
    try {
      await removeDeadTokens(db, result.deadTokens, targets.tokenOwner);
    } catch (error) {
      logger.warn('Could not remove dead tokens', { error: error.message });
    }
    await ref.update({
      status: STATUS.sent,
      sentAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
      recipients: targets.recipients,
      ownersWithoutDevices: targets.ownersWithoutDevices,
      devices: targets.tokens.length,
      delivered: result.delivered,
      failed: result.failed,
      failureReasons: result.failureReasons,
      error: FieldValue.delete(),
    });
    logger.info('Notification sent', {
      notificationId: notification.id,
      recipients: targets.recipients,
      delivered: result.delivered,
      failed: result.failed,
    });
  } catch (error) {
    const reason =
      error instanceof SendError
        ? error.message
        : 'The send function hit an unexpected error. Check the function logs.';
    logger.error('Notification failed', {
      notificationId: notification.id,
      error: error.message,
    });
    await ref.update({
      status: STATUS.failed,
      failedAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
      error: reason,
    });
  }
}

module.exports = { processQueuedNotification };
