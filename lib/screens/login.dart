import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wordpress/controllers/auth_controllers.dart';
import 'package:wordpress/controllers/settings_controller.dart';
import 'package:wordpress/screens/auto_login.dart';
import '../colors.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _authController = Get.put(AuthController());
  final SettingsController settingsController = Get.find();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.loginColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Image.asset(
                  'assets/icon-login.png',
                  height: 100,
                ),


                const Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: ColorPalette.blackColor,
                  ),
                ),
                const SizedBox(height:2),
                Text(
                  "Login to your account",
                  style: TextStyle(
                    fontSize: 22,
                    color: ColorPalette.blackColor.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  onChanged: (value) => _authController.username.value = value,
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: const Icon(Icons.email_outlined,
                        color: ColorPalette.blackColor),
                    filled: true,
                    fillColor: ColorPalette.whiteColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 16),
                    hintStyle: TextStyle(
                        color: ColorPalette.blackColor.withOpacity(0.5)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email/username.";
                    }
                    bool isEmail = RegExp(
                            r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                        .hasMatch(value);

                    bool isUsername =
                        RegExp(r"^[a-zA-Z0-9_]+$").hasMatch(value);

                    if (!isEmail && !isUsername) {
                      return "Enter a valid email or username.";
                    }

                    return null;
                  },
                ),
                SizedBox(height: 10.h),
                Obx(
                  () => TextFormField(
                    onChanged: (value) =>
                        _authController.password.value = value,
                    obscureText: _authController.obsecurePassword.value,
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: ColorPalette.blackColor),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _authController.obsecurePassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: ColorPalette.blackColor,
                        ),
                        onPressed: () {
                          print('This is the value');
                          _authController.obsecurePassword.value =
                              !_authController.obsecurePassword.value;
                        },
                      ),
                      filled: true,
                      fillColor: ColorPalette.whiteColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 16),
                      hintStyle: TextStyle(
                          color: ColorPalette.blackColor.withOpacity(0.5)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password.";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters long.";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 30.h),
                Obx(
                  () => ElevatedButton(
                    onPressed: _authController.isLoading.value
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              await _authController.login();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(int.parse(
                          '0xff${settingsController.signinButtonBackground.value}')),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      elevation: 6,
                    ),
                    child: _authController.isLoading.value
                        ? const CircularProgressIndicator(
                            color: ColorPalette.primaryColor,
                          )
                        : Text(
                            settingsController.signinButtonText.value,
                            style: TextStyle(
                              color: Color(int.parse(
                                  '0xff${settingsController.signinButtonTextColor.value}')),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () {
                    Get.to(
                      AutoLoginPage(
                        email: 'email',
                        password: 'password',
                        otherUrl: settingsController
                            .registerItems.first.registerDestination,
                        firstTime: false,
                      ),
                    );
                  },
                  child: Text(
                    settingsController.registerItems.first.registerText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: ColorPalette.blackColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // ElevatedButton(
                //     onPressed: () {
                //       Get.to(() => HomeScreen());
                //     },
                //     child: const Text("Home testing")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
