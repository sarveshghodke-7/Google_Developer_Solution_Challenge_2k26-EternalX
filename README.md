# MedBuddy
### Google Developer Solution Challenge 2026 — Team EternalX

> AI-powered medical report analyzer that transforms complex lab results
> into actionable health insights — in seconds.

---

## 🧠 What is MedBuddy?

Millions of people receive medical reports every day but can't understand
them. MedBuddy bridges that gap.

Upload any lab report as a PDF or image — MedBuddy extracts every
parameter, flags what's abnormal, explains it in plain language, and
gives you a concrete action plan. No medical background required.

---

## ✨ Features

- 📄 **AI Report Analysis** — Upload PDF or image, get instant insights
- 📈 **Health Trends** — Track parameters over time across reports
- 💊 **Medication Tracker** — Daily schedule with reminders
- 🏃 **Health Campaigns** — Personalized challenges based on your results

---

## 🏗️ Tech Stack

| Layer      | Technology                      |
|------------|---------------------------------|
| Frontend   | Flutter (Dart)                  |
| Backend    | Dart + Shelf                    |
| AI Engine  | Google Gemini 2.5 Flash         |
| Database   | Firebase Firestore              |
| Caching    | SHA-256 hashing + Firestore     |

---

## 📁 Repository Structure
Google_Developer_Solution_Challenge_2k26-EternalX/
├── frontend/        # Flutter mobile app
├── backend/         # Dart + Shelf API server
├── .gitignore
└── README.md

---

## 🚀 Quick Start

### 1. Clone the repository
```bash
git clone https://github.com/VEDIKAGULWANI/Google_Developer_Solution_Challenge_2k26-EternalX.git
cd Google_Developer_Solution_Challenge_2k26-EternalX
```

### 2. Setup Backend
```bash
cd backend
# Add .env and firebase-admin.json (see backend/README.md)
dart pub get
dart run bin/server.dart
```

### 3. Setup Frontend
```bash
cd frontend
flutter pub get
# Add google-services.json from Firebase Console
flutter run
```

> For detailed setup instructions, see README files inside
> `/frontend` and `/backend` folders.

---

## 🔒 Security

Never commit the following files:
.env
firebase-admin.json
google-services.json
All are covered in `.gitignore`.

---

## 👥 Team EternalX

Built with ❤️ for Google Developer Solution Challenge 2026.
---

## 📄 License
MIT License
