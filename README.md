# Luggo - Android App

![Language](https://img.shields.io/badge/language-Dart-blue) 
![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/license-CC--BY--NC--ND%204.0-blue)
## Description
Luggo is the final DAM project, an Android application developed using Flutter for a end of course project (TFC). This repository contains the source code and project files for the Luggo Android App. The app is designed to provide a seamless user experience while adhering to modern Android app development practices.

---

## Table of Contents
- [Project Structure](#project-structure)
- [Features](#features)
- [Setup & Installation](#setup--installation)
- [Contributing](#contributing)
- [License](#license)

---

## Project Structure

The project follows a structured folder organization to ensure maintainability and scalability:

```
lib/
├── controllers/     # Manages application controllers
├── dao/             # Data Access Objects for database operations
├── database/        # Database configuration and initialization
├── models/          # Data models
├── providers/       # State management providers
├── repository/      # Repository pattern for data handling
├── screens/         # UI screens and pages
├── services/        # API and external service integrations
├── utils/           # Utility functions and constants
├── widgets/         # Reusable widgets
└── main.dart        # Application's entry point
```

---

## Features
- **Modern Flutter Architecture**: Designed following Flutter's best practices.
- **Scalable Folder Structure**: Easy to maintain and expand.
- **State Management**: Using `providers` for state handling.
- **Database Integration**: Built-in DAO and repository patterns for smooth database operations.

---

## Setup & Installation

### Prerequisites
- Flutter SDK installed on your system.
- Android Studio or any preferred IDE configured for Flutter development.

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/EnriqueFolchBlasco/Luggo-Android-App.git
   cd Luggo-Android-App
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

---

## Contributing
Contributions are welcome! If you'd like to contribute, please follow these steps:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Commit your changes and submit a pull request.

Please ensure your code adheres to the project's coding standards.

---

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
