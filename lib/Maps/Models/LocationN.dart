import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationN{

  double lat;
  double long;

  LocationN({this.lat,this.long});

  LatLng Loc(){
    return LatLng(lat,long);
  }


}