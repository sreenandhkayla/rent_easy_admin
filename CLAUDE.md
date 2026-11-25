# CLAUDE.md

Permanent project rules. Follow them whenever generating, modifying, or refactoring code in this project.

## Project Overview

A Flutter calling app (branded "Zuno") with two user types: **User** and **Host**.

Architecture: feature-based, inspired by Clean Architecture, **with no Domain layer and no abstract repository interfaces**.

| Concern | Choice |
| --- | --- |
| Structure | Feature folders plus a shared `lib/core/` |
| State management | Cubit (`flutter_bloc`) |
| Dependency injection | GetIt |
| Error handling | `fpdart` |
| Backend | Firebase, reached through Firebase Cloud Functions (future) |

`flutter_bloc`, `get_it`, and `fpdart` are the chosen libraries but are not yet in `pubspec.yaml`. Add each one when the first code that needs it is written, using a version compatible with the SDK below.

## Flutter and Dart Version

The project uses **Flutter 3.47.7**, pinned with FVM in `.fvmrc` (bundled Dart SDK 3.13.5; `pubspec.yaml` constraint `sdk: ^3.10.4`).

- Run Flutter through FVM: `fvm flutter ...`. The global `flutter` on this machine may be a different version.
- Always write code compatible with Flutter 3.47.7 and its bundled Dart SDK.
- Do not use deprecated APIs when a supported alternative exists.
- Do not use APIs, packages, or language features incompatible with the project's SDK version.
- Inspect the `pubspec.yaml` SDK constraints before making dependency changes.
- Never upgrade or downgrade Flutter or Dart.
- Preserve the existing project configuration.

## Project Structure

```text
lib/
├── main.dart                     # flavorMain(Environment): flavor setup, then app start
├── bootstrap.dart                # App-level initialization, including GetIt, before runApp()
├── zuno.dart                     # Root app widget (ZunoApp)
│
├── core/
│   ├── app_environment/
│   │   ├── config/               # FlavorConfig
│   │   └── entry_point/          # main_staging / main_production
│   ├── enums/                    # Shared enums, including Environment
│   ├── resources/                # images/, icons/, strings/, other shared resources
│   ├── di/                       # All GetIt registration
│   ├── navigation/               # All route configuration
│   ├── theme/                    # app_colors, app_text_styles, app_theme, theme_utils
│   ├── errors/                   # Failure types
│   ├── utils/                    # Reusable helpers
│   └── widgets/                  # Application-wide reusable widgets
│
└── features/
    ├── splash/
    │   └── presentation/
    ├── auth/
    │   ├── data/
    │   │   ├── datasources/
    │   │   ├── models/
    │   │   └── repositories/
    │   └── presentation/
    │       ├── pages/
    │       ├── state/            # Cubits and states
    │       └── widgets/          # Feature-specific widgets
    └── {user,host}/
        └── {home,profile,...}/   # Sub-features, each with the same data/ and presentation/ layout as auth
```

Additional subfolders are fine for organizing resources. Do not add unnecessary folders or layers.

## Flavors and Entry Points

Android flavors are defined in `android/app/build.gradle.kts` (dimension `env`):

| Flavor | `applicationIdSuffix` | `versionNameSuffix` | App name | Entry point |
| --- | --- | --- | --- | --- |
| `staging` | `.stg` | `-stg` | Zuno Staging | `lib/core/app_environment/entry_point/main_staging.dart` |
| `production` | none | none | Zuno | `lib/core/app_environment/entry_point/main_production.dart` |

`lib/main.dart` has no `main()` function, so always pass both the flavor and the target:

```bash
fvm flutter run --flavor staging -t lib/core/app_environment/entry_point/main_staging.dart
```

Responsibilities:

- **Flavor entry points** call `flavorMain(Environment.<flavor>)`.
- **`main.dart`** receives the flavor, initializes the matching environment through `FlavorConfig`, and calls the bootstrap process.
- **`bootstrap.dart`** performs application-level initialization, initializes GetIt, and completes required initialization before `runApp()`.

Rules:

- Never change the flavor configuration unless explicitly requested.
- Do not break or replace the existing flavor setup. Both flavors must keep working.
- Do not assume or invent flavor names or configurations beyond those above.

Firebase:

- **`staging`** uses the `suno-staging-aaa4d` project, configured by `android/app/src/staging/google-services.json` and `lib/core/app_environment/config/firebase_options_staging.dart`. `FlavorConfig.init()` initializes Firebase for this flavor.
- **`production`** has no Firebase project yet, so it has no Firebase config and does not initialize Firebase. Do not call Firebase APIs on this flavor until it is configured.

## Notifications

App notifications live in the root Firestore `notifications` collection, one document per notification for one user, with auto-generated document IDs. Only Cloud Functions write them, and each one is also sent as an FCM push to the user's `fcmToken` (`notification` title/body, `data: {type, notificationId}`, Android channel `zuno_default_channel`) after its write commits. Deleted or blocked accounts and users without a token get the document but no push, and a dead token is cleared. The admin dashboard's broadcasts are FCM-only and are not stored.

```text
notifications/{autoId}
  userId: String        # users document ID
  title, body: String
  type: String          # package_purchase | admin_recharge | admin_credit | admin_debit | host_approved | host_rejected | bank_account_approved | bank_account_rejected
  isRead: false
  createdAt: Timestamp  # server timestamp
  data: Map             # amounts as numbers
```

| Type | Created in (`functions/`) | `data` |
| --- | --- | --- |
| `package_purchase` | `creditRecharge` transaction, only on the pending → success credit | `packageId`, `transactionId`, `amount` (`rechargeAmount`) |
| `admin_recharge` | `addAdminRecharge` transaction, only on a new request | `transactionId`, `amount` (`rechargeAmount`) |
| `admin_credit` / `admin_debit` | `onTransactionCreated` trigger for `adminCredit` / `adminDebit` transactions with status `success` (written by the dashboard) | `transactionId`, `amount` |
| `host_approved` | `onUserWritten`, only when an existing user's `hostDetails.hostStatus` changes to `approved` | `hostId` |
| `host_rejected` | `onUserWritten`, only when an existing user's `hostDetails.hostStatus` changes to `rejected` | `hostId`, `rejectionId` (the trigger event ID) |
| `bank_account_approved` | `onBankAccountWritten`, only when an existing `bankAccounts/{hostId}` document's `bankAccountStatus` changes to `approved` (the dashboard's Payout Review) and the host's `users` document exists and is not deleted | `hostId`, `approvalId` (the trigger event ID) |
| `bank_account_rejected` | `onBankAccountWritten`, under the same conditions when `bankAccountStatus` changes to `rejected` | `hostId`, `rejectionId` (the trigger event ID) |

- Titles, bodies and types are defined once in `functions/src/notifications.js` and mirrored by `NotificationType` (`lib/core/enums/notification_type.dart`).
- Duplicates are prevented without special IDs. `package_purchase` and `admin_recharge` are written inside the existing transactions, behind their "already credited" / "already applied" checks, and pushed only after the transaction commits. The triggers create the document in a transaction that first queries for the same `type` and `data.transactionId` (or `data.hostId`) and skips if one exists, so a host gets at most one `host_approved`; `host_rejected`, `bank_account_approved` and `bank_account_rejected` match on the trigger event ID (`data.rejectionId` / `data.approvalId`), so a retried event is skipped while a later rejection or approval notifies again. So retries and duplicate webhooks never create a second notification or push.
- A rejection notification with no stored reason says only that it was rejected. Never invent a reason.
- The Notifications screen lists the signed-in user's documents (`userId` + `createdAt` composite index); the rule allows reading only your own.
- Chat pushes (`chat_message`) are not stored. `sendChatMessage` pushes a user's message to the host only while the host's `hostDetails.onlineStatus` is `online` or `busy`. Otherwise it sets `hostPushPending: true` on the `chats` document, and `onUserWritten` sends one push per held conversation when that host goes from offline to `online` (clearing the flag first, and skipping conversations the host has already read or where either side has blocked the other). Host replies to users are always pushed right away. The logic lives in `functions/src/chat_push.js`.
- Push taps are routed in `PushNotificationListener` through `AppRouter`. `adminNotification` returns to the Home tab, the stored types above open the Notifications screen, `chat_message` opens that conversation, and other types are ignored. Taps never navigate while a call screen is showing.

## 1. Architecture Rules

- Always follow the established feature-based architecture.
- Shared functionality belongs inside `lib/core/`.
- Feature-specific functionality belongs inside `lib/features/{feature_name}/`.
- There are 4 main features: `splash`, `auth`, `user`, and `host`.
- Inside the `user` and `host` features, add each piece of functionality as its own sub-feature, for example `lib/features/user/home/` and `lib/features/user/profile/`.
- Never create a Domain layer.
- Never create abstract repository interfaces.
- Never introduce unnecessary layers or abstractions, or architectural patterns that conflict with this structure.
- Avoid putting feature-specific code inside `core/`.
- Do not change the established architecture without explicit permission.

## 2. Data Flow Rules

The data flow must strictly follow:

```text
UI (Pages / Widgets)
        ↓
Cubit
        ↓
Repository (Concrete implementation)
        ↓
DataSource
        ↓
Firebase Cloud Functions
```

### Presentation

- Pages and widgets are responsible for displaying UI.
- Cubits manage presentation state and coordinate operations.
- Widgets must not directly access repositories or data sources.
- Pages must not directly perform backend operations.
- Keep UI and backend responsibilities separate.

### Repository

- Contains feature-specific data coordination and business-related data operations.
- Communicates with the appropriate data source.
- Handles mapping between data sources and presentation-facing models where appropriate.
- Uses concrete classes only. Do not create repository interfaces or abstract repository classes.

### DataSource

- Handles communication with external services.
- Future Firebase Cloud Functions integrations must be implemented here.
- Keep backend-specific implementation details inside data sources.
- Do not put Firebase-specific code inside presentation widgets or Cubits.

### Current Development Stage

The project is in its **UI development stage**. Unless explicitly requested, do not create:

- Firebase backend implementations.
- Cloud Functions.
- API integrations.
- Backend-dependent functionality.
- Firestore collections or database structures.

For UI-only development, use temporary presentation states or mock data only when explicitly needed. Do not introduce backend abstractions just to support UI development.

## 3. State Management Rules

Use `flutter_bloc` with Cubit.

- Use Cubit for feature-level state management.
- Keep state management inside `presentation/state/`.
- Keep Cubits focused on their respective features.
- Do not put UI logic inside repositories.
- Do not put backend logic inside Cubits.
- Use immutable states.
- Follow consistent naming: `auth_cubit.dart`, `auth_state.dart`, `user_cubit.dart`, `user_state.dart`, `host_cubit.dart`, `host_state.dart`.
- Do not use Provider, Riverpod, or other state management solutions unless explicitly requested.

## 4. Dependency Injection Rules

Use GetIt for dependency injection.

- Centralize all dependency registration inside `core/di/`.
- Register dependencies in the correct order: data sources, then repositories, then Cubits.
- Do not instantiate dependencies manually inside widgets or pages.
- Do not use unnecessary global service instances.
- Use dependency injection whenever a dependency needs to be shared or managed.
- Dependency initialization must happen through `bootstrap.dart` before `runApp()`.

## 5. Error Handling Rules

Use `fpdart` for functional error handling.

- Prefer `Either<Failure, T>` for operations that can fail.
- Use appropriate failure types defined inside `core/errors/`.
- Keep error handling consistent across features.
- Avoid throwing exceptions for expected application failures.
- Convert external exceptions into meaningful application failures at the appropriate layer.
- Avoid repetitive error-handling implementations.
- Keep failure handling separate from presentation logic.
- Do not introduce another error-handling library or pattern unless explicitly requested.

## 6. Core Reusability Rules

Before creating any new shared component, utility, or helper:

1. Check whether a similar implementation already exists in `core/`.
2. Check whether an existing widget can be extended or reused.
3. Check existing utilities and helper functions.
4. Check existing constants and resources.
5. Reuse existing implementations whenever possible.

Avoid duplicate implementations.

### Shared Widgets

- Reusable application-wide widgets go inside `core/widgets/`.
- Feature-specific widgets stay inside their feature's `presentation/widgets/`.
- Do not create duplicate widgets when an existing shared widget can be reused.
- Common UI components must be reusable across User, Host, and Auth whenever appropriate.
- Do not put feature-specific UI components inside `core/widgets/`.

### Utilities

- Reusable helper functions belong inside `core/utils/`.
- Avoid duplicating utility methods across features.
- Keep utilities focused and reusable.
- Check for existing utility methods before implementing new ones.

### Resources

- Centralize images, icons, strings, and other shared resources inside `core/resources/`.
- Never use asset paths directly in code. Add every asset path to `AppImages` (`core/resources/images/app_images.dart`) and reference that constant.
- Reuse centralized resources wherever possible.

## 7. UI Component Organization and Widget Extraction

**Important: always follow this when creating or modifying screens.**

Keep the main page file small, clean, and readable. Never implement an entire complex screen inside one large page file.

### Widget Extraction

- Break complex UI sections into smaller, focused widgets.
- Extract logically independent UI sections into separate widget files.
- Keep the main page responsible primarily for composing the screen from smaller widgets.
- Avoid unnecessarily large `build()` methods.
- Use meaningful widget names that describe their responsibilities.
- Extract widgets whenever doing so improves readability, maintainability, or reusability.
- Avoid excessive extraction of trivial one-line UI elements.

### Widget Placement

**Application-wide reusable widgets** go in `lib/core/widgets/`:

- Common buttons, text fields, loading indicators, dialogs, and app bars.
- Common empty-state and error-state widgets.
- Other reusable application-wide components.

**Feature-specific widgets** go in `lib/features/{feature_name}/presentation/widgets/`, or `lib/features/{user,host}/{sub_feature}/presentation/widgets/` for User and Host:

- User-specific and Host-specific dashboard sections.
- Authentication-specific form sections.
- Feature-specific cards and UI components.

### Before Creating a New Widget

1. Check whether an equivalent widget already exists in `core/widgets/`.
2. If it exists, reuse it instead of creating another implementation.
3. If a new widget can be reused across multiple features, place it inside `core/widgets/`.
4. If it is specific to one feature or screen, place it inside that feature's `presentation/widgets/`.

### Main Page Responsibilities

The main screen file should:

- Compose the overall screen layout.
- Organize and arrange extracted widgets.
- Connect the appropriate Cubit state to the UI.
- Handle screen-level interactions when appropriate.

It should not contain hundreds of lines of unrelated widget implementations.

**Goal:** every screen is modular, readable, maintainable, and easy to modify without making the main page file unnecessarily large.

### Safe Area and System Bars

**Always consider these when building UI, especially when creating a new screen.**

- Use `SafeArea` so content stays clear of the status bar, notches, and navigation bar. Backgrounds may extend behind the system bars, but content must not.
- Set the status bar and navigation bar colors with `AnnotatedRegion<SystemUiOverlayStyle>`, including icon brightness, so they match the screen and the icons stay readable.
- Take these colors from the theme. Do not hardcode them.

### Overflow Handling

- Always consider the possibility of overflow when building UI, including long text, small screens, and large system font sizes.
- Choose overflow fixes with UX in mind. The user should still be able to see the full content.
- Do not use `TextOverflow.ellipsis` or other truncation as the default fix, because it hides text from the user. Prefer layouts that adapt, such as wrapping text onto more lines, `Flexible` or `Expanded`, `Wrap`, or scrolling.

## 8. Theme and Styling Rules

The centralized theme system lives inside `lib/core/theme/`:

```text
lib/core/theme/
├── app_colors.dart
├── app_text_styles.dart
├── app_theme.dart
└── theme_utils.dart
```

**The application theme has been provided and implemented.** Brand yellow `#FDC903`, fonts Unbounded (headings/titles) and Poppins (body/labels), bundled in `assets/fonts/`. The app runs `ThemeMode.light`; the dark theme exists but is not enabled.

- `AppColors`: every raw color, gradient and shadow (light and `dark*` counterparts).
- `AppTextStyles`: font families, all text styles, and the uncolored `textTheme`.
- `AppTheme`: `AppTheme.light` / `AppTheme.dark` plus shape tokens (`radiusSmall/Medium/Large`, `buttonHeight`).
- `theme_utils.dart`: `AppThemeColors` (a `ThemeExtension` for brightness-aware semantic colors such as status badges, call gradients and the message input bar) and the `ThemeUtils` extension on `BuildContext` (`context.appColors`, `context.textTheme`, `context.colorScheme`, `context.isDarkMode`).

Rules:

- Use `AppColors` for colors.
- Use `AppTextStyles` for typography.
- Use `AppTheme` for application theme configuration.
- Use `ThemeUtils` for theme-related utilities, including dark-mode handling.
- Support light and dark themes according to the provided theme. In widgets, prefer `context.appColors` / `context.colorScheme` over raw `AppColors` so dark mode works.
- Never hardcode colors inside widgets.
- Never duplicate text styles.
- Do not use arbitrary font sizes, font weights, or colors when centralized styles already exist.
- Prefer extending existing theme definitions over creating feature-specific global styling systems.
- Respect the established application design system.
- If a required style or color does not exist, add it to the appropriate centralized theme file instead of hardcoding it inside a widget.

## 9. Navigation Rules

- Centralize navigation configuration inside `core/navigation/`.
- Do not scatter route definitions throughout the application.
- Follow the existing navigation implementation once one exists.
- Keep feature pages independent of navigation implementation details wherever possible.
- Avoid defining the same route in multiple places.

## 10. Naming Conventions

- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables and methods: `camelCase`
- Constants: follow the existing project convention.
- Cubits: `{Feature}Cubit`
- States: `{Feature}State`
- Repositories: `{Feature}Repository`
- Data sources: `{Feature}RemoteDataSource` or an appropriate descriptive name.
- User home page: `user_home_page.dart`
- Host home page: `host_home_page.dart`

Use descriptive names that reflect actual responsibilities. Do not mix User and Host presentation logic. Keep feature-specific functionality within its respective feature.

## 11. Flutter Development Standards

- Write clean, readable, maintainable Dart code.
- Follow SOLID principles where appropriate, without unnecessary abstraction.
- Prefer small, focused widgets, and extract reusable widgets when appropriate.
- Avoid large monolithic widgets and unnecessarily large screen files.
- Avoid unnecessary rebuilds.
- Dispose controllers, subscriptions, and other resources correctly.
- Handle loading, success, empty, and error states.
- Write null-safe Dart code.
- Avoid unnecessary dependencies.
- Follow Flutter 3.47.7 and Dart best practices.
- Maintain existing project conventions.
- Do not add code comments unless explicitly asked.

## 12. Important Development Restrictions

- Never modify existing functionality without understanding its dependencies.
- Never change the existing flavor configuration unless explicitly requested.
- Never introduce new packages without a valid reason.
- Never duplicate existing utilities, widgets, theme definitions, or constants.
- Never bypass Cubit to access repositories directly from UI.
- Never communicate with Firebase directly from presentation widgets.
- Never create Cloud Functions unless explicitly requested.
- Never create a Domain layer.
- Never introduce abstract repository classes.
- Never move shared functionality into feature folders, or feature-specific functionality into core, without a clear reason.
- Never implement a complete complex screen inside one large Dart file.
- Always extract appropriate UI sections into separate widget files.
- Always check and reuse common widgets from `core/widgets/`.
- Never populate the theme files until the actual theme is provided.
- Never change the Flutter SDK version.
