# MagicSlides

A Flutter application for generating AI-powered presentations using the MagicSlides API.

## Features

- 🎨 AI-powered presentation generation
- 🔐 User authentication (Sign up/Sign in)
- 📱 Cross-platform (iOS & Android)
- 🌐 WebView-based PPT preview
- 📥 Download presentations to device
- 🔗 Open presentations in Google Slides
- 📡 Internet connectivity checking
- 💾 Offline-first architecture

## How to Run

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / Xcode
- FVM (Flutter Version Management) - optional but recommended

### Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd indianappguy
   ```

2. **Install dependencies**
   ```bash
   fvm flutter pub get
   # or
   flutter pub get
   ```

3. **Configure environment variables**
   
   Create a `.env` file in the project root:
   ```env
   MAGICSLIDES_ACCESS_ID=your_access_id_here
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

4. **Run the app**
   ```bash
   fvm flutter run
   # or
   flutter run
   ```

## Database

**Supabase** (PostgreSQL-based)

- **Authentication**: Email/password authentication
- **User Management**: User profiles and session management
- **Storage**: File storage for user data

### Database Schema

- `users`: User authentication and profile data
- Session management handled by Supabase Auth

## Architecture

### MVVM (Model-View-ViewModel) Pattern

```
lib/
├── models/          # Data models
│   └── ppt_request_model.dart
├── views/           # UI screens
│   ├── login_view.dart
│   ├── signup_view.dart
│   ├── home_view.dart
│   ├── result_view.dart
│   └── loading_view.dart
├── viewmodels/      # Business logic
│   ├── auth_viewmodel.dart
│   └── home_viewmodel.dart
├── services/        # API & utilities
│   ├── ppt_api_service.dart
│   ├── storage_service.dart
│   └── connectivity_service.dart
└── widgets/         # Reusable components
    └── custom_input.dart
```

### Key Components

**Views (UI Layer)**
- Stateless/Stateful widgets
- Consume ViewModels via Provider
- Handle user interactions

**ViewModels (Business Logic)**
- Manage state using `ChangeNotifier`
- Coordinate between services and views
- Handle data transformation

**Services (Data Layer)**
- API communication (`ppt_api_service.dart`)
- File operations (`storage_service.dart`)
- Network checking (`connectivity_service.dart`)

**State Management**
- Provider pattern for dependency injection
- ChangeNotifier for reactive state updates

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `provider` | State management |
| `supabase_flutter` | Authentication & database |
| `webview_flutter` | PPT preview |
| `dio` | HTTP client for downloads |
| `connectivity_plus` | Network status checking |
| `url_launcher` | Open external URLs |
| `syncfusion_flutter_pdfviewer` | PDF viewing |
| `share_plus` | File sharing |
| `path_provider` | File system access |

## Known Issues

### 1. **Google Slides Integration**
- **Issue**: Opening presentations in Google Slides may not work on all devices
- **Workaround**: Use the download button to save the file locally
- **Status**: Investigating alternative URL schemes

### 2. **Android Storage Permissions**
- **Issue**: On Android 11+, downloads may fail without proper permissions
- **Workaround**: Manually grant storage permissions in device settings
- **Status**: Scoped storage implementation planned

### 3. **WebView Loading**
- **Issue**: Large presentations may take time to load in WebView
- **Workaround**: Loading indicator is shown during load
- **Status**: Considering alternative preview methods

### 4. **Internet Connectivity**
- **Issue**: Connectivity check doesn't verify actual internet access (only device connection)
- **Impact**: May show "connected" when WiFi has no internet
- **Status**: Ping test to reliable server planned


## Environment Setup

### Android
- Minimum SDK: 21 (Android 5.0)
- Target SDK: 34 (Android 14)
- Permissions required:
  - `INTERNET`
  - `WRITE_EXTERNAL_STORAGE`
  - `READ_EXTERNAL_STORAGE`

### iOS
- Minimum iOS version: 12.0
- Permissions required in `Info.plist`:
  - Photo Library Usage
  - Camera Usage (if applicable)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is part of the IndianAppGuy assignment.

## Support

For issues and questions, please create an issue in the repository.
