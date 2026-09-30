# Habit Pixel

**Habit Pixel** is a Flutter-based wellness and productivity application designed to make habit building more engaging through progress tracking, gamification, achievements, and interactive features.

The application allows users to create and manage habits, organize them through brands/categories, track their progress, and interact with gamified features that encourage consistent engagement.

Habit Pixel was built as a personal project to explore **Flutter mobile development, local data persistence, backend/API integration, synchronization, notifications, native Android integration, and user-focused mobile UX**.

> **Project Type:** Personal Flutter Application
> **Platform:** Android, iOS, Web, Windows, macOS, Linux
> **Primary Technology:** Flutter / Dart

---

## What is Habit Pixel?

Building and maintaining habits can become repetitive. Habit Pixel approaches habit tracking from a more engaging and interactive perspective by combining traditional habit management with gamification.

The application focuses on helping users:

* Create and manage personal habits
* Track ongoing habit progress
* Organize habits through brands/categories
* Monitor achievements and progress
* Interact with gamified features
* Receive notifications related to habits
* Continue using important functionality when offline
* Synchronize application data with backend services when connectivity is available

The goal is to make everyday habit tracking feel more like an interactive experience rather than a simple checklist.

---

## Key Features

### Home

The Home screen provides the main entry point into the application and gives users access to their primary habit and gamification features.

### Habit Management

Users can create and manage their habits and track their ongoing progress.

Habit-related functionality includes:

* Adding habits
* Editing habits
* Viewing habit details
* Tracking habit activity
* Managing habit-related data
* Connecting habits with the application's progress system

### Brand Management

Habit Pixel includes a brand/category-oriented organization system.

Users can:

* Create brands
* View brand details
* Manage brand-related information
* Associate habits with organizational structures

Relevant project services include:

* `BrandDatabaseService`
* `BrandSyncService`
* `BrandSyncScheduler`

### Achievements

The application includes an achievement system designed to provide users with visible progress and rewards for continued engagement.

Achievements contribute to the gamification aspect of Habit Pixel and give users additional motivation to maintain their habits.

### Games

Habit Pixel includes interactive games as part of its gamification experience.

The project contains game functionality such as:

* Chess
* Snake
* Tic Tac Toe

These features are intended to make the application more interactive and provide users with additional engagement beyond standard habit tracking.

### Profile

The Profile section provides a dedicated area for user-related information and application settings.

### Notifications

Habit Pixel includes notification functionality to support habit-related engagement.

The project contains a dedicated:

`NotificationService`

for handling notification-related functionality.

---

## Offline Data Handling

One of the important technical aspects of Habit Pixel is its ability to work with locally stored data.

The application uses local persistence so that important information can remain available even when network connectivity is unavailable.

Relevant components include:

* `HabitDatabase`
* `HabitStore`
* `BrandDatabaseService`
* Local data storage
* Offline-first data handling for relevant application functionality

This approach helps provide a smoother user experience instead of requiring every operation to depend immediately on an active internet connection.

---

## Data Synchronization

Habit Pixel includes synchronization-related services for keeping local application data and backend data aligned.

The project contains:

* `BrandSyncService`
* `BrandSyncScheduler`
* `ConnectivityService`
* API service integration

The application can monitor connectivity and use synchronization mechanisms when network connectivity becomes available.

This was implemented to explore practical mobile application scenarios where users may move between online and offline environments.

---

## Backend and API Integration

Habit Pixel communicates with backend services through API integration.

The project includes:

`PrimeLedgeApiService`

for handling relevant API communication.

The application architecture separates API communication from UI components, making it easier to manage:

* API requests
* Server responses
* Data synchronization
* Local persistence
* Connectivity-dependent operations

---

## Native Android Integration

Although Habit Pixel is primarily developed with Flutter, the project also includes native Android integration where required.

The Android application uses:

`com.example.habit_gamification_new`

and includes a native `MainActivity`.

Native Android work was also used during the application's startup optimization and debugging process.

This provided practical experience working across the Flutter and Android layers rather than relying exclusively on Flutter code.

---

## Startup Optimization

The application startup flow was optimized to avoid unnecessary waiting before displaying the application.

The startup implementation was designed to avoid introducing an artificial delay or unnecessarily waiting for local database initialization before allowing the user to reach the main application experience.

This work involved both Flutter and Android startup behavior.

---

## Application Structure

The application is organized around Flutter screens, services, data handling, and platform-specific code.

Major application areas include:

```text
lib/
├── screens/
│   ├── Home
│   ├── Brand
│   ├── Games
│   ├── Achievements
│   ├── Profile
│   ├── Add Brand
│   ├── Add Habit
│   ├── Brand Detail
│   ├── Habit Detail
│   ├── Main Navigation
│   ├── Main Screen
│   └── Splash
│
├── services/
│   ├── brand_database_service.dart
│   ├── brand_sync_scheduler.dart
│   ├── brand_sync_service.dart
│   ├── connectivity_service.dart
│   ├── habit_database.dart
│   ├── habit_store.dart
│   ├── habit_timer_service.dart
│   ├── notification_service.dart
│   └── prime_ledge_api_service.dart
│
└── ...
```

The exact structure may evolve as the application continues to be developed.

---

## Technology Stack

### Mobile Application

* Flutter
* Dart
* Material UI
* Flutter navigation
* Responsive mobile UI

### Local Data

* Local database/storage
* Offline data handling
* Local state/data management

### Backend

* REST API integration
* API-based data synchronization
* Connectivity-aware synchronization

### Native Platform

* Android
* Kotlin
* Native Android activity integration

### Development Tools

* Android Studio
* VS Code
* Git
* GitHub
* Flutter DevTools

---

## Project Structure

```text
habit_gamification_new/
│
├── android/          # Android platform code
├── ios/              # iOS platform code
├── linux/            # Linux platform configuration
├── macos/            # macOS platform configuration
├── web/              # Web platform configuration
├── windows/          # Windows platform configuration
│
├── assets/           # Images and other application assets
│
├── lib/              # Main Flutter/Dart application
│
├── test/             # Tests
│
├── analysis_options.yaml
├── pubspec.yaml
├── pubspec.lock
├── README.md
└── .gitignore
```

---

## Getting Started

### Prerequisites

Before running Habit Pixel, make sure you have:

* Flutter SDK installed
* Dart SDK
* Android Studio or another Flutter-compatible IDE
* Android SDK for Android development
* Git

Verify your Flutter installation:

```bash
flutter doctor
```

### Clone the Repository

```bash
git clone https://github.com/khansa28/habit-pixel-flutter.git
```

Navigate to the project:

```bash
cd habit-pixel-flutter
```

### Install Dependencies

```bash
flutter pub get
```

### Run the Application

To see available devices:

```bash
flutter devices
```

Run the application:

```bash
flutter run
```

For Android:

```bash
flutter run -d android
```

For Chrome/Web:

```bash
flutter run -d chrome
```

---

## Testing

The project includes a test directory for Flutter/Dart testing.

Run the available tests with:

```bash
flutter test
```

---

## Development Focus

Habit Pixel was developed as a practical project for gaining experience with real-world mobile application concepts, including:

* Flutter application architecture
* Dart programming
* UI development
* User-generated data
* Local persistence
* Offline functionality
* API integration
* Data synchronization
* Connectivity handling
* Notifications
* Gamification
* Native Android integration
* Application startup optimization
* Cross-platform development
* Git and GitHub workflow

---

## User Experience

The application is designed around a simple principle:

> Make habit building more engaging through interaction and visible progress.

Instead of treating habits purely as data records, Habit Pixel combines habit tracking with:

* Progress
* Achievements
* Games
* Personalization
* Notifications
* Visual feedback

The intention is to create a more engaging experience for users who want to build and maintain consistent habits.

---

## Screenshots and Project Images

Screenshots and project images are available through the project's GitHub repository and developer profile.

They provide a visual overview of:

* Home screen
* Habit management
* Brand management
* Games
* Achievements
* Profile
* Overall application UI

---

## What I Learned From This Project

Building Habit Pixel provided hands-on experience with several areas of mobile application development.

### Flutter and Dart

Developed multiple screens and application flows using Flutter and Dart while working with reusable UI components and application services.

### Data Management

Worked with local data storage and application-level data management for user-generated habit and brand information.

### Offline Support

Implemented local data handling and synchronization concepts so the application can continue handling relevant data when connectivity is unavailable.

### API Integration

Worked with backend APIs and separated API-related operations into dedicated services.

### Synchronization

Implemented synchronization-related services that coordinate local data with remote data based on connectivity.

### Native Android

Worked across the Flutter and Android layers where native functionality and startup behavior required platform-specific handling.

### User Experience

Designed application flows around repeated user interaction, progress tracking, and engagement rather than simply displaying static information.

---

## Project Status

Habit Pixel is an actively developed personal project.

The application is primarily intended as a practical demonstration of Flutter and mobile development skills and experimentation with gamified habit tracking.

---

## Developer

**Khansa Maryam**

Junior Software Developer
Flutter / Dart • C# • ASP.NET Core • Web API • SQL Server

### Project

[Habit Pixel — GitHub Repository](https://github.com/khansa28/habit-pixel-flutter.git?utm_source=chatgpt.com)

---

## License

This project is currently maintained as a personal project.

If you would like to explore the implementation or discuss the project, please refer to the repository and developer profile.
