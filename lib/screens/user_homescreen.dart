import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wordpress/colors.dart';
import 'package:wordpress/controllers/settings_controller.dart';
import 'package:wordpress/helpers/shared_preferences_helper.dart';
import 'package:wordpress/screens/auto_login.dart';
import 'package:wordpress/screens/login.dart';

class HomeScreen extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  final bool fromSignIn;
  const HomeScreen({
    super.key,
    required this.name,
    required this.email,
    required this.password,
    this.fromSignIn = false,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  final SettingsController settingsController = SettingsController();
  String name = '';
  late InAppWebViewController _webViewController;
  var currentUrl = "https://joyuful.com/login/".obs;
  final RxBool logoutLoading = false.obs;

  int _currentPage = 0;
  Future<void> clearWebViewSessionsAndCookies() async {
    try {
      logoutLoading.value = true;
      // Clear all cookies
      final cookieManager = CookieManager.instance();
      await cookieManager.deleteAllCookies();
      print("All cookies have been cleared.");

      // Clear cache and session storage
      if (_webViewController != null) {
        await _webViewController.clearCache();
        print("WebView cache cleared.");

        // Clear session storage via JavaScript
        await _webViewController.evaluateJavascript(source: """
        window.localStorage.clear();
        window.sessionStorage.clear();
      """);
        print("LocalStorage and SessionStorage cleared.");
      } else {
        print("WebViewController is not initialized.");
      }
    } catch (e) {
      print("Error clearing sessions and cookies: $e");
    } finally {
      logoutLoading.value = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(
        'This is the length of the navbar items: ${settingsController.navbarItems.length}');
    settingsController.fetchNavbarItems();
    settingsController.fetchHeroItems();

    Future.delayed(const Duration(seconds: 1), () {
      Get.to(
        () => AutoLoginPage(
          email: widget.email,
          password: widget.password,
          firstTime: true,
        ),
      );
    }).then((value) {
      if (widget.fromSignIn) {
        Get.snackbar('Welcome', 'Welcome $name');
      }
    });
    if (widget.name == 'No name') {
      name = widget.email;
    } else {
      name = widget.name;
    }
  }

  void _loadUrl(String url) {
    currentUrl.value = url;
    _webViewController.loadUrl(
      urlRequest: URLRequest(url: WebUri(url)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text("Welcome $name"),
            const SizedBox(
              width: 8,
            ),
            Image.asset(
              'assets/joyuful-icon.png',
              height: 35,
              width: 35,
            ),
          ],
        ),
        backgroundColor: const Color(0xFFffc200),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Obx(
                  () {
                    if (settingsController.loadingHeroItems.value) {
                      return SizedBox(
                        height: 80.h,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: ColorPalette.primaryColor,
                          ),
                        ),
                      );
                    }
                    if (settingsController.heroItems.isEmpty) {
                      return SizedBox(
                        height: 80.h,
                        child: const Center(
                          child: Text("No hero items found"),
                        ),
                      );
                    }
                    return CarouselSlider(
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.width *
                            2 /
                            3, // Maintain 3:2 ratio
                        autoPlay: true,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        viewportFraction:
                            1, // Adjust the width of visible items
                      ),
                      items: settingsController.heroItems.map((item) {
                        return Builder(
                          builder: (BuildContext context) {
                            return GestureDetector(
                              onTap: () {
                                _loadUrl(item.destination);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                height:
                                    MediaQuery.of(context).size.width * 2 / 3,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  image: DecorationImage(
                                    image: NetworkImage(item.source),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    );
                    // return SizedBox(
                    //   height: 140.h,
                    //   child: PageView.builder(
                    //     controller: _pageController,
                    //     itemCount: settingsController.heroItems.length,
                    //     onPageChanged: (index) {
                    //       setState(() {
                    //         _currentPage = index;
                    //       });
                    //     },
                    //     itemBuilder: (context, index) {
                    //       return AnimatedBuilder(
                    //         animation: _pageController,
                    //         builder: (context, child) {
                    //           double value = 1.0;
                    //           if (_pageController.position.haveDimensions) {
                    //             value = _pageController.page! - index;
                    //             value =
                    //                 (1 - (value.abs() * 0.3)).clamp(0.8, 1.0);
                    //           }

                    //           return Center(
                    //             child: SizedBox(
                    //               height:
                    //                   Curves.easeInOut.transform(value) * 200,
                    //               child: child,
                    //             ),
                    //           );
                    //         },
                    //         child: GestureDetector(
                    //           onTap: () {},
                    //           child: Container(
                    //             margin: EdgeInsets.symmetric(
                    //                     horizontal: 16.w, vertical: 8.h)
                    //                 .copyWith(bottom: 0),
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(16.r),
                    //               image: DecorationImage(
                    //                 image: NetworkImage(settingsController
                    //                     .heroItems[index].source),
                    //                 fit: BoxFit.contain,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // );
                  },
                ),
              ],
            ),
            SizedBox(height: 16.h),

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
            SizedBox(height: 4.h),
            const Divider(
              color: ColorPalette.blackColor,
            ),
            Obx(
              () => SizedBox(
                height: 400.h,
                child: GestureDetector(
                  onVerticalDragUpdate: (_) => true,
                  child: InAppWebView(
                    gestureRecognizers: Set()
                      ..add(Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer())),
                    initialUrlRequest: URLRequest(
                      url: WebUri(currentUrl.value),
                    ),
                    initialSettings: InAppWebViewSettings(
                      javaScriptEnabled: true,
                      domStorageEnabled: true,
                      useShouldOverrideUrlLoading: true,
                    ),
                    shouldOverrideUrlLoading:
                        (controller, shouldOverrideUrlLoadingRequest) async {
                      print(
                          'This is the URL: ${shouldOverrideUrlLoadingRequest.request.url}');
                      if (shouldOverrideUrlLoadingRequest.request.url
                          .toString()
                          .contains(
                              'https://joyuful.com/wp-login.php?action=logout')) {
                        await SharedPreferencesHelper.clearAll();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                          (route) => false,
                        );

                        // Navigator.pop
                        Get.snackbar('Logged Out', 'You have been logged out');
                      }

                      return NavigationActionPolicy.ALLOW;
                    },
                    onWebViewCreated: (controller) {
                      _webViewController = controller;
                      // Handle WebView controller creation if needed
                    },
                    onLoadStop: (controller, url) async {
                      print("Page loaded: $url");

                      if (url.toString().contains("wp-login.php") ||
                          url
                              .toString()
                              .contains("https://joyuful.com/login/")) {
                        await controller.evaluateJavascript(source: """
                      (function() {
                        // Check if the username field exists
                        var usernameField = document.getElementById('user_login0');
                        if (usernameField) {
                          usernameField.value = '${widget.email}'; // Set email
                        }
                    
                        // Check if the password field exists
                        var passwordField = document.getElementById('user_pass0');
                        if (passwordField) {
                          passwordField.value = '${widget.password}'; // Set password
                        }
                    
                        // Check if the submit button exists and click it
                        var submitButton = document.getElementById('wp-submit0');
                        if (submitButton) {
                          submitButton.click(); // Click the login button
                        }
                      })();
                    """);
                      } else {}
                    },
                    onProgressChanged: (controller, progress) {},
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.h),
            const Divider(
              color: ColorPalette.blackColor,
            ),
            Obx(() {
              if (settingsController.navBarLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SizedBox(
                // height: 120.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        settingsController.navbarItems.length, (index) {
                      final link = settingsController.navbarItems[index];
                      return GestureDetector(
                        onTap: () {
                          _loadUrl(link.destination);
                        },
                        child: Container(
                          width: double
                              .infinity, // Make the container take full width
                          margin: EdgeInsets.symmetric(
                              vertical:
                                  4.h), // Vertical spacing between buttons
                          padding: EdgeInsets.all(8.r),
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
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                link.iconUrl,
                                color: Color(
                                  int.parse(
                                    "0xff${settingsController.navbarIconColor.value}",
                                  ),
                                ),
                                height: settingsController.navbarIconSize.value,
                                width: settingsController.navbarIconSize.value,
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
                      );
                    }),
                  ),
                ),
              );
            }),

            // Obx(() {
            //   if (settingsController.navBarLoading.value) {
            //     return const Center(
            //       child: CircularProgressIndicator(),
            //     );
            //   }
            //   return Expanded(
            //     child: SizedBox(
            //       height: 120.h,
            //       child: Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 16.w),
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: List.generate(
            //               settingsController.navbarItems.length, (index) {
            //             final link = settingsController.navbarItems[index];
            //             return Expanded(
            //               child: GestureDetector(
            //                 onTap: () {
            //                   _loadUrl(link.destination);
            //                 },
            //                 child: Container(
            //                   margin: EdgeInsets.symmetric(horizontal: 4.w),
            //                   padding: EdgeInsets.all(8.r),
            //                   decoration: BoxDecoration(
            //                     color: Color(int.parse(
            //                         "0xff${settingsController.navbarBackgroundColor.value}")),
            //                     borderRadius: BorderRadius.circular(12.r),
            //                     boxShadow: const [
            //                       BoxShadow(
            //                         color: Colors.black26,
            //                         blurRadius: 6,
            //                         offset: Offset(2, 4),
            //                       )
            //                     ],
            //                   ),
            //                   child: Column(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       Image.network(
            //                         link.iconUrl,
            //                         color: Color(
            //                           int.parse(
            //                             "0xff${settingsController.navbarIconColor.value}",
            //                           ),
            //                         ),
            //                         height:
            //                             settingsController.navbarIconSize.value,
            //                         width:
            //                             settingsController.navbarIconSize.value,
            //                       ),
            //                       SizedBox(height: 8.h),
            //                       Text(
            //                         link.label,
            //                         style: TextStyle(
            //                           color: Color(int.parse(
            //                               "0xff${settingsController.navbarTextColor.value}")),
            //                           fontSize:
            //                               settingsController.navbarTextSize.value,
            //                           fontWeight: FontWeight.w600,
            //                         ),
            //                         textAlign: TextAlign.center,
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             );
            //           }),
            //         ),
            //       ),
            //     ),
            //   );
            // }),

            SizedBox(height: 8.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await clearWebViewSessionsAndCookies();
                        await SharedPreferencesHelper.clearAll();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                          (route) => false,
                        );
                        Get.snackbar('Logged Out', 'You have been logged out');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 32),
                        elevation: 6,
                      ),
                      child: Obx(
                        () => logoutLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
