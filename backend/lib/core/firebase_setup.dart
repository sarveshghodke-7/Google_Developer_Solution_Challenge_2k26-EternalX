import 'dart:convert';
import 'package:dotenv/dotenv.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:dart_firebase_admin/auth.dart';

class AppSetup {
  static late final DotEnv env;
  static late final Firestore firestore;
  static late final Auth auth;
  static late final String geminiApiKey;

  static Future<void> initialize() async {
    env = DotEnv(includePlatformEnvironment: true)..load();

    /// =========================
    /// GEMINI API KEY
    /// =========================
    geminiApiKey = env['GEMINI_API_KEY'] ?? '';
    if (geminiApiKey.isEmpty) {
      throw Exception('🚨 GEMINI_API_KEY not found in .env');
    }

    /// =========================
    /// FIREBASE PROJECT ID
    /// =========================
    final projectId = env['FIREBASE_PROJECT_ID'];
    if (projectId == null || projectId.isEmpty) {
      throw Exception('🚨 FIREBASE_PROJECT_ID not found in .env');
    }

    /// =========================
    /// FIREBASE SERVICE ACCOUNT (BASE64)
    /// =========================
    final base64ServiceAccount = env['FIREBASE_SERVICE_ACCOUNT'];

    if (base64ServiceAccount == null || base64ServiceAccount.isEmpty) {
      throw Exception('🚨 FIREBASE_SERVICE_ACCOUNT not found in .env');
    }

    /// Decode Base64 → JSON
    final serviceAccountJson = jsonDecode(
      utf8.decode(base64Decode(base64ServiceAccount)),
    );

    /// =========================
    /// INIT FIREBASE ADMIN
    /// =========================
    final admin = FirebaseAdminApp.initializeApp(
      projectId,
      Credential.fromServiceAccount(serviceAccountJson),
    );

    firestore = Firestore(admin);
    auth = Auth(admin);

    print('✅ Connected to Firebase Firestore & Auth: $projectId');
  }
}