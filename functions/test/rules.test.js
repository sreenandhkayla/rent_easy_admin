'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const {
  MULTICAST_LIMIT,
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
} = require('../src/rules');

test('only a change into queued starts a send', () => {
  assert.equal(isNewlyQueued(null, { status: 'queued' }), true);
  assert.equal(isNewlyQueued({ status: 'draft' }, { status: 'queued' }), true);
  assert.equal(isNewlyQueued({ status: 'queued' }, { status: 'queued' }), false);
  assert.equal(isNewlyQueued({ status: 'queued' }, { status: 'sending' }), false);
  assert.equal(isNewlyQueued(null, { status: 'draft' }), false);
  assert.equal(isNewlyQueued({ status: 'sent' }, null), false);
});

test('only active super admins or admins with the permission can send', () => {
  assert.equal(canSendNotifications({ role: 'superAdmin' }), true);
  assert.equal(
    canSendNotifications({ role: 'supportAdmin', permissions: ['notifications'] }),
    true,
  );
  assert.equal(
    canSendNotifications({ role: 'supportAdmin', permissions: ['dashboard'] }),
    false,
  );
  assert.equal(
    canSendNotifications({ role: 'superAdmin', isActive: false }),
    false,
  );
  assert.equal(canSendNotifications(undefined), false);
});

test('content must have a title, a message and a known audience', () => {
  assert.deepEqual(
    validateContent({ title: ' Hi ', message: ' There ', audience: 'allOwners' }),
    { title: 'Hi', message: 'There' },
  );
  assert.throws(
    () => validateContent({ title: '', message: 'x', audience: 'allOwners' }),
    SendError,
  );
  assert.throws(
    () => validateContent({ title: 'x', message: 'x', audience: 'selected' }),
    SendError,
  );
});

test('shops collapse to unique owners', () => {
  assert.deepEqual(
    uniqueOwnerIds([
      { ownerId: 'a' },
      { ownerId: 'a' },
      { ownerId: ' b ' },
      { ownerId: '' },
      {},
    ]),
    ['a', 'b'],
  );
});

test('targets skip deleted and blocked owners and dedupe devices', () => {
  const targets = collectTargets([
    { id: 'a', data: { fcmTokens: ['t1', 't2', ''] } },
    { id: 'b', data: { fcmTokens: ['t2', 't3'] } },
    { id: 'c', data: {} },
    { id: 'd', data: { fcmTokens: ['t4'], isDeleted: true } },
    { id: 'e', data: { fcmTokens: ['t5'], isAccountBlocked: true } },
  ]);
  assert.equal(targets.recipients, 3);
  assert.equal(targets.ownersWithoutDevices, 1);
  assert.deepEqual(targets.tokens, ['t1', 't2', 't3']);
  assert.equal(targets.tokenOwner.get('t2'), 'a');
});

test('tokens are sent in batches of at most 500', () => {
  const tokens = Array.from({ length: 1201 }, (_, i) => `t${i}`);
  const batches = chunk(tokens, MULTICAST_LIMIT);
  assert.deepEqual(
    batches.map((batch) => batch.length),
    [500, 500, 201],
  );
});

test('results are counted by reason and dead tokens are collected', () => {
  const summary = summarize([
    {
      tokens: ['t1', 't2', 't3', 't4'],
      responses: [
        { success: true },
        {
          success: false,
          error: { code: 'messaging/registration-token-not-registered' },
        },
        { success: false, error: { code: 'messaging/unavailable' } },
        {
          success: false,
          error: { code: 'messaging/registration-token-not-registered' },
        },
      ],
    },
  ]);
  assert.equal(summary.delivered, 1);
  assert.equal(summary.failed, 3);
  assert.deepEqual(summary.failureReasons, {
    'App uninstalled or token expired': 2,
    'FCM temporarily unavailable': 1,
  });
  assert.deepEqual(summary.deadTokens, ['t2', 't4']);
});

test('dead tokens are grouped by their owner', () => {
  const byOwner = deadTokensByOwner(
    ['t1', 't2', 't9'],
    new Map([
      ['t1', 'a'],
      ['t2', 'a'],
    ]),
  );
  assert.deepEqual([...byOwner], [['a', ['t1', 't2']]]);
});

test('unknown error codes are shown as they are', () => {
  assert.equal(failureReason('messaging/something-new'), 'messaging/something-new');
  assert.equal(failureReason(undefined), 'Unknown error');
});

test('the message carries the title, body and notification id', () => {
  const message = buildMessage(
    { id: 'n1', title: 'T', message: 'M', type: 'appUpdate' },
    ['t1'],
  );
  assert.deepEqual(message.notification, { title: 'T', body: 'M' });
  assert.deepEqual(message.data, { notificationId: 'n1', type: 'appUpdate' });
  assert.deepEqual(message.tokens, ['t1']);
});
