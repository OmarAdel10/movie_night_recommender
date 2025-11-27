# App Workflow — Movie Night Recommender

This document describes runtime flow, data flows, and developer actions needed to run and change the app. Use it as a quick reference when implementing features or debugging behavior.

## App bootstrap

- Entry: `lib/main.dart`.

- Responsibilities in `main()`:
  - Initialize Firebase: `Firebase.initializeApp()` (project-specific `google-services.json` / `GoogleService-Info.plist` required for Android/iOS).
  - Build `HydratedBloc.storage` (uses `path_provider` for non-web platforms).
  - Instantiate repositories and services:
    - `AuthRepository` (Firebase wrapper)
    - `MovieRepository` (TMDb API client)
    - `LocalAuthService` (biometric/pin helper)
  - Run `MovieNightApp(...)` with repositories provided via `RepositoryProvider`.

## Dependency injection and state providers

- Repositories and services are injected using `MultiRepositoryProvider` (see `MovieNightApp.build`).

- Global Blocs are created via `MultiBlocProvider`:
  - `AuthBloc` — user session management
  - `OnboardingBloc` — tracks whether onboarding was seen
  - `WatchlistBloc` — persisted watchlist (extends HydratedBloc)
  - `SettingsBloc` — theme, locale, local-auth flag

## Root screen & initial flow (auth + onboarding + local-auth)

- `RootScreen` checks `SettingsBloc` to decide whether local auth is enabled.

- If local auth is enabled, it calls `LocalAuthService.isDeviceSupported()` then `LocalAuthService.authenticate()`.

- If authentication fails, `RootScreen` shows a simple retry screen.

- After local-auth, the app consults `OnboardingBloc`:
  - If onboarding hasn't been seen, the app shows `OnboardingScreen`.
  - Otherwise, the app inspects `AuthBloc`:
    - If `AuthStatus.authenticated` → `MainScreen` (home)
    - Else → `LoginScreen`

## Navigation and route contracts

- `MaterialApp.onGenerateRoute` defines transitions for common screens. Special note:
  - `/movie-detail` expects `settings.arguments` to be `Map<String, dynamic>` with:
    - `movieId` (int) — required
    - `heroTag` (String?) — optional

## Data flow: TMDb API and repositories

- `MovieRepository` encapsulates TMDb HTTP requests (base URL in `lib/core/constants/api_constants.dart`).

- Poster/backdrop URLs are formed using `imageBaseUrl` / `imageOriginalUrl`.

- Add API key to `lib/core/constants/api_constants.dart` or wire a secure injection mechanism; do NOT commit keys to git.

## Persistence and tests

- `WatchlistBloc` extends `HydratedBloc` and serializes state via `toJson`/`fromJson`. Tests mock `HydratedBloc.storage` (see `test/watchlist_bloc_test.dart`).

- To run tests locally:

```bash
flutter pub get
flutter test
```

## Developer checklist to verify the workflow locally

- Ensure Firebase config files are present for the target platform:
  - Android: `android/app/google-services.json`
  - iOS: `ios/Runner/GoogleService-Info.plist`
  - Or run: `flutterfire configure` to create `firebase_options.dart` and wire initialization.

- Add TMDb key to `lib/core/constants/api_constants.dart`.

- Run `flutter pub get` then `flutter run` on an emulator or device.

- Verify onboarding appears on fresh installs, local-auth prompts when enabled, and watchlist persists across app restarts.

## Common pain points & quick fixes

- Missing Firebase files: app will still compile but auth flows will fail at runtime — add configs or stub auth in debug.

- Hydrated storage errors in tests: mock `HydratedBloc.storage` with a `MockStorage` in tests.

- Route argument errors: ensure callers pushing `/movie-detail` pass a `Map` containing `movieId`.

## How to add a feature (quick recipe)

- Create feature folder `lib/features/<name>/{data,view_models,views}`.

- Implement repository or add endpoints to `lib/data/repositories` if needed.

- Register repository in `main.dart` `MultiRepositoryProvider`.

- Add a Bloc in `view_models` and register in `MultiBlocProvider`.

- Add routes to `onGenerateRoute` if you need named transitions.

If you'd like, I can also:

- Add a small integration test that boots `RootScreen` with mocked services and validates the onboarding/auth branching.

- Provide a template PR that adds `firebase_options.dart` wiring for CI/dev safely (requires Firebase project credentials).

---
File created by AI assistant — ask to iterate on any section you want expanded or converted into checklists/issue templates.
