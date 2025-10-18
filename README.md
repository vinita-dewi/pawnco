# Pawnco 

Flutter mobile & web sample app that consumes the **Swagger Petstore v3 API** to browse pets, view details, and place orders — structured with a clean **data / domain / presentation** architecture and **GetX** for routing & DI.

> This repo contains **two apps** in one codebase:
> - **Web Backoffice** — backoffice dashboard for **CRUD** of pets.
> - **Mobile App** — customer-facing app for **listing** pets and **ordering**.

[**▶ Live Demo (Web Backoffice → Pet Info #2)**](https://vinita-dewi.github.io/pawnco)


![Flutter](https://img.shields.io/badge/Flutter-mobile%20%26%20web-blue)
![State](https://img.shields.io/badge/state-GetX-informational)
![HTTP](https://img.shields.io/badge/http-dio-green)
![License](https://img.shields.io/badge/license-MIT-blue)


---

## Overview

- **Data source:** Swagger Petstore v3 (`https://petstore3.swagger.io/`)
- **Key flows:**
    - List available pets
    - Filter by **status** and **tags**
    - View **pet details**
    - Create a **store order** (demo)
- **Targets:** Android, iOS (where available), and Web (separate `MainWeb`).

---

## Tech Stack

- **Flutter** (Dart `>=3.7.2` per `pubspec.yaml`)
- **GetX** (`get`) for routing/bindings/controllers
- **Dio** for HTTP
- **google_fonts**, **cached_network_image**, **intl**, **easy_debounce**, **logger**
- **flutter_native_splash** for splash generation

**Notable folders**
```
pawnco/
└── lib/
    ├── app/
    │   ├── core/              # constants, dio client, themes, utils
    │   ├── data/              # models, sources (remote), repositories_impl
    │   ├── domain/            # entities, repositories (abstract), usecases
    │   ├── presentation/      # mobile & web feature UIs, widgets, enums
    │   └── routes/            # GetX pages & string routes
    ├── main.dart              # selects Web vs Mobile entrypoint
    ├── main_mobile.dart       # GetMaterialApp (mobile), initial binding & route
    └── main_web.dart          # GetMaterialApp (web), initial binding & route
```

---

## API & Endpoints

- **Base URL:** set in `lib/app/core/network/dio_client.dart`
  ```dart
  BaseOptions(
    baseUrl: 'https://petstore3.swagger.io/api/v3',
    ...
  )
  ```

- **Paths:** `lib/app/core/constants/api_path.dart`
    - `GET /pet/findByStatus`, `GET /pet/findByTags`, `GET /pet/{id}`
    - `POST /pet`, `PUT /pet`, `DELETE /pet/{id}`
    - `POST /store/order`

- **Remote source:** `lib/app/data/sources/pets_remote_source.dart`
- **Repository abstraction:** `lib/app/domain/repositories/pets_repository.dart`
- **Use cases:** `lib/app/domain/usecases/*` (e.g., `OrderPetUseCase`, `AddPetUsecase`)

---

## Getting Started

### Prerequisites
- **Flutter** with a Dart SDK that satisfies `sdk: ^3.7.2` (see `pubspec.yaml`)
- Platform toolchains for your target (Android Studio / Xcode)
- Chrome (for web runs)

### Install & Run
```bash
git clone https://github.com/vinita-dewi/pawnco.git
cd pawnco

flutter pub get

# Web
flutter run -d chrome

# Android
flutter run -d android

# iOS (macOS only, codesign required)
flutter run -d ios
```

> If you use `fvm`, ensure your Flutter/Dart toolchain meets the Dart constraint in `pubspec.yaml`.

### Build
```bash
# Web
flutter build web --release

# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## Feature Highlights

- **Pet catalog** with images (via `cached_network_image`)
- **Detail pages** for each pet
- **Tag & status filtering** (via API endpoints)
- **Create order** flow for a pet (demo)
- **Theming & typography** using `AppTheme` and `google_fonts`

---

## Development Notes

- **Architecture:** simplified clean approach (Data → Domain → Presentation).
- **Error handling & logs:** via `dio` interceptors and `logger` (see `DioClient`).
- **Theming:** `lib/app/core/themes` (colors, fonts, helper).
- **Utilities:** `lib/app/core/utils` (date, layout gaps, etc.).
- **Splash:** generated via `flutter_native_splash` (configure in `pubspec.yaml`).

---

## Scripts & Linting

- **Format & analyze**
```bash
flutter format .
flutter analyze
```

- **Tests**
```bash
flutter test
```

---

## Acknowledgements

- Swagger **Petstore v3** sample API
- Flutter, GetX, Dio, Google Fonts
