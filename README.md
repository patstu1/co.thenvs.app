# NVS (MeatUp) 🏳️‍🌈

NVS (MeatUp) is a next-gen gay social app with grid browsing, live maps, AI matchmaking, and live cam rooms. Meet nearby guys, join real-time forums, and connect through advanced compatibility scoring. Built with Flutter for iOS, Android, and web for speed, safety, and modern design.

## ✨ Features

### 🔐 Authentication System
- **Firebase Authentication** with email/password
- **Profile Setup** with photo uploads and preferences
- **Secure User Management** with verification system

### 👥 Profile Grid (Grindr-style)
- **Grid View** of nearby users with distance sorting
- **Smart Filtering** by age, distance, and interests
- **Profile Details** with swipe-to-like functionality
- **Photo Management** with up to 6 profile images

### 🗺️ Live Location Map (Sniffies-style)
- **Google Maps Integration** showing nearby users in real-time
- **Privacy Controls** for location sharing preferences
- **Distance-based Discovery** with customizable radius
- **Interactive Markers** with user details on tap

### 🤖 AI Matchmaking System
- **Compatibility Scoring** based on interests and preferences
- **Smart Suggestions** using machine learning algorithms
- **Personalized Recommendations** that improve over time

### 💬 Live Chat & Cam Rooms
- **Direct Messaging** between matched users
- **Group Chat Rooms** for community discussions
- **Live Video Rooms** with real-time communication
- **Media Sharing** capabilities

## 🛠️ Tech Stack

### Frontend
- **Flutter 3.24+** for cross-platform development
- **Riverpod** for state management
- **Go Router** for navigation
- **Material Design 3** with custom theming

### Backend & Services
- **Firebase Core** for authentication and backend services
- **Cloud Firestore** for real-time database
- **Firebase Storage** for media uploads
- **Firebase Messaging** for push notifications

### Maps & Location
- **Google Maps Flutter** for interactive maps
- **Geolocator** for location services
- **Geocoding** for address conversion

### Media & Communication
- **Agora RTC Engine** for video/audio calls
- **Image Picker** for photo selection
- **Camera** for capturing photos
- **Cached Network Image** for optimized image loading

### AI & Data
- **TensorFlow Lite** for on-device AI processing
- **Hive** for local data storage
- **Dio** for HTTP requests

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.24 or higher
- Dart SDK 3.1.0 or higher
- Android Studio / Xcode for mobile development
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/patstu1/co.thenvs.app.git
   cd co.thenvs.app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a new Firebase project
   - Enable Authentication, Firestore, Storage, and Messaging
   - Download configuration files:
     - `google-services.json` for Android (`android/app/`)
     - `GoogleService-Info.plist` for iOS (`ios/Runner/`)
   - Update `firebase_options.dart` with your configuration

4. **Configure Google Maps**
   - Get API keys from Google Cloud Console
   - Enable Maps SDK for Android/iOS and JavaScript API
   - Update API keys in:
     - `android/app/src/main/AndroidManifest.xml`
     - `ios/Runner/Info.plist`
     - `web/index.html`

5. **Run the app**
   ```bash
   # For development
   flutter run
   
   # For specific platforms
   flutter run -d android
   flutter run -d ios
   flutter run -d chrome
   ```

### Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 🔧 Configuration

### Environment Setup
Create a `.env` file in the root directory:
```env
FIREBASE_API_KEY=your_firebase_api_key
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
AGORA_APP_ID=your_agora_app_id
```

### Firebase Rules
Update Firestore security rules for user data protection:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /chats/{chatId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
└── src/
    ├── app.dart             # Main app widget
    ├── core/                # Core functionality
    │   ├── theme/           # App theming
    │   ├── router/          # Navigation setup
    │   ├── constants/       # App constants
    │   ├── utils/           # Utility functions
    │   └── widgets/         # Shared widgets
    └── features/            # Feature modules
        ├── auth/            # Authentication
        ├── profile/         # User profiles
        ├── map/             # Location & maps
        ├── chat/            # Messaging
        └── matchmaking/     # AI matching
```

## 🧪 Testing

Run tests with:
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Widget tests
flutter test test/
```

## 📱 Supported Platforms

- **iOS** 12.0+
- **Android** API 21+ (Android 5.0)
- **Web** (Modern browsers with PWA support)

## 🛡️ Privacy & Security

- **End-to-end encryption** for private messages
- **Location privacy controls** with granular permissions
- **Profile verification system** to ensure authentic users
- **Content moderation** and reporting features
- **GDPR compliant** data handling

## 📋 Roadmap

- [ ] **Push Notifications** for matches and messages
- [ ] **Advanced AI Matching** with personality assessment
- [ ] **Video Dating Features** with virtual dates
- [ ] **Social Events** and meetup coordination
- [ ] **Premium Features** and subscription model
- [ ] **Multi-language Support** 
- [ ] **Dark/Light Mode Toggle**
- [ ] **Accessibility Improvements**

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team** for the amazing framework
- **Firebase** for backend services
- **Google Maps** for location services
- **Agora** for real-time communication
- **Contributors** and the open-source community

## 📞 Support

For support, email support@thenvs.app or join our Discord community.

---

**Made with ❤️ for the LGBTQ+ community**
