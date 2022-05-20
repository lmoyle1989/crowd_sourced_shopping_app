import 'package:location/location.dart';
import 'package:flutter/services.dart';

Future<LocationData> getLocation() async {
  Location locationService = Location();

  LocationData locationData;

  try {
    bool _serviceEnabled = await locationService.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await locationService.requestService();
      if (!_serviceEnabled) {
        return Future.error('Failed to enable service. Returning.');
      }
    }

    PermissionStatus _permissionGranted = await locationService.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await locationService.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return Future.error(
            'Location service permission not granted. Returning.');
      }
    }

    locationData = await locationService.getLocation();
  } on PlatformException catch (e) {
    return Future.error('Error: ${e.toString()}, code: ${e.code}');
  }
  return locationData;
}
