import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';

class AppSetup {
  static late final DotEnv env;
  static late final Firestore firestore;
  static late final String geminiApiKey;

  static Future<void> initialize() async {
    env = DotEnv(includePlatformEnvironment: true)..load();
    
    geminiApiKey = env['GEMINI_API_KEY'] ?? '';
    final projectId = env['FIREBASE_PROJECT_ID'];
    if (projectId == null || projectId.isEmpty) {
      throw Exception('🚨 FIREBASE_PROJECT_ID not found in .env');
    }
    if (geminiApiKey.isEmpty) {
      throw Exception('🚨 GEMINI_API_KEY not found in .env');
    }
    final admin = FirebaseAdminApp.initializeApp(
      projectId,
      Credential.fromServiceAccount(File('firebase-admin.json')),
    );
    firestore = Firestore(admin);
    print('Connected to Firebase Firestore: $projectId');
  }
}
