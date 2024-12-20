# ClimateSafe

## 🌍 About the Project
ClimateSafe is a web application developed to provide monitoring of urban mobility in the city of Manaus. The objective of the project is to offer a detailed view of safer wheels for the user, taking into account issues such as flooding, landslides, accidents, among others.

---

## 🚀 Features

- **Secure login:**
  - Credential verification and personalized messages for user feedback.
- **User registration:**
  - Creation of new users with data such as name, login, email and password.
- **Chats:**
  - Chat for users in a certain location to stay updated.
- **Monitoring:**
  - Real-time map visualization showing the situation of each road.

---

## 🛠️ Technologies Used

### Backend:
- **Flutter/Dart**: Main framework/programming language of the project.
- **Flask**: Framework used to create the API.
- **MySQL**: Relational database to store user and alert information.

### Other tools:
- **Flask-CORS**: allows secure communication between frontend and backend.
- **MySQL Connector**: Library for connecting to the database.

### Front-end:
- **Flutter**: used exclusively for frontend development.
  
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
│   ├── android/
│   ├── ios/
│   ├── assets/
│   │   └── icon/     # App-specific icons
│   ├── lib/
│   │   ├── pages/       # Screens of the app
│   │   ├── routes/      # Routes of app navigation
│   │   ├── services/    # API communication logic
│   │   ├── theme/       # Definition of colors and themes of app(dark & light)
│   │   ├── main.dart    # Entry point of the Flutter app
│   ├── test/
│   ├── build/
│   ├── pubspec.yaml   # Flutter project configuration
```

---

Made by Victor Levy.
