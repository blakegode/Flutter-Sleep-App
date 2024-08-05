import "package:fiveguys/presenters/UserManagement.dart";
import "package:fiveguys/api/firebase_api.dart";
import "package:fiveguys/presenters/firebase_options.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

class Token {
  static String fcmToken = '';

  static Future<String> getFCMToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        return token;
      } else {
        throw Exception('Failed to get FCM token');
      }
    } catch (e) {
      throw Exception('Failed to get FCM token: $e');
    }
  }

  static Future<void> setFCMToken(String userId) async {
    try {
      String token = await getFCMToken();
      fcmToken = token;
      await FirebaseFirestore.instance.collection('users').doc(userId).update({'fcmToken': token});
    } catch (e) {
      print('Failed to set FCM token: $e');
    }
  }

}