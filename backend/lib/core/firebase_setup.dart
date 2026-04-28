import 'dart:convert';
import 'dart:io';
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
    env = DotEnv(includePlatformEnvironment: true);

    if (File('.env').existsSync()) {
      env.load();
    }

    geminiApiKey = env['GEMINI_API_KEY'] ?? '';
    final projectId = env['FIREBASE_PROJECT_ID'];

    if (projectId == null || projectId.isEmpty) {
      throw Exception('🚨 FIREBASE_PROJECT_ID missing');
    }

    final base64ServiceAccount = env['FIREBASE_SERVICE_ACCOUNT'];

    if (base64ServiceAccount == null || base64ServiceAccount.isEmpty) {
      throw Exception('🚨 FIREBASE_SERVICE_ACCOUNT missing');
    }

    /// =========================
    /// FIX: Convert Base64 → TEMP FILE
    /// =========================
    final decodedJson = utf8.decode(base64Decode(base64ServiceAccount));

    final tempFile = File('firebase_temp.json');
    await tempFile.writeAsString(decodedJson);

    /// =========================
    /// INIT FIREBASE
    /// =========================
    final admin = FirebaseAdminApp.initializeApp(
      projectId,
      Credential.fromServiceAccount(tempFile),
    );

    firestore = Firestore(admin);
    auth = Auth(admin);

    print('✅ Firebase connected: $projectId');
  }
}