# Admin notification functions

One Cloud Function, `sendQueuedNotification`, sends the push notifications that
admins create in the dashboard (Notifications page).

## How it works

1. In the dashboard, **Review & send** sets `notifications/{id}.status` to
   `queued`.
2. The function runs when a document becomes `queued`. It switches the status
   to `sending` in a transaction first, so a notification is never sent twice.
3. It checks that `queuedByUid` belongs to an active admin who is a Super Admin
   or has the `notifications` permission. If not, the notification is marked
   `failed` with a reason.
4. It finds the audience:
   - `allOwners`: every `users` document.
   - `subscribedShops`: owners (`shops.ownerId`) of shops whose
     `subscriptionStatus` is `active`.
   - `expiredSubscriptionShops`: the same for `expired`.

   Deleted (`isDeleted: true`) and blocked (`isAccountBlocked: true`) owners
   are skipped, and each owner gets one copy even with several shops.
5. It sends to the owners' devices with FCM, 500 devices per batch, removes
   tokens FCM reports as dead from the owner's `fcmTokens`, and writes the
   result back:

| Field | Meaning |
| --- | --- |
| `status` | `sent`, or `failed` with `error` |
| `sentAt` / `failedAt` | When it finished |
| `recipients` | Owners in the audience |
| `devices` | Device tokens targeted |
| `ownersWithoutDevices` | Owners with no token saved |
| `delivered` / `failed` | Devices FCM accepted / rejected |
| `failureReasons` | Map of reason to device count |

## What the Owner App must do

Save each phone's FCM token on the signed-in owner's document:

```
users/{ownerUid}.fcmTokens: ["token-1", "token-2"]
```

- Add the token with `FieldValue.arrayUnion` after sign-in and whenever
  `FirebaseMessaging.instance.onTokenRefresh` fires.
- Remove it with `FieldValue.arrayRemove` on logout.
- Ask for notification permission first (required on iOS and Android 13+).

Without saved tokens nobody receives a push; the dashboard then shows the owners
under "Owners with no device registered".

The push carries `data.notificationId` and `data.type` so the app can open the
right screen when the owner taps it.

## Deploy

Requires the Firebase **Blaze** plan. From the repository root:

```bash
cd functions
npm install
npm test
cd ..
firebase deploy --only functions:admin --project rental-management-dev-9a1b0
```

The function runs in `asia-south1`, next to the Firestore database. It is
deployed under the `admin` codebase, so deploying from here never deletes
functions that another repository deploys to the same project.

Logs: Firebase console > Functions > `sendQueuedNotification` > Logs.
