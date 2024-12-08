import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wordpress/screens/auto_login.dart';

class CustomDrawerButton extends StatelessWidget {
  final String? email;
  final String? password;
  final String label;
  final String iconUrl;
  final String destination;
  final double iconSize;
  final String backgroundColor;
  final String textColor;
  final double textSize;
  final String iconColor;

  const CustomDrawerButton({
    super.key,
    required this.label,
    required this.iconUrl,
    required this.destination,
    required this.iconSize,
    required this.backgroundColor,
    required this.textColor,
    required this.textSize,
    required this.iconColor,
    this.email,
    this.password,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => AutoLoginPage(
            email: email ?? '',
            password: password ?? '',
            firstTime: false,
            otherUrl: destination,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 4.h),
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Color(int.parse('0xff$backgroundColor')),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              iconUrl,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.error,
                color: Color(int.parse('0xff$iconColor')),
              ),
              color: Color(int.parse('0xff$iconColor')),
              height: iconSize,
              width: iconSize,
            ),
            SizedBox(width: 8.h),
            Text(
              label,
              style: TextStyle(
                color: Color(int.parse('0xff$textColor')),
                fontSize: textSize,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
