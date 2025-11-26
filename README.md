# Movie Night Recommender

A beautiful, feature-rich Flutter movie recommendation application powered by The Movie Database (TMDb) API.

## Features

✨ **Complete Movie Experience**
- 🔐 Firebase Authentication (Email, Google, Apple Sign-In)
- 🔒 Biometric Local Authentication
- 🎬 Movie Discovery (Trending, Popular, Top-Rated)
- 🔍 Real-time Search
- 📖 Detailed Movie Information with Cast
- 💾 Persistent Watchlist (Offline Storage)
- 🎨 Premium Dark Theme with Smooth Animations
- 🌍 Localization Support (EN/AR)

## Screenshots

> Add screenshots here when available

## Architecture

**MVVM Pattern with BLoC State Management**
- Feature-first folder structure
- Hydrated BLoC for state persistence
- Repository pattern for data layer
- Clean separation of concerns

## Tech Stack

- **Framework**: Flutter 3.29.0-0.0.pre.17
- **State Management**: flutter_bloc, hydrated_bloc
- **Authentication**: Firebase Auth
- **API**: TMDb API
- **Local Storage**: Hydrated BLoC
- **UI Components**: Cached Network Image, Shimmer, Smooth Page Indicator
- **Animation**: Page Transition, Flutter Animate

## Getting Started

### Prerequisites

- Flutter SDK (3.x or higher)
- Dart SDK
- Android Studio or VS Code
- Firebase Account
- TMDb API Key

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/movie_night_recommender.git
   cd movie_night_recommender
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add Android/iOS apps to your Firebase project
   - Download `google-services.json` (Android) and place in `android/app/`
   - Download `GoogleService-Info.plist` (iOS) and place in `ios/Runner/`
   - Or run: `flutterfire configure`

4. **Set up TMDb API**
   - Create an account at [TMDb](https://www.themoviedb.org/)
   - Get your API key from [API Settings](https://www.themoviedb.org/settings/api)
   - Create `lib/core/constants/api_constants.dart`:
     ```dart
     class ApiConstants {
       static const String apiKey = 'YOUR_TMDB_API_KEY';
       static const StringbaseUrl = 'https://api.themoviedb.org/3';
     }
     ```

5. **Run the app**
   ```bash
   flutter run
   ```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/watchlist_bloc_test.dart

# Run with coverage
flutter test --coverage
```

## Project Structure

```
lib/
├── core/
│   ├── network/         # API client
│   ├── services/        # Local auth service
│   └── theme/           # App theme
├── data/
│   ├── models/          # Data models
│   └── repositories/    # Data repositories
├── features/
│   ├── auth/            # Authentication feature
│   ├── onboarding/      # Onboarding flow
│   ├── home/            # Home & Discovery
│   ├── movie_detail/    # Movie details
│   ├── search/          # Search functionality
│   └── watchlist/       # Watchlist management
└── l10n/                # Localization files
```

## Development Phases

- [x] Phase 1: Setup & Core Architecture
- [x] Phase 2: Authentication (Firebase)
- [x] Phase 3: Onboarding & Local Auth
- [x] Phase 4: Home & Discovery
- [x] Phase 5: Movie Details
- [x] Phase 6: Search & Recommendations
- [x] Phase 7: Watchlist (Hydrated)
- [x] Phase 8: Polish & Testing

## Git Workflow

This project follows a feature-branch workflow:
- `master` - Production-ready code
- `development` - Integration branch
- `feature/*` - Feature branches (merged to development)

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [The Movie Database (TMDb)](https://www.themoviedb.org/) for the API
- [Flutter](https://flutter.dev/) team for the amazing framework
- [Bloc Library](https://bloclibrary.dev/) for state management

## Contact

For questions or feedback, please open an issue on GitHub.

---

**Note**: This app uses the TMDb API but is not endorsed or certified by TMDb.
