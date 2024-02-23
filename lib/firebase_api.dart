
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async{
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}
class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  // Lista para almacenar las notificaciones
  List<RemoteMessage> notifications = [];

  // Método para manejar las notificaciones y agregarlas a la lista
  void handleNotification(RemoteMessage message) {
    notifications.add(message);
  }
  void handleMessage(RemoteMessage? message){
    if(message == null)return;
    
  }
  Future initPushNotifications() async {
     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
     );
     FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
  Future<void> initNotifications() async{
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    initPushNotifications();
  }
}