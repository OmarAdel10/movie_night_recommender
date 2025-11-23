# Movie Night Recommender - Development Plan

## Goal Description
Create a Flutter mobile application called "Movie Night Recommender" that allows users to discover, search, and save movies. The app will use **Hydrated Bloc** for state management to ensure persistent state across app restarts. We will use **The Movie Database (TMDb) API** for fetching movie data.

> [!NOTE]
> **Design Decision**: I cannot access Stitch. I have generated a mockup (`movie_night_home_screen.png`) to visualize the **"Premium Movie Night"** theme.
> **Theme**: Deep Navy/Black (`#0F0F1A`) with Vibrant Red (`#E50914`) accents.
> **Typography**: `Outfit` (Google Font) for a modern, clean look.

## Proposed Design System
- **Color Palette**:
    - **Background**: `#0F0F1A` (Deep Navy)
    - **Surface**: `#1C1C2E` (Soft Navy for cards/modals)
    - **Accent**: `#E50914` (Netflix-style Red)
    - **Text**: `#FFFFFF` (Primary), `#A0A0B0` (Secondary)
- **Typography**: `Outfit` (Headers: Bold, Body: Regular).
- **UI Elements**:
    - **Glassmorphism**: Used on the Bottom Navigation Bar and floating headers.
    - **Cards**: Rounded corners (16px), subtle shadows.
    - **Animations**: Hero widgets for poster transitions, staggered list animations.

## Proposed Changes

### Phase 1: Setup & Core Architecture
- Initialize Flutter project.
- Add dependencies: 
    - **Core**: `flutter_bloc`, `hydrated_bloc`, `dio`, `google_fonts`, `cached_network_image`, `flutter_svg`, `path_provider`, `equatable`, `intl`, `cupertino_icons`.
    - **Auth**: `firebase_core`, `firebase_auth`, `google_sign_in`, `sign_in_with_apple`.
    - **UI/UX**: `flutter_animate`, `page_transition`, `shimmer`, `smooth_page_indicator`.
    - **Features**: `local_auth`.
    - **Dev**: `flutter_launcher_icons`, `bloc_test`, `mocktail`, `flutter_test`.
- **Architecture**: Implement **Feature-First MVVM** pattern. Each feature (e.g., `auth`, `home`) will have its own folder containing:
    - `data/` (Models, Repositories, Data Sources)
    - `view_models/` (Blocs/Cubits)
    - `views/` (Screens, Widgets)
    - Example: `lib/features/auth/data`, `lib/features/auth/view_models`, `lib/features/auth/views`.
- Setup `hydrated_bloc` storage.
- **Localization**: Configure `intl` for English (en) and Arabic (ar).
- **Theme**: Setup `AppTheme` with Dark Mode and Cupertino support.
- Implement `MovieRepository` with TMDb API.

### Phase 2: Authentication (MVVM)
- **Setup**: Initialize Firebase project (iOS/Android).
- **ViewModel**: `AuthBloc` (manages user session, login, signup, logout).
    - **Session Persistence**: Check `FirebaseAuth.instance.currentUser` on app start to auto-login.
- **Views**:
    - `LoginScreen`: Email/Password inputs, "Sign in with Google/Apple" buttons.
    - `SignUpScreen`: Name, Email, Password inputs.
    - `ForgotPasswordScreen`: Email input for reset link.
- **Repository**: `AuthRepository` (wraps Firebase Auth methods).

### Phase 3: Onboarding & Local Auth
- **Onboarding**:
    - Create `OnboardingScreen` with `smooth_page_indicator`.
    - Slides explaining features.
    - Persist "seen onboarding" state.
- **Local Auth**:
    - Implement Biometric/PIN authentication using `local_auth` on app startup.

### Phase 4: Feature - Home & Discovery
- **ViewModel**: `HomeBloc` (fetches Trending, Popular, Top Rated).
- **View**:
    - `HomeScreen`: Main dashboard with `shimmer`.
    - `MovieCarousel`: Horizontal lists.
    - Animations: `flutter_animate`.

### Phase 5: Feature - Movie Details
- **ViewModel**: `MovieDetailBloc`.
- **View**:
    - `MovieDetailScreen`: Backdrop, poster, synopsis, cast.
    - Transitions: `page_transition`.

### Phase 6: Feature - Search & Recommendations
- **ViewModel**: `SearchBloc`.
- **View**: `SearchScreen` with localized text.

### Phase 7: Feature - Watchlist (Hydrated)
- **ViewModel**: `WatchlistBloc`.
- **View**: Grid view of saved movies.

### Phase 8: Polish & Testing
- **Icons**: Generate app icons.
- **Testing**: Unit tests for ViewModels.
- **Localization**: Ensure all strings are translated (EN/AR).

## Verification Plan

### Automated Tests
- **Unit Tests**: Test Blocs (HomeBloc, WatchlistBloc) to ensure states emit correctly and HydratedBloc restores state.
- **Widget Tests**: Verify `MovieCarousel` renders items correctly.

### Manual Verification
- **API Integration**: Verify movies load from TMDb.
- **Persistence**: Add a movie to watchlist, restart app, verify it remains.
- **Navigation**: Verify flow from Home -> Details -> Back.
