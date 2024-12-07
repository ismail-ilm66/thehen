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
import 'package:wordpress/helpers/helper_functions.dart';
import 'package:wordpress/helpers/shared_preferences_helper.dart';
import 'package:wordpress/screens/auto_login.dart';
import 'package:wordpress/screens/login.dart';
import 'package:wordpress/widgets/custom_navbar_widget.dart';

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
  final SettingsController settingsController = Get.find();
  String name = '';
  late InAppWebViewController _webViewController;
  var currentUrl = "https://joyuful.com/login/".obs;
  final RxBool logoutLoading = false.obs;

  RxInt _currentPage = 0.obs;
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
        "This is the header background color in init: ${settingsController.headerBgColor.value}");
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
    print('This is the header icon: ${settingsController.headerIcon.value}');
    print(
        'This is the background color: ${settingsController.headerBgColor.value}');
    return Scaffold(
      // backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Text(settingsController.headerTitle.value),
            Text("Welcome $name"),

            const SizedBox(
              width: 8,
            ),
            if (settingsController.headerIcon.value.isEmpty)
              Image.asset(
                'assets/joyuful-icon.png',
                height: 35,
                width: 35,
              ),
            if (settingsController.headerIcon.value.isNotEmpty)
              Image.network(
                settingsController.headerIcon.value,
                height: 35,
                width: 35,
              ),
          ],
        ),
        backgroundColor: Color(
          int.parse(
            '0xff${settingsController.headerBgColor.value}',
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: settingsController.drawerBgColor.value.isEmpty
            ? Colors.white
            : Color(
                int.parse(
                  '0xff${settingsController.drawerBgColor.value}',
                ),
              ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200, // Adjust the height as per your design
              decoration: const BoxDecoration(
                color: ColorPalette.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Image.asset('assets/joyuful-icon.png', height: 100),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: settingsController.navbarItems.length,
                itemBuilder: (context, index) {
                  print('This is the index: $index');
                  print(
                      'This is the length of the navbar items: ${settingsController.navbarItems.length}');
                  if (index == (settingsController.navbarItems.length - 1)) {
                    return GestureDetector(
                      onTap: () async {
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
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 4.h),
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(2, 4),
                            )
                          ],
                        ),
                        child: Row(
                          // mainAxisSize: MainAxisSize.min,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout,
                              color: Color(
                                int.parse(
                                  "0xff${settingsController.navbarIconColor.value}",
                                ),
                              ),
                              size: settingsController.navbarIconSize.value,
                            ),
                            SizedBox(width: 8.h),
                            Text(
                              'Logout',
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
                  }
                  final link = settingsController.navbarItems[index + 1];
                  return CustomDrawerButton(
                    label: link.label,
                    iconUrl: link.iconUrl,
                    destination: link.destination,
                    iconSize: settingsController.navbarIconSize.value,
                    backgroundColor:
                        settingsController.navbarBackgroundColor.value,
                    textColor: settingsController.navbarTextColor.value,
                    textSize: settingsController.navbarTextSize.value,
                    iconColor: settingsController.navbarIconColor.value,
                  );
                },
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            flex: settingsController.carouselFlexValue.value,
            child: SizedBox(
              // height: screenHeight * 0.36,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                          height: MediaQuery.of(context).size.width * 1.4 / 3,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason) {
                            _currentPage.value = index;
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
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
                    },
                  ),
                  Obx(
                    () => SmoothPageIndicator(
                      controller: PageController(
                        initialPage: _currentPage.value,
                      ),
                      count: settingsController.heroItems.length,
                      effect: const ExpandingDotsEffect(
                        activeDotColor: Color(0xFF000000),
                        dotColor: Color(0xFFB0B0B0),
                        dotHeight: 8,
                        dotWidth: 8,
                        expansionFactor: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Slider Indicator

          Expanded(
            flex: settingsController.webViewFlexValue.value,
            child: Obx(
              () => SizedBox(
                child: GestureDetector(
                  onVerticalDragUpdate: (_) => true,
                  child: InAppWebView(
                    gestureRecognizers: Set()
                      ..add(Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer())),
                    initialUrlRequest: URLRequest(
                      url:
                          WebUri(settingsController.dashboardDestination.value),
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
          ),

          Expanded(
            // flex: 1,
            child: Obx(() {
              if (settingsController.navBarLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SizedBox(
                // height: screenHeight * 0.2,
                child: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w)
                          .copyWith(top: 8.w),
                      child: CustomDrawerButton(
                        label: settingsController.navbarItems.first.label,
                        iconUrl: settingsController.navbarItems.first.iconUrl,
                        destination:
                            settingsController.navbarItems.first.destination,
                        iconSize: settingsController.navbarIconSize.value,
                        backgroundColor:
                            settingsController.navbarBackgroundColor.value,
                        textColor: settingsController.navbarTextColor.value,
                        textSize: settingsController.navbarTextSize.value,
                        iconColor: settingsController.navbarIconColor.value,
                      )),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
