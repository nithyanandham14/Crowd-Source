import 'package:geolocator/geolocator.dart';

Future<void> getLocation() async {
  LocationPermission permission = await Geolocator.requestPermission();

  if (permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse) {
    await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    // print("Lat: ${position.latitude}");
    // print("Lng: ${position.longitude}");
  }
}
