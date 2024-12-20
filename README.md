# ClimateSafe

## 🌍 About the Project
ClimateSafe is a comprehensive application designed to monitor urban mobility in the city of Manaus. It offers real-time data and insights into safer routes for users, addressing issues like flooding, landslides, accidents, and more. The app integrates advanced backend functionalities with a user-friendly Flutter frontend to deliver a robust and efficient solution.

---

## 🚀 Features

- **Secure Login:**
  - Credential verification and personalized feedback for users.
- **User Registration:**
  - Register new users with data including name, login, email, and password.
- **Chats:**
  - Real-time communication for users in specific locations to share updates.
- **Monitoring:**
  - Live map visualizations displaying the condition of various roads.

---

## 🛠️ Technologies Used

### Backend:
- **Python:** Main programming language for server-side development.
- **Flask:** Framework used to create the API.
- **MySQL:** Relational database for storing user and alert information.

### Other Tools:
- **Flask-CORS:** Enables secure communication between frontend and backend.
- **MySQL Connector:** Library for connecting to the database.

### Frontend:
- **Flutter/Dart:** Primary framework and programming language for the user interface.

---

## 🔗 Social Media

Follow the progress of ClimateSafe and get in touch for suggestions or collaborations:

- [GitHub](https://github.com/LevyAbreu)  
- [Instagram](https://instagram.com/climate_safe)  

---

## 📂 Project Structure

```plaintext
├── api
│   ├── __pycache__/   # Python cache files
│   ├── alerts.py      # Alerts handling
│   ├── app.py         # Initializes the Flask server
│   ├── auth.py        # Authentication logic
│   ├── chat.py        # Chat module
│   ├── config.py      # Database configurations
│   ├── db.py          # Functions for database connection
│   ├── routes.py      # API routes
├── climatesafe_app
│   ├── android/       # Android-specific files
│   ├── ios/           # iOS-specific files
│   ├── assets/        # Images, icons, and fonts
│   │   ├── images/    # App-specific images
│   │   ├── fonts/     # Custom fonts
│   │   └── icons/     # App-specific icons
│   ├── lib/           # Main Flutter codebase
│   │   ├── components/  # Reusable widgets
│   │   ├── models/      # Data models
│   │   ├── pages/       # Screens of the app
│   │   ├── routes/      # Navigation structure
│   │   ├── services/    # API communication logic
│   │   ├── theme/       # Dark and light themes
│   │   └── main.dart    # Entry point of the Flutter app
│   ├── pubspec.yaml   # Flutter project configuration
│   ├── test/          # Unit and widget tests
```

---

Made by Victor Levy.
