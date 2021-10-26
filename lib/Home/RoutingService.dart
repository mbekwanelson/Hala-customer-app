// /*
//  * Copyright (C) 2019-2020 HERE Europe B.V.
//  *
//  * Licensed under the Apache License, Version 2.0 (the "License")
//  * you may not use this file except in compliance with the License.
//  * You may obtain a copy of the License at
//  *
//  *     http://www.apache.org/licenses/LICENSE-2.0
//  *
//  * Unless required by applicable law or agreed to in writing, software
//  * distributed under the License is distributed on an "AS IS" BASIS,
//  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  * See the License for the specific language governing permissions and
//  * limitations under the License.
//  *
//  * SPDX-License-Identifier: Apache-2.0
//  * License-Filename: LICENSE
//  */
//
// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:location/location.dart' as l;
// import 'package:here_sdk/core.dart';
// import 'package:here_sdk/mapview.dart';
// import 'package:here_sdk/routing.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:here_sdk/routing.dart' as here;
// import 'package:mymenu/Maps/Models/LocationN.dart';
// import 'package:mymenu/Shared/Loading.dart';
//
// class RoutingService {
//   BuildContext _context;
//   HereMapController _hereMapController;
//   List<MapPolyline> _mapPolylines = [];
//   List<dynamic> _explorePlace = [];
//   RoutingEngine _routingEngine;
//   l.LocationData userLocation;
//   //LocationN
//   //Wasteland koo 44 -34.044914456136276, 18.69690016179641
//
//
//   RoutingService(BuildContext context, HereMapController hereMapController,LocationN driverLocation) {
//     print("Sikhona baba!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//     _context = context;
//     _hereMapController = hereMapController;
//
//     double distanceToEarthInMeters = 10000;
//
//     getLocation().then((value) {
//       userLocation = value;
//       _hereMapController
//            .camera
//            .lookAtPointWithDistance(GeoCoordinates(userLocation.latitude, userLocation.longitude), distanceToEarthInMeters);
//       _routingEngine = new RoutingEngine();
//       addRoute(driverLocation);
//     });
//
//   }
//
//   Future<void> addRoute(LocationN driverLocation) async {
//     print("${userLocation.latitude}####################################################################################################################################################");
//     print("${userLocation.longitude}####################################################################################################################################################");
//     print("Driver####################################################################################################################################################");
//
//     print("${driverLocation.lat}####################################################################################################################################################");
//     print("${driverLocation.long}####################################################################################################################################################");
//
//     var startGeoCoordinates = GeoCoordinates(userLocation.latitude, userLocation.longitude);
//     //Wasteland koo 44 -34.044914456136276, 18.69690016179641
//     //var destinationGeoCoordinates = GeoCoordinates(-34.044914456136276, 18.69690016179641);
//     var destinationGeoCoordinates = GeoCoordinates(driverLocation.lat, driverLocation.long);
//
//     var startWaypoint = Waypoint.withDefaults(startGeoCoordinates);
//     var destinationWaypoint = Waypoint.withDefaults(destinationGeoCoordinates);
//
//     List<Waypoint> waypoints = [startWaypoint, destinationWaypoint];
//
//     await _routingEngine.calculateCarRoute(waypoints, CarOptions.withDefaults(),
//             (RoutingError routingError, List<here.Route> routeList) async {
//           if (routingError == null) {
//             here.Route route = routeList.first;
//             _showRouteDetails(route);
//             _showRouteOnMap(route);
//             _logRouteViolations(route);
//           } else {
//             var error = routingError.toString();
//             _showDialog('Error', 'Error while calculating a route: $error');
//           }
//         });
//   }
//
//   // A route may contain several warnings, for example, when a certain route option could not be fulfilled.
//   // An implementation may decide to reject a route if one or more violations are detected.
//   void _logRouteViolations(here.Route route) {
//     for (var section in route.sections) {
//       for (var notice in section.notices) {
//         print("This route contains the following warning: " + notice.code.toString());
//       }
//     }
//   }
//
//   void clearMap() {
//     for (var mapPolyline in _mapPolylines) {
//       _hereMapController.mapScene.removeMapPolyline(mapPolyline);
//     }
//     _mapPolylines.clear();
//     _hereMapController.release();
//   }
//
//   void _showRouteDetails(here.Route route) {
//     int estimatedTravelTimeInSeconds = route.durationInSeconds;
//     int lengthInMeters = route.lengthInMeters;
//
//     String routeDetails = 'Travel Time: ' +
//         _formatTime(estimatedTravelTimeInSeconds) +
//         ', Length: ' +
//         _formatLength(lengthInMeters);
//
//     _showDialog('Route Details', '$routeDetails');
//   }
//
//   String _formatTime(int sec) {
//     int hours = sec ~/ 3600;
//     int minutes = (sec % 3600) ~/ 60;
//
//     return '$hours:$minutes min';
//   }
//
//   String _formatLength(int meters) {
//     int kilometers = meters ~/ 1000;
//     int remainingMeters = meters % 1000;
//
//     return '$kilometers.$remainingMeters km';
//   }
//
//   _showRouteOnMap(here.Route route) {
//     // Show route as polyline.
//     GeoPolyline routeGeoPolyline = GeoPolyline(route.polyline);
//
//     double widthInPixels = 20;
//     MapPolyline routeMapPolyline = MapPolyline(
//         routeGeoPolyline, widthInPixels, Color.fromARGB(160, 0, 144, 138));
//
//     _hereMapController.mapScene.addMapPolyline(routeMapPolyline);
//     _mapPolylines.add(routeMapPolyline);
//   }
//
//   /*GeoCoordinates _createRandomGeoCoordinatesInViewport() {
//     //GeoBox geoBox = _hereMapController.camera.boundingBox;
//     //if (geoBox == null) {
//       // Happens only when map is not fully covering the viewport.
//       //return GeoCoordinates(52.530932, 13.384915);
//       //return GeoCoordinates(-34.03994351477021, 18.711208998284945);
//       // //Wasteland koo 44 -34.044914456136276, 18.69690016179641
//       //return GeoCoordinates(-34.044914456136276, 18.69690016179641);
//     //}
//
//
//     //making app crash
//     /*
//     GeoCoordinates northEast = geoBox.northEastCorner;
//     GeoCoordinates southWest = geoBox.southWestCorner;
//
//     double minLat = southWest.latitude;
//     double maxLat = northEast.latitude;
//     double lat = _getRandom(minLat, maxLat);
//
//     double minLon = southWest.longitude;
//     double maxLon = northEast.longitude;
//     double lon = _getRandom(minLon, maxLon);
//     return new GeoCoordinates(lat, lon);*/
//   }*/
//
//   /*double _getRandom(double min, double max) {
//     return min + Random().nextDouble() * (max - min);
//   }*/
//
//   Future<void> _showDialog(String title, String message) async {
//     return showDialog<void>(
//       context: _context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text(message),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future getLocation() async {
//     var location = new l.Location();
//     try {
//       userLocation = await location.getLocation();
//     } on PlatformException catch (error) {
//       if (error.code == 'PERMISSION_DENIED') {
//         print("Permission Dennied");
//       }
//       userLocation = null;
//     }
//     return userLocation;
//   }
// }