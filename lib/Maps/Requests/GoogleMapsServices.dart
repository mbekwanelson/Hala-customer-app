import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = "AIzaSyB6KaI6MDBB2gorARw-DpktzVRRQQTFmZ0";

class GoogleMapsServices {
  Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey";
    http.Response response = await http.get(Uri.parse(url));
    Map values = jsonDecode(response.body);
    return values["routes"][0]["legs"][0]["distance"]["value"].toString();
  }
}
