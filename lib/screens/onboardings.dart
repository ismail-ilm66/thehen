import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wordpress/controllers/settings_controller.dart';
import 'package:wordpress/helpers/helper_functions.dart';
import 'login.dart';
import '../colors.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<Widget> wid = [];
  List<Color> convertHexToColors(List<String> hexColors) {
    return hexColors.map((hexColor) {
      print('This is the hex in the loop: $hexColor');
      return Color(int.parse('0xff$hexColor'));
    }).toList();
  }

  List<Color> gradientColors = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('This is the length');
    gradientColors = convertHexToColors(settingsController.gradientColors);
    print('This is the gradientColors:${gradientColors.length}');
    for (var i in settingsController.onboardingItems) {
      print('This is the title:${i.title}');
    }

    wid = [
      buildOnboardPage(
        title: "Welcome to Joyful",
        description: "Experience happiness in a minimalistic way.",
        image:
            'https://www.iconpacks.net/icons/2/free-rocket-icon-3430-thumb.png',
      ),
      buildOnboardPage(
        title: "Stay Organized",
        description: "Everything you need at your fingertips.",
        image:
            'https://www.iconpacks.net/icons/2/free-rocket-icon-3430-thumb.png',
      ),
      buildOnboardPage(
        title: "Get Started Now",
        description: "Your journey to happiness begins here.",
        image:
            'https://www.iconpacks.net/icons/2/free-rocket-icon-3430-thumb.png',
        widget: ElevatedButton.icon(
          onPressed: () {
            Get.offAll(() => LoginScreen());
          },
          icon: const Icon(Icons.arrow_forward, color: ColorPalette.whiteColor),
          label: const Text(
            "Get Started",
            style: TextStyle(
                color: ColorPalette.whiteColor, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorPalette.blackColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
    ];
  }

  final PageController _controller = PageController();
  final SettingsController settingsController = Get.find();
  Color _colorFromHex(String hex) {
    // Remove '#' if it's there
    hex = hex.replaceAll('#', '');
    print('This is the hex:$hex');

    // Convert hex string to a Color object
    if (hex.length == 6) {
      return Color(int.parse('0xFF$hex'));
    } else if (hex.length == 8) {
      return Color(int.parse('0x$hex'));
    }

    throw FormatException('Invalid hex color format: $hex');
  }

  @override
  Widget build(BuildContext context) {
    print('This is the gradientType:${settingsController.gradientType.value}}');
    return Scaffold(
      // backgroundColor: ColorPalette.primaryColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: settingsController.gradientType.value == "LinearGradient"
              ? LinearGradient(
                  begin: HelperFunctions.convertAlignment(
                      settingsController.gradientBegin.value),
                  end: HelperFunctions.convertAlignment(
                      settingsController.gradientEnd.value),
                  colors: gradientColors,
                )
              : settingsController.gradientType.value == "RadialGradient"
                  ? RadialGradient(
                      center: HelperFunctions.convertAlignment(
                          settingsController.gradientBegin.value),
                      radius: 0.5,
                      colors: gradientColors,
                    )
                  : settingsController.gradientType.value == "SweepGradient"
                      ? SweepGradient(
                          center: HelperFunctions.convertAlignment(
                              settingsController.gradientBegin.value),
                          colors: gradientColors,
                        )
                      : null,
          color: settingsController.gradientType.value == null
              ? Color(
                  int.parse('0xff${settingsController.headerBgColor.value}'))
              : null, // Use solid color only if gradient type is null
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                children: settingsController.onboardingItems.isEmpty
                    ? wid
                    : settingsController.onboardingItems
                        .asMap()
                        .map((index, item) => MapEntry(
                              index,
                              buildOnboardPage(
                                title: item.title,
                                description: item.text,
                                image: item.icon,
                                widget: (index ==
                                            settingsController
                                                    .onboardingItems.length -
                                                1 &&
                                        item.enabled)
                                    ? ElevatedButton.icon(
                                        onPressed: () {
                                          Get.offAll(() => LoginScreen());
                                        },
                                        // icon: const Icon(Icons.arrow_forward,
                                            // color: ColorPalette.whiteColor),
                                        label: const Text(
                                          "Get Started",
                                          style: TextStyle(
                                              color: ColorPalette.blackColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              ColorPalette.primaryColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 22, vertical: 8),
                                        ),
                                      )
                                    : null,
                              ),
                            ))
                        .values
                        .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SmoothPageIndicator(
                controller: _controller,
                count: settingsController.onboardingItems.isEmpty
                    ? wid.length
                    : settingsController.onboardingItems.length,
                effect: const ExpandingDotsEffect(
                  activeDotColor: ColorPalette.indicatorActiveColor,
                  dotColor: ColorPalette.indicatorInactiveColor,
                  dotHeight: 10,
                  dotWidth: 10,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget buildOnboardPage({
    required String title,
    required String description,
    required String image,
    Widget? widget,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Image.network(
            image,
            height: 200,
            width: 200,
            // color: ColorPalette.blackColor,
          ),
          const SizedBox(height:10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: ColorPalette.blackColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: ColorPalette.blackColor.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          if (widget != null) widget,
        ],
      ),
    );
  }
}
