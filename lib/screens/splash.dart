import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wordpress/controllers/settings_controller.dart';
import 'package:wordpress/helpers/shared_preferences_helper.dart';
import 'package:wordpress/screens/user_homescreen.dart';
import '../colors.dart';
import 'onboardings.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(SettingsController(), permanent: true);
    Future.delayed(const Duration(seconds: 2), () {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        final String? email = await SharedPreferencesHelper.getEmail();
        if (email == null) {
          Get.offAll(() => OnboardingScreen());
        } else {
          final String? name = await SharedPreferencesHelper.getName();
          final String? password = await SharedPreferencesHelper.getPassword();
          Get.offAll(() => HomeScreen(
                email: email,
                name: name!,
                password: password!,
                fromSignIn: true,
              ));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/splash.png',
              height: 100,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              color: ColorPalette.blackColor,
            ),
          ],
        ),
      ),
    );
  }
}
