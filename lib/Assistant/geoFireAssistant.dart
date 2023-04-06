import '../Models/nearbyAvailableDrivers.dart';

class GeoFireAssistant {
  static List<NearByAvailableDrivers> nearbyAvailableDriversList = [];

  static void removeDriverFromList(String key) {
    int index =
        nearbyAvailableDriversList.indexWhere((element) => element.key == key);
    nearbyAvailableDriversList.removeAt(index);
  }

  static void updateDriverNearbyLocation(NearByAvailableDrivers driver) {
    int index = nearbyAvailableDriversList
        .indexWhere((element) => element.key == driver.key);

    nearbyAvailableDriversList[index].longitude = driver.longitude;
    nearbyAvailableDriversList[index].latitude = driver.latitude;
  }
}
