# Luggo - Android App

![Dart](https://img.shields.io/badge/language-Dart-blue?logo=dart&logoColor=white)  
![Flutter](https://img.shields.io/badge/framework-Flutter-blue?logo=flutter&logoColor=white)  
![License: MIT](https://img.shields.io/badge/license-MIT-green)  

---

## Overview

**Luggo** is a final project (TFC) Android application developed using **Flutter**. This app aims to provide a smooth, user-friendly experience for managing moving services, incorporating modern design patterns and best practices in mobile development. The repository contains the full source code, including UI, backend logic, and integrations.

Built with scalability and maintainability in mind, Luggo is a project I developed while learning, so it’s not perfect and may contain errors. Please keep this in mind.

---

## Table of Contents

- 📋 [Features](#features)  
- 🗂️ [Project Structure](#project-structure)  
- ⚙️ [Setup & Installation](#setup--installation)  
- 🤝 [Contributing](#contributing)  
- 📄 [License](#license)  

---

## Features

- ⚡ Clean, modular **Flutter** architecture with a clear folder structure  
- 🧩 Robust **state management** using Provider package  
- 💾 Database integration with DAO and repository pattern  
- 🌐 Multi-language support (English, Spanish, Valencian)  
- 👤 User authentication and profile management  
- 📦 Moving services management with inventory, checklist, chat, and notifications  
- 🔍 QR code generation and scanning for inventory items  
- 📴 Offline support with local database caching  
- 📱 Responsive UI designed for Android devices

---

![Frame 1](https://github.com/user-attachments/assets/066d0422-e923-448f-b62a-bdcf61b84319)

---

## Demo YouTube Video

[Watch the Luggo Android App Demo on YouTube](https://www.youtube.com/watch?v=df71vWR_-OQ)

---

## Project Structure

The app is organized for clarity and extensibility. The project follows a structured folder organization to ensure maintainability and scalability:



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
