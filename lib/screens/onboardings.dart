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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  @override
  Widget build(BuildContext context) {
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
                  colors: settingsController.gradientColors
                      .map((color) => HelperFunctions.convertColor(color))
                      .toList(),
                )
              : settingsController.gradientType.value == "RadialGradient"
                  ? RadialGradient(
                      center: HelperFunctions.convertAlignment(
                          settingsController.gradientBegin.value),
                      radius: 0.5,
                      colors: settingsController.gradientColors
                          .map((color) => HelperFunctions.convertColor(color))
                          .toList(),
                    )
                  : settingsController.gradientType.value == "SweepGradient"
                      ? SweepGradient(
                          center: HelperFunctions.convertAlignment(
                              settingsController.gradientBegin.value),
                          colors: settingsController.gradientColors
                              .map((color) =>
                                  HelperFunctions.convertColor(color))
                              .toList(),
                        )
                      : null,
          color: settingsController.gradientType.value == null
              ? HelperFunctions.convertColor(
                  settingsController.headerBgColor.value)
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
                        .asMap() // Use asMap() to get the index
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
                                        icon: const Icon(Icons.arrow_forward,
                                            color: ColorPalette.whiteColor),
                                        label: const Text(
                                          "Get Started",
                                          style: TextStyle(
                                              color: ColorPalette.whiteColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              ColorPalette.blackColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 12),
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
                  dotHeight: 8,
                  dotWidth: 8,
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
          const SizedBox(height: 250),
          Image.network(
            image,
            height: 100,
            width: 100,
            color: ColorPalette.blackColor,
          ),
          const SizedBox(height: 30),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
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
          const SizedBox(height: 50),
          if (widget != null) widget,
        ],
      ),
    );
  }
}
