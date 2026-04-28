# MedBuddy Dart Backend

A lightweight, high-performance Dart API that extracts medical data from reports using **Gemini 2.5 Flash** and caches results using **Firebase Firestore**.

## Quick Start

### 1. Prerequisites

* **Dart SDK**: [Install Dart](https://dart.dev/get-dart)
* **Gemini API Key**: Get it from [Google AI Studio](https://aistudio.google.com/)
* **Firebase Project**: A Firebase project with Firestore enabled.

### 2. Environment Setup

Create a `.env` file in the root directory:

```bash
GEMINI_API_KEY=your_gemini_key_here
PORT=8080
FIREBASE_PROJECT_ID=your-actual-project-id-123
```

### 3. Firebase Service Account (JSON Token)

To allow the backend to cache data in your Firestore:

1. Go to **Firebase Console** > **Project Settings** > **Service Accounts**.
2. Click **Generate New Private Key**.
3. Download the JSON file.
4. Rename it to `firebase-admin.json` and place it in the root of this project.

### 4. Install Dependencies

Run the following command to fetch all required packages:

```bash
dart pub get
```

### 5. Run the Server

```bash
dart run bin/server.dart
```

The server will start at `http://0.0.0.0:8080`.

---

## 🛠 Features

* **TOON Parser Support**: Returns data in Token-Oriented Object Notation for optimized frontend parsing.
* **Intelligent Caching**: Uses SHA-256 file hashing. If the same file is uploaded twice, the server returns the cached result from Firestore instead of calling Gemini again.
* **CORS Enabled**: Pre-configured to accept requests from Flutter web, mobile, and desktop.

## 📡 API Endpoints

### `POST /analyze-report`

Expects a JSON body:

```json
{
  "fileBytes": "base64_encoded_string",
  "mimeType": "application/pdf"
}
```

---

### Tip for team

If you want to run this in "Production mode", use:

```bash
dart compile exe bin/server.dart -o bin/server
./bin/server
```
