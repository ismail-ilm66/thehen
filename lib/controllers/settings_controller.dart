import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:wordpress/models/hero_model.dart';
import 'package:wordpress/models/navbar_item_model.dart';

class SettingsController extends GetxController {
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

  @override
  void onInit() {
    super.onInit();
    fetchNavbarSettings();
    fetchNavbarItems();
    fetchHeroItems();
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
}
