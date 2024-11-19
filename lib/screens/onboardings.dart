import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'screens/login.dart';
import 'colors.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.primaryColor,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              children: [
                _buildOnboardPage(
                  title: "Welcome to Joyful",
                  description: "Experience happiness in a minimalistic way.",
                  image: Icons.emoji_emotions_outlined,
                ),
                _buildOnboardPage(
                  title: "Stay Organized",
                  description: "Everything you need at your fingertips.",
                  image: Icons.dashboard_customize_outlined,
                ),
                _buildOnboardPage(
                  title: "Get Started Now",
                  description: "Your journey to happiness begins here.",
                  image: Icons.rocket_launch_outlined,
                  widget: ElevatedButton.icon(
                    onPressed: () {
                      Get.offAll(() => LoginScreen());
                      /* Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );*/
                    },
                    icon: Icon(Icons.arrow_forward,
                        color: ColorPalette.whiteColor),
                    label: Text(
                      "Get Started",
                      style: TextStyle(
                          color: ColorPalette.whiteColor,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.blackColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: ExpandingDotsEffect(
                activeDotColor: ColorPalette.indicatorActiveColor,
                dotColor: ColorPalette.indicatorInactiveColor,
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildOnboardPage({
    required String title,
    required String description,
    required IconData image,
    Widget? widget,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 250),
          Icon(
            image,
            size: 100,
            color: ColorPalette.blackColor,
          ),
          SizedBox(height: 30),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColorPalette.blackColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: ColorPalette.blackColor.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 50),
          if (widget != null) widget,
        ],
      ),
    );
  }
}
