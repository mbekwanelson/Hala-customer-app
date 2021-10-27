import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationN {
  double lat;
  double long;

  LocationN({this.lat, this.long});

  LatLng loc() {
    return LatLng(lat, long);
  }
}
