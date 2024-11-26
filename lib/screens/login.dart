import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wordpress/controllers/auth_controllers.dart';
import 'package:wordpress/screens/auto_login.dart';
import '../colors.dart';
import 'user_homescreen.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _authController = Get.put(AuthController());

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.primaryColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: ColorPalette.blackColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Login to your account",
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorPalette.blackColor.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  onChanged: (value) => _authController.username.value = value,
                  decoration: InputDecoration(
                    hintText: "Email / Username",
                    prefixIcon: const Icon(Icons.email_outlined,
                        color: ColorPalette.blackColor),
                    filled: true,
                    fillColor: ColorPalette.whiteColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
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
                SizedBox(height: 20.h),
                TextFormField(
                  onChanged: (value) => _authController.password.value = value,
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
                        _authController.obsecurePassword.value =
                            !_authController.obsecurePassword.value;
                      },
                    ),
                    filled: true,
                    fillColor: ColorPalette.whiteColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
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
                SizedBox(height: 30.h),
                Obx(() => ElevatedButton(
                      onPressed: _authController.isLoading.value
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                await _authController.login();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette.blackColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 120),
                        elevation: 6,
                      ),
                      child: _authController.isLoading.value
                          ? const CircularProgressIndicator(
                              color: ColorPalette.whiteColor,
                            )
                          : const Text(
                              "Login",
                              style: TextStyle(
                                color: ColorPalette.whiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    )),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      Get.to(() => HomeScreen());
                    },
                    child: const Text("Home testing")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
