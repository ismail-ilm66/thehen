import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wordpress/colors.dart';
import 'package:wordpress/controllers/settings_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  final SettingsController settingsController = SettingsController();

  int _currentPage = 0;

  final List<String> sliderImages = [
    'https://res.cloudinary.com/dm7uq1adt/image/upload/v1732168773/du29n0aligtxzqsz8mzv.png',
    'https://res.cloudinary.com/dm7uq1adt/image/upload/v1732168773/du29n0aligtxzqsz8mzv.png',
    'https://res.cloudinary.com/dm7uq1adt/image/upload/v1732168773/du29n0aligtxzqsz8mzv.png'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(
        'This is the length of the navbar items: ${settingsController.navbarItems.length}');
    settingsController.fetchNavbarItems();
    settingsController.fetchHeroItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Home Screen"),
        backgroundColor: const Color(0xFFffc200),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Obx(
                () {
                  if (settingsController.loadingHeroItems.value) {
                    return SizedBox(
                      height: 250.h,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: ColorPalette.primaryColor,
                        ),
                      ),
                    );
                  }
                  if (settingsController.heroItems.isEmpty) {
                    return SizedBox(
                      height: 250.h,
                      child: const Center(
                        child: Text("No hero items found"),
                      ),
                    );
                  }

                  return SizedBox(
                    height: 250.h,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: settingsController.heroItems.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: _pageController,
                          builder: (context, child) {
                            double value = 1.0;
                            if (_pageController.position.haveDimensions) {
                              value = _pageController.page! - index;
                              value = (1 - (value.abs() * 0.3)).clamp(0.8, 1.0);
                            }

                            return Center(
                              child: SizedBox(
                                height: Curves.easeInOut.transform(value) * 200,
                                child: child,
                              ),
                            );
                          },
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                image: DecorationImage(
                                  image: NetworkImage(settingsController
                                      .heroItems[index].source),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 16.h),
          const SizedBox(height: 16),
          // Slider Indicator
          SmoothPageIndicator(
            controller: _pageController,
            count: settingsController.heroItems.length,
            effect: const ExpandingDotsEffect(
              activeDotColor: Color(0xFF000000),
              dotColor: Color(0xFFB0B0B0),
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 3,
            ),
          ),
          const Spacer(),
          Obx(() {
            if (settingsController.navBarLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Expanded(
              child: SizedBox(
                height: 120.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                        settingsController.navbarItems.length, (index) {
                      final link = settingsController.navbarItems[index];
                      return Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: Color(int.parse(
                                  "0xff${settingsController.navbarBackgroundColor.value}")),
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(2, 4),
                                )
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  link.iconUrl,
                                  color: Color(
                                    int.parse(
                                      "0xff${settingsController.navbarIconColor.value}",
                                    ),
                                  ),
                                  height:
                                      settingsController.navbarIconSize.value,
                                  width:
                                      settingsController.navbarIconSize.value,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  link.label,
                                  style: TextStyle(
                                    color: Color(int.parse(
                                        "0xff${settingsController.navbarTextColor.value}")),
                                    fontSize:
                                        settingsController.navbarTextSize.value,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            );
          }),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
