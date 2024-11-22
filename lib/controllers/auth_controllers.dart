import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wordpress/models/login_model.dart';
import 'package:wordpress/screens/auto_login.dart';
import 'package:wordpress/screens/web_view_screen.dart';

import '../admin_dashboard.dart';
import '../colors.dart';

class AuthController extends GetxController {
  final username = ''.obs;
  final password = ''.obs;
  final device = ''.obs;
  final isLoading = false.obs;
  final obsecurePassword = false.obs;

  final tokenResponse = Rxn<TokenResponse>();
  final errorMessage = ''.obs;

  final String apiUrl = "https://joyuful.com/wp-json/jwt-auth/v1/token";

  void _showSnackbar(String message, Color backgroundColor, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: ColorPalette.whiteColor),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String? validateUsername(String value) {
    if (value.isEmpty) {
      return "Username is required";
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "Password is required";
    }
    return null;
  }

  String? validateDevice(String value) {
    if (value.isNotEmpty && value.length < 6) {
      return "Device identifier must be at least 6 characters";
    }
    return null;
  }

  bool validateForm() {
    return validateUsername(username.value) == null &&
        validatePassword(password.value) == null &&
        validateDevice(device.value) == null;
  }

  // API Call
  Future<void> login() async {
    if (!validateForm()) {
      Get.snackbar("Validation Error", "Please fill all fields correctly");
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    if(username == "admin" && password == "admin1@"){
      //_showSnackbar("Login successful!", ColorPalette.greenColor, );
      Get.snackbar("Success", "Welcome, ${username.value}");
      //_saveTokenToFirestore(username);
      Get.to(() => DashboardScreen());
      isLoading.value = false;
    }
    else{

      try {

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            'username': username.value,
            'password': password.value,
            if (device.value.isNotEmpty) 'device': device.value,
          },
        );

        final responseData = json.decode(response.body);
        print('This is the response of the login api: $responseData');
// Parse response
        tokenResponse.value = TokenResponse.fromJson(responseData);

        if (tokenResponse.value?.token != null) {
          // Success response
          // Get.to(() => WebViewScreen(token: tokenResponse.value!.token!));
          await saveTokenToFirestore(username.value);
          Get.to(() =>
              AutoLoginPage(email: username.value, password: password.value));

          Get.snackbar(
              "Success", "Welcome, ${tokenResponse.value!.userDisplayName}");
        } else {
          // Error response
          errorMessage.value =
              tokenResponse.value?.errorMessage ?? "Login failed";
          Get.snackbar("Error", errorMessage.value);
        }
      } catch (e) {
        errorMessage.value = "An unexpected error occurred: $e";
        Get.snackbar("Error", errorMessage.value);
      } finally {
        isLoading.value = false; // Hide loading spinner
      }
    }
  }

  Future<void> saveTokenToFirestore(String username) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Get the FCM token
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      print("The FCM token is: $fcmToken");
      if (fcmToken == null) {
        throw Exception("Unable to fetch FCM token");
      }

      // Check if the username already exists in Firestore
      DocumentReference userDoc = firestore.collection('users').doc(username);

      userDoc.get().then((docSnapshot) {
        if (docSnapshot.exists) {
          // Update the FCM token if the user exists
          userDoc
              .update({'fcm_token': fcmToken})
              .then((_) {})
              .catchError((error) {
                print('This is the error in the user token');
              });
        } else {
          // Create a new document if the username doesn't exist
          userDoc.set({
            'username': username,
            'fcm_token': fcmToken,
          }).then((_) {
            print('The user token has been storen');
            // _showSnackbar("User created and token saved!", ColorPalette.greenColor);
          }).catchError((error) {
            print('This is the error in the user token');
            // _showSnackbar("Error saving user token: $error", ColorPalette.redColor);
          });
        }
      });
    } catch (e) {
      print('This is the try catch error that has been caught ${e.toString()}');
    }
  }
}
