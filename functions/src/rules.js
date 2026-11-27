'use strict';

const STATUS = Object.freeze({
  draft: 'draft',
  queued: 'queued',
  sending: 'sending',
  sent: 'sent',
  failed: 'failed',
});

const AUDIENCE = Object.freeze({
  allOwners: 'allOwners',
  subscribedShops: 'subscribedShops',
  expiredSubscriptionShops: 'expiredSubscriptionShops',
});

const SUBSCRIPTION_STATUS_FOR_AUDIENCE = Object.freeze({
  [AUDIENCE.subscribedShops]: 'active',
  [AUDIENCE.expiredSubscriptionShops]: 'expired',
});

const NOTIFICATIONS_PERMISSION = 'notifications';
const SUPER_ADMIN_ROLE = 'superAdmin';
const MULTICAST_LIMIT = 500;

const DEAD_TOKEN_CODES = new Set([
  'messaging/registration-token-not-registered',
  'messaging/invalid-registration-token',
  'messaging/invalid-argument',
]);

const FAILURE_REASONS = Object.freeze({
  'messaging/registration-token-not-registered':
    'App uninstalled or token expired',
  'messaging/invalid-registration-token': 'Invalid device token',
  'messaging/invalid-argument': 'Invalid device token',
  'messaging/message-rate-exceeded': 'Too many messages to this device',
  'messaging/quota-exceeded': 'FCM sending quota exceeded',
  'messaging/third-party-auth-error': 'Apple push credentials problem',
  'messaging/unavailable': 'FCM temporarily unavailable',
  'messaging/internal-error': 'FCM internal error',
});

class SendError extends Error {}

function isNewlyQueued(before, after) {
  if (!after || after.status !== STATUS.queued) return false;
  return !before || before.status !== STATUS.queued;
}

function canSendNotifications(adminData) {
  if (!adminData || adminData.isActive === false) return false;
  if (adminData.role === SUPER_ADMIN_ROLE) return true;
  const permissions = Array.isArray(adminData.permissions)
    ? adminData.permissions
    : [];
  return permissions.includes(NOTIFICATIONS_PERMISSION);
}

function validateContent(data) {
  const title = typeof data.title === 'string' ? data.title.trim() : '';
  const message = typeof data.message === 'string' ? data.message.trim() : '';
  if (!title) throw new SendError('The notification has no title.');
  if (!message) throw new SendError('The notification has no message.');
  if (!Object.values(AUDIENCE).includes(data.audience)) {
    throw new SendError(`Unknown audience "${data.audience}".`);
  }
  return { title, message };
}

function uniqueOwnerIds(shops) {
  const ids = new Set();
  for (const shop of shops) {
    if (typeof shop.ownerId === 'string' && shop.ownerId.trim()) {
      ids.add(shop.ownerId.trim());
    }
  }
  return [...ids];
}

function tokensOf(owner) {
  if (!Array.isArray(owner.fcmTokens)) return [];
  return owner.fcmTokens.filter(
    (token) => typeof token === 'string' && token.trim().length > 0,
  );
}

function collectTargets(owners) {
  const tokenOwner = new Map();
  let recipients = 0;
  let ownersWithoutDevices = 0;
  for (const { id, data } of owners) {
    if (!data || data.isDeleted === true || data.isAccountBlocked === true) {
      continue;
    }
    recipients += 1;
    const tokens = tokensOf(data);
    if (tokens.length === 0) {
      ownersWithoutDevices += 1;
      continue;
    }
    for (const token of tokens) {
      if (!tokenOwner.has(token)) tokenOwner.set(token, id);
    }
  }
  return {
    recipients,
    ownersWithoutDevices,
    tokens: [...tokenOwner.keys()],
    tokenOwner,
  };
}

function chunk(items, size) {
  const chunks = [];
  for (let start = 0; start < items.length; start += size) {
    chunks.push(items.slice(start, start + size));
  }
  return chunks;
}

function failureReason(code) {
  return FAILURE_REASONS[code] || code || 'Unknown error';
}

function summarize(batches) {
  let delivered = 0;
  let failed = 0;
  const failureReasons = {};
  const deadTokens = [];
  for (const { tokens, responses } of batches) {
    responses.forEach((response, index) => {
      if (response.success) {
        delivered += 1;
        return;
      }
      failed += 1;
      const code = response.error && response.error.code;
      const reason = failureReason(code);
      failureReasons[reason] = (failureReasons[reason] || 0) + 1;
      if (DEAD_TOKEN_CODES.has(code)) deadTokens.push(tokens[index]);
    });
  }
  return { delivered, failed, failureReasons, deadTokens };
}

function buildMessage({ id, title, message, type }, tokens) {
  return {
    tokens,
    notification: { title, body: message },
    data: { notificationId: id, type: typeof type === 'string' ? type : '' },
    android: { priority: 'high' },
    apns: { payload: { aps: { sound: 'default' } } },
  };
}

function deadTokensByOwner(deadTokens, tokenOwner) {
  const byOwner = new Map();
  for (const token of deadTokens) {
    const ownerId = tokenOwner.get(token);
    if (!ownerId) continue;
    if (!byOwner.has(ownerId)) byOwner.set(ownerId, []);
    byOwner.get(ownerId).push(token);
  }
  return byOwner;
}

module.exports = {
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
  failureReason,
  isNewlyQueued,
  summarize,
  uniqueOwnerIds,
  validateContent,
};
