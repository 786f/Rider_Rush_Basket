import 'package:get/get.dart';

class VehicleModel {
  final String id;
  final String name;
  VehicleModel(this.id, this.name);
}

class CityModel {
  final String id;
  final String city;
  CityModel(this.id, this.city);
}

class StoreModel {
  final String id;
  final String store;
  StoreModel(this.id, this.store);
}

class WorkDetailsController extends GetxController {
  // -------------------------- LOADING FLAGS --------------------------
  RxBool loadingVehicles = false.obs;
  RxBool loadingCities = false.obs;
  RxBool loadingStores = false.obs;

  // -------------------------- DROPDOWN DATA --------------------------
  RxList<VehicleModel> vehicles = <VehicleModel>[].obs;
  RxList<CityModel> cities = <CityModel>[].obs;
  RxList<StoreModel> stores = <StoreModel>[].obs;

  // -------------------------- SELECTED IDs --------------------------
  RxString selectedVehicleId = RxString("");
  RxString selectedCityId = RxString("");
  RxString selectedStoreId = RxString("");

  @override
  void onInit() {
    super.onInit();
    loadDummyVehicles();
    loadDummyCities();
  }

  // ------------------------------------------------------------------
  //                         DUMMY VEHICLE LIST
  // ------------------------------------------------------------------
  void loadDummyVehicles() async {
    loadingVehicles.value = true;

    await Future.delayed(const Duration(milliseconds: 800));

    vehicles.value = [
      VehicleModel("1", "Bike"),
      VehicleModel("2", "Scooter"),
      VehicleModel("3", "Bicycle"),
      VehicleModel("4", "E-Bike"),
    ];

    selectedVehicleId.value = vehicles.first.id;
    loadingVehicles.value = false;
  }

  // ------------------------------------------------------------------
  //                           DUMMY CITY LIST
  // ------------------------------------------------------------------
  void loadDummyCities() async {
    loadingCities.value = true;

    await Future.delayed(const Duration(milliseconds: 800));

    cities.value = [
      CityModel("1", "Bangalore"),
      CityModel("2", "Hyderabad"),
      CityModel("3", "Delhi NCR"),
      CityModel("4", "Mumbai"),
    ];

    selectedCityId.value = cities.first.id;

    // Load stores for default first city
    fetchStoresForCity(selectedCityId.value);

    loadingCities.value = false;
  }

  // ------------------------------------------------------------------
  //                     DUMMY STORE LIST BASED ON CITY
  // ------------------------------------------------------------------
  void fetchStoresForCity(String cityId) async {
    loadingStores.value = true;

    await Future.delayed(const Duration(milliseconds: 500));

    Map<String, List<StoreModel>> dummyStoreMap = {
      "1": [
        StoreModel("101", "Bangalore - Whitefield Hub"),
        StoreModel("102", "Bangalore - Indiranagar Hub"),
        StoreModel("103", "Bangalore - Koramangala Hub"),
      ],
      "2": [
        StoreModel("201", "Hyderabad - Gachibowli Hub"),
        StoreModel("202", "Hyderabad - HiTech City Hub"),
      ],
      "3": [
        StoreModel("301", "Delhi - Rohini Depot"),
        StoreModel("302", "Delhi - Dwarka Distribution"),
      ],
      "4": [
        StoreModel("401", "Mumbai - Andheri Hub"),
        StoreModel("402", "Mumbai - Navi Mumbai Hub"),
      ],
    };

    stores.value = dummyStoreMap[cityId] ?? [];

    if (stores.isNotEmpty) {
      selectedStoreId.value = stores.first.id;
    }

    loadingStores.value = false;
  }

  // ------------------------------------------------------------------
  //                         VALIDATION
  // ------------------------------------------------------------------
  bool validate() {
    return selectedVehicleId.isNotEmpty &&
        selectedCityId.isNotEmpty &&
        selectedStoreId.isNotEmpty;
  }

  // ------------------------------------------------------------------
  //               DATA TO PASS TO NEXT PAGE (DOCUMENTS PAGE)
  // ------------------------------------------------------------------
  Map<String, dynamic> getSelectedData() {
    return {
      "vehicle": vehicles.firstWhere((e) => e.id == selectedVehicleId.value).name,
      "city": cities.firstWhere((e) => e.id == selectedCityId.value).city,
      "store": stores.firstWhere((e) => e.id == selectedStoreId.value).store,
    };
  }
}
