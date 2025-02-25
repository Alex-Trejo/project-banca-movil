import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class NotificationService with ChangeNotifier {
  String? _message;

  String? get message => _message;

  NotificationService() {
    if (!kIsWeb) {
      _initNotifications();
    } else {
      // Para web, las notificaciones requieren un manejo diferente
      // Usa `firebase_messaging_web` o un script en index.html
      debugPrint('Notificaciones no implementadas para web aún');
    }
  }

  void _initNotifications() async {
    await FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _message = message.notification?.body;
      notifyListeners();
    });
  }

  void subscribeToUserTopic(int userId) {
    if (!kIsWeb) {
      FirebaseMessaging.instance.subscribeToTopic('user_$userId');
    }
  }
}