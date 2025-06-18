# Tracky Mobile - Flutter Application

A cross-platform mobile application for the Tracky delivery tracking system, providing interfaces for both customers and drivers to manage orders and track deliveries in real-time.

## Prerequisites

- Flutter SDK 3.7.2 or higher
- Dart SDK (included with Flutter)
- Android Studio / Xcode for mobile development
- Android device/emulator or iOS device/simulator
- Tracky Backend services running (see [backend README](../backend/README.md))

## Architecture Overview

The Tracky mobile app follows a modular architecture with the following structure:

- **Common Module**: Shared components, services, and data models
- **Lobby Module**: Authentication and registration screens
- **Customer Module**: Order creation, tracking, and management for customers
- **Driver Module**: Order fulfillment and status updates for drivers

## Features

### Customer Features

- User registration and authentication
- Create new delivery orders
- View order history and status
- Real-time order tracking with maps
- Push notifications for order updates
- Order details and tracking information

### Driver Features

- Driver authentication and profile management
- View assigned orders
- Update order status (picked up, in transit, delivered)
- Real-time location tracking
- Order route optimization
- Delivery confirmations

### Common Features

- Dark/Light theme support
- Offline data persistence with SQLite
- Real-time location services
- Interactive maps with Google Maps/OpenStreetMap
- Camera integration for delivery photos
- Push notifications

## Quick Start

### 1. Install Dependencies

```bash
# Navigate to mobile directory
cd code/mobile

# Get Flutter dependencies
flutter pub get
```

### 2. Configuration

Ensure the backend services are running before starting the mobile app. The app is configured to connect to:

- **API Gateway**: `http://localhost:8080/api`
- **Service endpoints**: All API calls are routed through the gateway

### 3. Run the Application

```bash
# Run on connected device/emulator
flutter run

# Run with specific flavor
flutter run --flavor development

# Run for web (if supported)
flutter run -d chrome

# Run for specific platform
flutter run -d android
flutter run -d ios
```

### 4. Build for Production

```bash
# Build APK for Android
flutter build apk --release

# Build App Bundle for Android
flutter build appbundle --release

# Build for iOS
flutter build ios --release

# Build for Web
flutter build web --release
```

## Dependencies

### Core Dependencies

- **flutter**: Flutter SDK framework
- **provider**: State management solution
- **http** & **dio**: HTTP client for API communication
- **shared_preferences**: Local data persistence

### Location & Maps

- **geolocator**: Location services and GPS tracking
- **google_maps_flutter**: Google Maps integration
- **flutter_map**: Alternative map implementation
- **latlong2**: Geographic coordinate utilities
- **geocoding**: Address geocoding services
- **open_route_service**: Route calculation and optimization

### UI & Media

- **intl**: Internationalization and date formatting
- **cupertino_icons**: iOS-style icons
- **flutter_launcher_icons**: App icon generation
- **camera**: Camera integration for photos
- **url_launcher**: External URL and app launching

### Configuration

- **dotenv**: Environment variable management

## Project Structure

```text
lib/
├── main.dart                     # Application entry point
└── modules/
    ├── common/                   # Shared components and services
    │   ├── components/           # Reusable UI components
    │   ├── data/                # Data models and enums
    │   ├── screens/             # Shared screens
    │   ├── services/            # API and business logic services
    │   └── dio.dart             # HTTP client configuration
    ├── customer/                # Customer-specific features
    │   └── screens/             # Customer UI screens
    ├── driver/                  # Driver-specific features
    │   └── screens/             # Driver UI screens
    └── lobby/                   # Authentication screens
        ├── login_page.dart
        └── register_page.dart

assets/
├── images/                      # Application images
└── mock/                       # Mock data for development
```

## Development

### Local Development Setup

1. **Backend Services**: Ensure all backend microservices are running

   ```bash
   cd ../backend
   docker-compose up -d
   ```

2. **Flutter Environment**: Verify Flutter installation

   ```bash
   flutter doctor
   ```

3. **Device Setup**: Connect physical device or start emulator
   ```bash
   flutter devices
   ```

### Environment Configuration

For different environments, update the base URL in `lib/modules/common/dio.dart`:

```dart
// Development
baseUrl: 'http://localhost:8080/api'

// Production
baseUrl: 'https://your-production-api.com/api'

// Staging
baseUrl: 'https://staging-api.com/api'
```

### Useful Commands

```bash
# Check Flutter installation
flutter doctor -v

# List connected devices
flutter devices

# Hot reload during development
# Press 'r' in terminal while app is running

# Hot restart
# Press 'R' in terminal while app is running

# View app logs
flutter logs

# Analyze code
flutter analyze

# Format code
flutter format lib/
```
