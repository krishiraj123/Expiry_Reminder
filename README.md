# Expiry Reminder (Flutter)

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![IOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-07405E?style=for-the-badge&logo=sqlite&logoColor=white)
![YAML](https://img.shields.io/badge/YAML-CB171E?style=for-the-badge&logo=yaml&logoColor=white)
![Providers](https://img.shields.io/badge/State_Management-Provider-3D5AFE?style=for-the-badge)

## 📖 Table of Contents

- [About](#about)
- [Features](#features)
- [Demo](#demo)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Configuration](#configuration)
  - [Running the App](#running-the-app)
- [Project Structure](#project-structure)
- [Technologies](#technologies)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## 🧐 About&#x20;

Expiry Reminder helps you manage perishable items—groceries, medicines, cosmetics—and never miss an expiry date. Schedule notifications and sync across devices.

## ⭐️ Features&#x20;

- 🔖 **Add Items**: Specify name, category, purchase & expiry dates.
- ⏰ **Reminders**: Local & push notifications customizable by user.
- 📱 **Cross-Platform**: Android, iOS, Web, Windows, macOS, Linux.
- ☁️ **Cloud Sync**: (Optional) Firebase backend for multi-device sync.
- 📦 **Offline Support**: Local persistence via Hive or SQLite.

## 🎥 Demo&#x20;

## 🛠 Getting Started&#x20;

Follow these steps to run the project locally.

### Prerequisites&#x20;

- Flutter SDK ≥ 2.0
- Dart SDK ≥ 2.12
- IDE (VS Code, Android Studio, IntelliJ, etc.)
- (Optional) Firebase project for cloud features

### Installation&#x20;

1. **Clone** the repo:
   ```bash
   git clone https://github.com/krishiraj123/Expiry_Reminder.git
   cd Expiry_Reminder
   ```
2. **Install** dependencies:
   ```bash
   flutter pub get
   ```

### Configuration&#x20;

1. (Optional) Setup Firebase:
   - Create a project at [Firebase Console](https://console.firebase.google.com/).
   - Download `google-services.json` (Android) → `android/app/`
   - Download `GoogleService-Info.plist` (iOS) → `ios/Runner/`
   - Enable Firestore & Cloud Messaging.
2. Configure environment variables or `.env` file as needed.

### Running the App&#x20;

- **Mobile** (Android/iOS):
  ```bash
  flutter run
  ```
- **Web**:
  ```bash
  flutter run -d chrome
  ```
- **Desktop**:
  ```bash
  flutter run -d windows
  flutter run -d macos
  flutter run -d linux
  ```

## 📂 Project Structure&#x20;

```text
Expiry_Reminder/
├── android/            # Android configs
├── ios/                # iOS configs
├── lib/                # Flutter source
│   ├── models/         # Data models (Item.dart)
│   ├── services/       # API, Notification, DB logic
│   ├── screens/        # UI screens
│   ├── widgets/        # Reusable UI components
│   └── main.dart       # Entry point
├── web/                # Web configs
├── assets/             # Images, icons, JSON
├── test/               # Unit & widget tests
├── pubspec.yaml        # Dependencies & metadata
└── README.md           # Project documentation
```

## 🛠 Technologies&#x20;

- **Flutter** & **Dart**
- **Firebase**: Firestore, Cloud Messaging (optional)
- **Local DB**: Hive / SQLite
- **Notifications**: `flutter_local_notifications`

## 📖 Usage&#x20;

1. Launch the app.
2. Tap **+** to add a new item.
3. Fill in details and save.
4. Set reminder preferences in **Settings**.
5. View upcoming expirations on the **Home** screen.

## 🤝 Contributing&#x20;

Contributions, issues, and feature requests are welcome!

1. Fork the repo
2. Create a feature branch: `git checkout -b feature/MyFeature`
3. Commit changes: `git commit -m 'Add MyFeature'`
4. Push: `git push origin feature/MyFeature`
5. Open a Pull Request

## 📜 License&#x20;

Distributed under the MIT License. See [LICENSE](LICENSE) for details.

## 📬 Contact&#x20;

Krishiraj Vansia – [email@example.com](mailto:krishirajvansia123@gmail.com)

Project Link: [https://github.com/krishiraj123/Expiry_Reminder](https://github.com/krishiraj123/Expiry_Reminder)
