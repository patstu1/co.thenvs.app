# NVS (MeatUp) - A Next-Gen Gay Social App

NVS (MeatUp) is a modern gay social app designed to help users connect, meet, and explore relationships through innovative features and cutting-edge technology.

## ✨ Features

### 🔥 Core Social Features
- **Grid Browsing**: Browse profiles in an intuitive grid layout
- **Live Maps**: See nearby users in real-time with interactive maps
- **AI Matchmaking**: Advanced compatibility scoring powered by machine learning
- **Real-time Chat**: Instant messaging with multimedia support
- **Live Cam Rooms**: Video chat and live streaming capabilities
- **Forums**: Join discussions in real-time community forums

### 🎯 Key Highlights
- **Multi-platform**: Built with Flutter for iOS, Android, and web
- **Real-time**: Live updates and instant notifications
- **Safe & Secure**: Privacy-focused design with robust security measures
- **Modern UI**: Clean, intuitive interface with dark/light theme support
- **Location-based**: Find and connect with nearby users

## 🚀 Tech Stack

- **Framework**: Flutter 3.0+
- **Language**: Dart
- **State Management**: Provider
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **Maps**: Google Maps Integration
- **Real-time**: Firebase Cloud Messaging
- **Platform Support**: iOS, Android, Web

## 🛠 Development Setup

### Prerequisites
- Flutter SDK 3.0 or higher
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Firebase project setup

### Installation
1. Clone the repository
```bash
git clone https://github.com/patstu1/co.thenvs.app.git
cd co.thenvs.app
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
# For debug mode
flutter run

# For web
flutter run -d web

# For specific platform
flutter run -d ios
flutter run -d android
```

### Testing
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

### Building
```bash
# Build for production
flutter build apk --release  # Android
flutter build ios --release  # iOS
flutter build web --release  # Web
```

## 📱 App Structure

```
lib/
├── main.dart              # App entry point
├── models/               # Data models
│   ├── user.dart
│   └── match.dart
├── screens/              # UI screens
│   ├── auth_screen.dart
│   ├── home_screen.dart
│   ├── profile_screen.dart
│   ├── map_screen.dart
│   └── chat_screen.dart
├── widgets/              # Reusable UI components
├── services/             # API and business logic
├── utils/                # Utilities and helpers
│   └── theme.dart
└── models/               # Data models
```

## 🎨 Design System

The app follows a modern design system with:
- **Primary Color**: Purple (#6C63FF)
- **Secondary Color**: Teal (#03DAC6)
- **Dark Theme**: Full dark mode support
- **Typography**: Roboto font family
- **Components**: Material 3 design components

## 🔒 Privacy & Safety

NVS prioritizes user safety and privacy:
- End-to-end encrypted messaging
- Location privacy controls
- Content moderation
- User reporting and blocking
- Age verification systems

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

We welcome contributions! Please read our contributing guidelines and code of conduct before submitting pull requests.

## 📞 Support

For support, email support@nvs.app or join our community forums.
