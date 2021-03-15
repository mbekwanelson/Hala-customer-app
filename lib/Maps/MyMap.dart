// import 'dart:typed_data';
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// //import 'package:google_map_polyline/google_map_polyline.dart';
// //import 'package:google_maps_webservice/places.dart';
// import 'package:mymenu/Maps/Models/LocationN.dart';
// import 'package:permission/permission.dart';
// import 'package:provider/provider.dart';
// import 'package:mymenu/Maps/State/AppState.dart';
//
//
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
//
// class MyMap extends StatefulWidget {
//   final String title;
//   MyMap({Key key, this.title}) : super(key: key);
//   @override
//   _MyMapState createState() => _MyMapState();
// }
//
// class _MyMapState extends State<MyMap> {
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Map(),
//     );
//   }
// }
//
// class Map extends StatefulWidget {
//   @override
//   _MapState createState() => _MapState();
// }
//
// class _MapState extends State<Map> {
//   int directionsApiCall=0;
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final appState = Provider.of<AppState>(context);
//     print("_________LENGTH_____________");
//     if (appState.markers.length >2){
//       appState.markers.clear();
//     }
//     print(appState.markers.length);
//     //appState.markers.removeWhere((element) => element.markerId == "Naledi");
//     //appState.markers.removeWhere((element) => element.markerId == "Naledi");
//
//     // location from driver
//     final locat = Provider.of<List<LocationN>>(context);
//
//
//
//
//
//     try{
//
//
//
//       appState.markers.add(
//           Marker(
//             markerId:MarkerId("Naledi"),// where user is currently at
//             position: LatLng(locat[0].lat,locat[0].long),
//             infoWindow: InfoWindow(    //just adds more info
//                 title:"Driver",
//                 snippet: "Delivering Order"
//
//             ),
//             icon:appState.icon,  // just the default marker icon
//           )
//       );
//       // To avoid api being called many times. only draws one route from the beginning
//       print("==================== $directionsApiCall ==============================");
//      if(directionsApiCall==0){
//        appState.sendRequest(-29.8579,31.0292);
//        directionsApiCall++;
//      }
//
//
//     }
//     catch(e){
//       print("______________________No data from db__________________ $e");
//     }
//     return appState.initialPosition == null
//         ? Container(
//       alignment: Alignment.center,
//       child: Center(
//         child: CircularProgressIndicator(),
//       ),
//     )
//         : Stack(
//       children: [
//         GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: appState.initialPosition,
//             zoom: 18,
//           ),
//           mapType: MapType.normal,
//           onMapCreated:appState.onCreated, //created method onCreated ourselves. What should happen when map is created?
//           myLocationEnabled: true, //Will get back current location of user
//           compassEnabled: true, // will show you direction of north, south etc
//           markers: appState.markers,
//           onCameraMove: appState.onCameraMove, //
//           polylines:appState.polyLines, // Own method, will draw lines onto map
//         ),
//         Positioned(
//           top: 50.0,
//           right: 15.0,
//           left: 15.0,
//           child: Container(
//             height: 50.0,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(3.0),
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.grey,
//                     offset: Offset(1.0, 5.0),
//                     blurRadius: 10,
//                     spreadRadius: 3)
//               ],
//             ),
//             child: TextField(
//               cursorColor: Colors.black,
//               controller: appState.locationController,
//               decoration: InputDecoration(
//                 icon: Container(
//                   margin: EdgeInsets.only(left: 20, top: 5),
//                   width: 10,
//                   height: 10,
//                   child: Icon(
//                     Icons.location_on,
//                     color: Colors.black,
//                   ),
//                 ),
//                 hintText: "pick up",
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
//               ),
//             ),
//           ),
//         ),
//
// //        Positioned(
// //          top: 105.0,
// //          right: 15.0,
// //          left: 15.0,
// //          child: Container(
// //            height: 50.0,
// //            width: double.infinity,
// //            decoration: BoxDecoration(
// //              borderRadius: BorderRadius.circular(3.0),
// //              color: Colors.white,
// //              boxShadow: [
// //                BoxShadow(
// //                    color: Colors.grey,
// //                    offset: Offset(1.0, 5.0),
// //                    blurRadius: 10,
// //                    spreadRadius: 3)
// //              ],
// //            ),
// //
// //        ),
// //
// //        )
//        ],
//     );
//
//
//   }
//
//
//
//
// }
