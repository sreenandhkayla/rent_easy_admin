'use strict';

const { applicationDefault, initializeApp } = require('firebase-admin/app');
const { FieldPath, getFirestore } = require('firebase-admin/firestore');

const PROJECT_ID = 'rental-management-dev-9a1b0';
const COLLECTION = 'shops';
const FIELD = 'isRestricted';
const PAGE_SIZE = 500;

async function main() {
  const write = process.argv.includes('--write');
  initializeApp({ credential: applicationDefault(), projectId: PROJECT_ID });
  const firestore = getFirestore();

  console.log(`Firebase project: ${PROJECT_ID}`);
  console.log(write ? 'Mode: WRITE' : 'Mode: dry run (pass --write to apply)');

  const writer = write ? firestore.bulkWriter() : null;
  let failed = 0;
  writer?.onWriteError((error) => {
    failed += 1;
    console.error(`Skipped ${error.documentRef.id}: ${error.message}`);
    return false;
  });

  let scanned = 0;
  let missing = 0;
  let last = null;
  for (;;) {
    let query = firestore
      .collection(COLLECTION)
      .orderBy(FieldPath.documentId())
      .limit(PAGE_SIZE);
    if (last) query = query.startAfter(last);
    const snapshot = await query.get();
    if (snapshot.empty) break;
    for (const document of snapshot.docs) {
      scanned += 1;
      if (typeof document.get(FIELD) === 'boolean') continue;
      missing += 1;
      console.log(`${write ? 'Setting' : 'Would set'} ${FIELD}=false on ${document.id}`);
      writer?.update(
        document.ref,
        { [FIELD]: false },
        { lastUpdateTime: document.updateTime },
      );
    }
    last = snapshot.docs[snapshot.docs.length - 1];
  }

  await writer?.close();
  console.log(`Scanned ${scanned} shops, ${missing} without a boolean ${FIELD}.`);
  if (write) console.log(`Updated ${missing - failed}, skipped ${failed}.`);
  if (failed > 0) {
    console.log('Skipped shops changed while the script ran. Run it again to retry them.');
    process.exitCode = 1;
  }
}

main().catch((error) => {
  if (error.code === 'app/invalid-credential') {
    console.error(
      'No usable credentials found. Set GOOGLE_APPLICATION_CREDENTIALS to a ' +
        `service account key for ${PROJECT_ID}, stored outside this repository.`,
    );
  } else {
    console.error(error.code ? `${error.code}: ${error.message}` : error.message);
  }
  process.exitCode = 1;
});
