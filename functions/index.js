'use strict';

const { initializeApp } = require('firebase-admin/app');
const { getAuth } = require('firebase-admin/auth');
const { getFirestore } = require('firebase-admin/firestore');
const { getMessaging } = require('firebase-admin/messaging');
const { setGlobalOptions } = require('firebase-functions/v2');
const { onDocumentWritten } = require('firebase-functions/v2/firestore');
const { isNewlyQueued } = require('./src/rules');
const { processQueuedNotification } = require('./src/send_notification');

initializeApp();
setGlobalOptions({ region: 'asia-south1', maxInstances: 5 });

exports.sendQueuedNotification = onDocumentWritten(
  {
    document: 'notifications/{notificationId}',
    timeoutSeconds: 540,
    memory: '512MiB',
    retry: false,
  },
  async (event) => {
    const before = event.data && event.data.before;
    const after = event.data && event.data.after;
    if (!after || !after.exists) return;
    if (
      !isNewlyQueued(before && before.exists ? before.data() : null, after.data())
    ) {
      return;
    }
    await processQueuedNotification({
      db: getFirestore(),
      auth: getAuth(),
      messaging: getMessaging(),
      ref: after.ref,
    });
  },
);
