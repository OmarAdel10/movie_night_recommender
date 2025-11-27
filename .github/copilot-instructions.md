<!-- Auto-generated guidance for AI coding agents working on this repo. -->

# Copilot / AI Agent Instructions

Purpose: Give focused, actionable guidance so an AI can be productive immediately in this Flutter app.

**Project Snapshot**

- **Architecture**: Feature-first MVVM using BLoC (see `lib/` layout and `implementation_plan.md`).
- **State persistence**: `hydrated_bloc` is used; storage initialized in `lib/main.dart` (`HydratedBloc.storage = ...`).
- **Auth & backend**: Firebase Auth (firebase files under `android/app/` and `ios/Runner/`), TMDb API for movie data.

**What to read first**

- `lib/main.dart` — app bootstrap, `HydratedBloc` init, `MultiRepositoryProvider` and `MultiBlocProvider` wiring, and route map (see `/movie-detail` example).
- `pubspec.yaml` — dependencies and Flutter-specific generation (`flutter.generate: true`, l10n settings).
- `implementation_plan.md` and root `README.md` — high-level architecture and feature breakdown.
- Feature folders under `lib/features/*` — each feature follows the pattern: `data/`, `view_models/`, `views/`.

**Key patterns & examples (use these as templates)**

- Feature-first layout: for example `lib/features/watchlist/view_models/watchlist_bloc.dart` (tests at `test/watchlist_bloc_test.dart`).
- Repository pattern: `AuthRepository`, `MovieRepository` are provided in `lib/main.dart` and injected via `RepositoryProvider`.
- Bloc usage: `BlocProvider(create: (_) => AuthBloc(...))` and `BlocBuilder<SettingsBloc, SettingsState>` control app themes and locale.
- Route with args: the `/movie-detail` route expects `settings.arguments` to be a `Map<String, dynamic>` with keys `movieId` (int) and optional `heroTag` (String).
- HydratedBloc serialization: check `toJson`/`fromJson` implementations in bloc classes (see watchlist tests for expectations).

**Environment & secrets**

- TMDb API key: not checked in. Place the key in `lib/core/constants/api_constants.dart` (example in `README.md`).
- Firebase config: `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist` are required for auth flows. `main.dart` notes using `flutterfire configure`.

**Developer workflows & commands**

- Install deps: `flutter pub get`
- Run app (device/emulator): `flutter run`
- Run tests: `flutter test` (or `flutter test test/watchlist_bloc_test.dart` for a single test file)
- Generate Firebase options if missing: `flutterfire configure` (this will generate `firebase_options.dart`).
- Localization: Flutter's `generate: true` is enabled in `pubspec.yaml`; run typical Flutter build/generate commands (`flutter pub get` then `flutter run`) to regenerate generated files.

**What to avoid / common pitfalls**

- Do NOT hardcode API keys in source. Use `lib/core/constants/api_constants.dart` or environment-based injection.
- Hydrated state depends on a storage implementation. When writing tests, mock `HydratedBloc.storage` as the existing tests do (see `test/watchlist_bloc_test.dart`).
- Changing route names requires updating `onGenerateRoute` in `lib/main.dart` and all callers that push routes with arguments.

**Concrete change examples**

- To add a new feature `ratings`: create `lib/features/ratings/{data,view_models,views}`; register a `RatingsRepository` in `main.dart` and add a `BlocProvider` in `MultiBlocProvider`.
- To add a new API endpoint: update repository under `lib/data/repositories`, add model under `lib/data/models`, then expose via a Bloc in the relevant feature's `view_models`.

**Tests & mocks**

- Tests use `bloc_test` + `mocktail`. For `HydratedBloc`, tests replace `HydratedBloc.storage` with a mock (`MockStorage`) — copy the pattern from `test/watchlist_bloc_test.dart`.

**If you need more context**

- Look at `lib/core/services/local_auth_service.dart` for local biometric auth flows used by `RootScreen`.
- Look at `lib/core/theme/app_theme.dart` for theme and dark-mode handling (used by `SettingsBloc`).
- For localization strings, check `lib/l10n/` and generated localization classes referenced in `main.dart` (`AppLocalizations`).

If any section is unclear or you need more examples (for a specific feature or workflow), say which area and I will expand the file with code snippets or an annotated walkthrough.
