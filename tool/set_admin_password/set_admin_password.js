'use strict';

const readline = require('node:readline/promises');
const { applicationDefault, initializeApp } = require('firebase-admin/app');
const { getAuth } = require('firebase-admin/auth');

const PROJECT_ID = 'rental-management-dev-9a1b0';
const MIN_PASSWORD_LENGTH = 10;

async function ask(question) {
  const prompt = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });
  try {
    return (await prompt.question(question)).trim();
  } finally {
    prompt.close();
  }
}

function askHidden(question) {
  return new Promise((resolve, reject) => {
    const { stdin, stdout } = process;
    let value = '';

    const finish = (settle, result) => {
      stdin.setRawMode(false);
      stdin.pause();
      stdin.removeListener('data', onData);
      stdout.write('\n');
      settle(result);
    };

    const onData = (chunk) => {
      for (const character of chunk.toString('utf8')) {
        if (character === '\r' || character === '\n') {
          return finish(resolve, value);
        }
        if (character === '\u0003') {
          return finish(reject, new Error('Cancelled.'));
        }
        if (character === '\u007f' || character === '\b') {
          value = value.slice(0, -1);
        } else if (character >= ' ') {
          value += character;
        }
      }
    };

    stdout.write(question);
    stdin.setRawMode(true);
    stdin.resume();
    stdin.on('data', onData);
  });
}

async function askNewPassword() {
  const password = await askHidden(
    `New password (at least ${MIN_PASSWORD_LENGTH} characters, hidden): `,
  );
  if (password.length < MIN_PASSWORD_LENGTH) {
    throw new Error(`Password must be at least ${MIN_PASSWORD_LENGTH} characters.`);
  }
  if ((await askHidden('Confirm password (hidden): ')) !== password) {
    throw new Error('The passwords do not match.');
  }
  return password;
}

function explain(error) {
  switch (error.code) {
    case 'auth/user-not-found':
      return 'No sign-in exists for that email. Add the admin from Settings > Admin staff instead.';
    case 'auth/invalid-password':
      return 'Firebase rejected that password. Choose a different one.';
    case 'app/invalid-credential':
    case 'auth/invalid-credential':
      return (
        'No usable credentials found. Set GOOGLE_APPLICATION_CREDENTIALS to a ' +
        `service account key for ${PROJECT_ID}, stored outside this repository.`
      );
    case 'auth/insufficient-permission':
      return `These credentials are not allowed to manage users in ${PROJECT_ID}.`;
    default:
      return error.code ? `${error.code}: ${error.message}` : error.message;
  }
}

async function main() {
  if (!process.stdin.isTTY) {
    throw new Error(
      'Run this in an interactive terminal such as PowerShell. Passwords cannot be piped or passed as arguments.',
    );
  }

  initializeApp({ credential: applicationDefault(), projectId: PROJECT_ID });
  const auth = getAuth();

  console.log(`Firebase project: ${PROJECT_ID}`);
  const email = (await ask('Admin email: ')).toLowerCase();
  const user = await auth.getUserByEmail(email);
  console.log(`Found sign-in ${user.uid}${user.disabled ? ' (disabled)' : ''}.`);

  const password = await askNewPassword();
  const answer = await ask(`Set this as the new password for ${email}? [y/N]: `);
  if (answer.toLowerCase() !== 'y') {
    console.log('Left unchanged.');
    return;
  }
  await auth.updateUser(user.uid, { password });
  console.log('Password updated. Sign in with this email and the new password.');
  if (user.disabled) {
    console.log(
      'This sign-in is disabled in Firebase Authentication. Enable it in the Firebase console before signing in.',
    );
  }
}

main()
  .catch((error) => {
    console.error(explain(error));
    process.exitCode = 1;
  })
  .finally(() => process.stdin.destroy());
