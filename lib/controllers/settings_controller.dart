import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:wordpress/models/hero_model.dart';
import 'package:wordpress/models/navbar_item_model.dart';
import 'package:wordpress/models/onboarding_item.dart';
import 'package:wordpress/models/register_model.dart';

class SettingsController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxString navbarBackgroundColor = "FFFFFF".obs;
  final RxString navbarIconColor = "000000".obs;
  final RxDouble navbarIconSize = 24.0.obs;
  final RxString navbarTextColor = "000000".obs;
  final RxDouble navbarTextSize = 12.0.obs;

  // Navbar items
  final RxList<NavbarItem> navbarItems = <NavbarItem>[].obs;

  //Hero (Carousel) Items
  final RxList<HeroItem> heroItems = <HeroItem>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxBool navBarLoading = false.obs;
  final RxBool loadingHeroItems = false.obs;

  //Onboarding Items:
  final RxList<OnboardingItem> onboardingItems = <OnboardingItem>[].obs;
  final RxBool loadingOnboardingItems = false.obs;

  //Register Items:
  RxList<RegisterItem> registerItems = <RegisterItem>[].obs;

  //SignIn Items:
  final RxString signinButtonBackground = "FFFFFF".obs;
  final RxString signinButtonText = "Save and Continue".obs;
  final RxString signinButtonTextColor = "000000".obs;
  final RxString signinErrorText = "".obs;
  final RxString signinErrorTitle = "".obs;

  //Home Screen Items:
  RxInt carouselFlexValue = 3.obs;
  RxInt navBarFlexValue = 2.obs;
  RxInt webViewFlexValue = 5.obs;

  // Theme Settings
  final RxString headerBgColor = "000000".obs;
  final RxString headerIcon = "".obs;
  final RxString headerTitle = "TheHen".obs;
  final RxString gradientBegin = "Alignment.center".obs;
  final RxString gradientEnd = "Alignment.center".obs;
  final RxString gradientType = "None".obs;
  final RxList<String> gradientColors = <String>[].obs;

//Dashboard
  final RxString dashboardDestination = 'www.google.com'.obs;

  //Drawer Items
  final RxString drawerBgColor = "ffffff".obs;

  @override
  void onInit() {
    super.onInit();

    fetchAllItems();
  }

  void fetchAllItems() async {
    await fetchOnboardingItems();
    await fetchThemeSettings();
    await fetchSigninSettings();
    await fetchSignUpDetails();
    await fetchNavbarSettings();
    await fetchNavbarItems();
    await fetchHomeScreenFlexValues();
    await fetchHeroItems();
    await fetchDashboardSettings();

    isLoading.value = false;
  }

  Future<void> fetchHeroItems() async {
    try {
      loadingHeroItems.value = true;
      DocumentSnapshot heroDoc =
          await _firestore.collection('hero').doc('hero_items').get();

      if (heroDoc.exists) {
        Map<String, dynamic> data = heroDoc.data() as Map<String, dynamic>;
        print('This is the data of the hero items: $data');

        // Extract items
        final List<HeroItem> items = data.entries.map((entry) {
          final Map<String, dynamic> itemData =
              entry.value as Map<String, dynamic>;
          return HeroItem.fromMap(itemData);
        }).toList();

        // Filter only enabled items and sort by _order
        heroItems.value = items.where((item) => item.enabled).toList()
          ..sort((a, b) => a.order.compareTo(b.order));
      }
    } catch (e) {
      print("Error fetching hero items: $e");
    } finally {
      loadingHeroItems.value = false;
    }
  }

  Future<void> fetchNavbarItems() async {
    try {
      navBarLoading.value = true;
      DocumentSnapshot navbarDoc =
          await _firestore.collection('navbar').doc('navbar_items').get();

      if (navbarDoc.exists) {
        Map<String, dynamic> data = navbarDoc.data() as Map<String, dynamic>;
        print('This is the data of the navbar items: $data');

        final List<NavbarItem> items = data.entries.map((entry) {
          final Map<String, dynamic> itemData =
              entry.value as Map<String, dynamic>;
          return NavbarItem.fromMap(itemData);
        }).toList();
        print('This is the items before sorting: ${items.length}');

        navbarItems.value = items.where((item) => item.enabled).toList()
          ..sort((a, b) => a.order.compareTo(b.order));
        print('This is the items after sorting: ${navbarItems.length}');
      }
    } catch (e) {
      print("Error fetching navbar items: $e");
    } finally {
      print('This is the length of the navbar items: ${navbarItems.length}');
      navBarLoading.value = false;
    }
  }

  Future<void> fetchNavbarSettings() async {
    try {
      DocumentSnapshot navbarDoc =
          await _firestore.collection('navbar').doc('navbar_settings').get();

      if (navbarDoc.exists) {
        Map<String, dynamic> data = navbarDoc.data() as Map<String, dynamic>;
        print('This is the data of the navbar settings: $data');

        navbarBackgroundColor.value =
            data['navbar_background_color'] ?? "FFFFFF";
        navbarIconColor.value = data['navbar_icon_color'] ?? "000000";
        navbarIconSize.value =
            double.tryParse(data['navbar_icon_size'] ?? "24") ?? 24.0;
        navbarTextColor.value = data['navbar_text_color'] ?? "000000";
        navbarTextSize.value =
            double.tryParse(data['navbar_text_size'] ?? "12") ?? 12.0;
      } else {
        print("Document does not exist. Using default navbar settings.");
      }
    } catch (e) {
      print("Error fetching navbar settings: $e");
    }
  }

  Future<void> fetchOnboardingItems() async {
    try {
      loadingOnboardingItems.value = true;
      DocumentSnapshot onboardingDoc =
          await _firestore.collection('app_config').doc('Onboarding').get();

      if (onboardingDoc.exists) {
        Map<String, dynamic> data =
            onboardingDoc.data() as Map<String, dynamic>;
        print('This is the data of the onboarding items: $data');

        // Extract items
        final List<OnboardingItem> items = data.entries.map((entry) {
          final Map<String, dynamic> itemData =
              entry.value as Map<String, dynamic>;
          return OnboardingItem.fromMap(itemData);
        }).toList();

        // Filter only enabled items and sort by _order
        onboardingItems.value = items.where((item) => item.enabled).toList()
          ..sort((a, b) => a.order.compareTo(b.order));
      } else {
        print("No onboarding items found in Firestore.");
      }
    } catch (e) {
      print("Error fetching onboarding items: $e");
    } finally {
      loadingOnboardingItems.value = false;
    }
  }

  Future<void> fetchSignUpDetails() async {
    try {
      loadingOnboardingItems.value = true;
      DocumentSnapshot onboardingDoc =
          await _firestore.collection('app_config').doc('signin').get();

      if (onboardingDoc.exists) {
        Map<String, dynamic> data =
            onboardingDoc.data() as Map<String, dynamic>;
        print('This is the data of the signup items: $data');
        print(data['register_destination']);
        print(data['register_text']);
        registerItems.add(RegisterItem(
            registerDestination: data['register_destination'],
            registerText: data['register_text']));

        // Extract items
        // final List<OnboardingItem> items = data.entries.map((entry) {
        //   final Map<String, dynamic> itemData =
        //       entry.value as Map<String, dynamic>;
        //   return OnboardingItem.fromMap(itemData);
        // }).toList();

        // // Filter only enabled items and sort by _order
        // onboardingItems.value = items.where((item) => item.enabled).toList()
        //   ..sort((a, b) => a.order.compareTo(b.order));
      } else {
        registerItems.add(RegisterItem(
            registerDestination: 'https://thehen.io/registration/',
            registerText: 'Not registered yet? Click here to register'));
        print("No signup items found in Firestore.");
      }
    } catch (e) {
      print("Error fetching signup items: $e");
    } finally {
      loadingOnboardingItems.value = false;
    }
  }

  Future<void> fetchSigninSettings() async {
    try {
      DocumentSnapshot signinDoc =
          await _firestore.collection('app_config').doc('Signin').get();

      if (signinDoc.exists) {
        Map<String, dynamic> data = signinDoc.data() as Map<String, dynamic>;
        print('This is the data of the Signin settings: $data');

        // Update the controller variables
        signinButtonBackground.value =
            data['signin_button_background'] ?? "FFFFFF";
        signinButtonText.value =
            data['signin_button_text'] ?? "Save and Continue";
        signinButtonTextColor.value =
            data['signin_button_textcolor'] ?? "000000";
        signinErrorText.value = data['signin_error_text'] ??
            "Please check your login details or register";
        signinErrorTitle.value = data['signin_error_title'] ?? "Login error";
      } else {
        print("Signin document does not exist. Using default values.");
      }
    } catch (e) {
      print("Error fetching Signin settings: $e");
    }
  }

  Future<void> fetchHomeScreenFlexValues() async {
    try {
      DocumentSnapshot homeScreenDoc =
          await _firestore.collection('app_config').doc('Homescreen').get();

      if (homeScreenDoc.exists) {
        Map<String, dynamic> data =
            homeScreenDoc.data() as Map<String, dynamic>;
        print('This is the data of the Homescreen flex values: $data');

        int carouselFlex = data['carousel_flex'] ?? 3;
        int navBarFlex = data['nav_bar_flex'] ?? 2;
        int webViewFlex = data['web_view_flex'] ?? 5;

        print('Carousel Flex: $carouselFlex');
        print('Navbar Flex: $navBarFlex');
        print('Web View Flex: $webViewFlex');
      } else {
        print("Homescreen document does not exist. Using default values.");
      }
    } catch (e) {
      print("Error fetching Homescreen flex values: $e");
    }
  }

  Future<void> fetchThemeSettings() async {
    try {
      DocumentSnapshot themeDoc =
          await _firestore.collection('app_config').doc('Theme').get();

      if (themeDoc.exists) {
        Map<String, dynamic> data = themeDoc.data() as Map<String, dynamic>;
        print('This is the data of the Theme settings: $data');

        headerBgColor.value = data['header_bg_color'];
        print("This is the headerBgColor: ${headerBgColor.value}");
        headerIcon.value = data['header_icon'] ?? "";
        headerTitle.value = data['header_title'] ?? "Default Title";
        gradientBegin.value =
            data['theme_gradient_begin'] ?? "Alignment.center";
        gradientEnd.value = data['theme_gradient_end'] ?? "Alignment.center";
        gradientType.value = data['theme_gradient_type'] ?? "None";
        print(
            'This is the type of the gradient colors: ${data['theme_gradient_colors'].runtimeType}');
        gradientColors.value = (data['theme_gradient_colors'] as List<dynamic>)
            .map((colorString) => colorString as String)
            .toList();

        print('Header Background Color: ${headerBgColor.value}');
        print('Header Icon: ${headerIcon.value}');
        print('Header Title: ${headerTitle.value}');
        print('Gradient Begin: ${gradientBegin.value}');
        print('Gradient End: ${gradientEnd.value}');
        print('Gradient Type: ${gradientType.value}');
        print('Gradient Colors: ${gradientColors}');
      } else {
        print("Theme document does not exist.");
      }
    } catch (e) {
      print("Error fetching Theme settings: $e");
    }
  }

  Future<void> fetchDashboardSettings() async {
    try {
      DocumentSnapshot dashboardDoc =
          await _firestore.collection('app_config').doc('Dashboard').get();

      if (dashboardDoc.exists) {
        Map<String, dynamic> data = dashboardDoc.data() as Map<String, dynamic>;
        print('This is the data of the Dashboard settings: $data');

        // Update the reactive variable
        dashboardDestination.value = data['destination'] ?? '';
      } else {
        print("Dashboard document does not exist.");
      }
    } catch (e) {
      print("Error fetching Dashboard settings: $e");
    }
  }
}
