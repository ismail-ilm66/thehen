import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wordpress/service_account_service.dart';

Future<void> sendNotification(String token, String title, String body) async {


  const String fcmUrl = 'https://fcm.googleapis.com/v1/projects/wordpress-3d152/messages:send';

  final String accessToken = await getAccessToken();

  print("THe access token is: $accessToken");
  try {
    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "message": {
          "token": token,
          "notification": {
            "title": title,
            "body": body,
          },
          "data": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "message": body,
          },
        },
      }),

    );

    if (response.statusCode == 200) {
      print('Notification sent successfully!');
    } else {
      print('Failed to send notification. Status code: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (e) {
    print('Error sending notification: $e');
  }
}
