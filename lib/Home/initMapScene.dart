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
// import 'package:flutter/material.dart';
// import 'package:here_maps_webservice/here_maps_webservice.dart';
// import 'package:here_sdk/mapview.dart';
// import 'package:mymenu/Authenticate/Auth.dart';
// import 'package:mymenu/Maps/Models/LocationN.dart';
// import 'package:mymenu/Shared/Database.dart';
// import 'package:mymenu/Shared/Loading.dart';
// import 'RoutingService.dart';
//
//
//
// class initMapScene extends StatefulWidget {
//   // Use _context only within the scope of this widget.
//   @override
//   _initMapSceneState createState() => _initMapSceneState();
// }
//
// class _initMapSceneState extends State<initMapScene> {
//   BuildContext _context;
//   LocationN _locationN;
//   RoutingService _routingExample;
//   dynamic uid;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Auth().inputData().then((value){
//       setState(() {
//         uid = value;
//       });
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     // _locationN = null;
//     // _routingExample =null;
//
//     //rebuildAllChildren(_context);
//     return StreamBuilder<LocationN>(
//       stream: Database().DriverLocation(uid: uid),
//       builder: (context, snapshot) {
//         if(!snapshot.hasData){
//          return Loading();
//         }
//         _context= context;
//         print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> WE RELODED!!!! >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//
//         _locationN = snapshot.data;
//
//
//         return Scaffold(
//             appBar: AppBar(
//               title:Text(
//                 "Driver Progress",
//                 style: TextStyle(
//                     letterSpacing: 2
//                 ),
//               ),
//               centerTitle: true,
//               backgroundColor: Colors.black,
//             ),
//             body: Container(
//               child:
//                 StreamBuilder<LocationN>(
//                   stream:  Database().DriverLocation(uid: uid),
//                   builder: (context, snapshot) {
//                     print("---------------------------------------------------------------------- heylo -----------------------------------------------");
//
//                       return HereMap(onMapCreated: _onMapCreated);
//
//
//
//                   }
//
//                 ),
//
//
//             ),
//           );
//       }
//     );
//   }
//
//   void _onMapCreated(HereMapController hereMapController) {
//     print("Track this bitch!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//
//     hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalNight,
//             (MapError error) {
//           if (error == null) {
//             _routingExample = null;
//
//             _routingExample = RoutingService(_context, hereMapController,_locationN);
//
//             _routingExample.clearMap();
//
//           } else {
//             print("Map scene not loaded. MapError: " + error.toString());
//           }
//         });
//
//   }
//
//
//   void rebuildAllChildren(BuildContext context) {
//     void rebuild(Element el) {
//       el.markNeedsBuild();
//       el.visitChildren(rebuild);
//     }
//     (context as Element).visitChildren(rebuild);
//   }
//
//   void _backButtonClicked() {
//     Navigator.pop(_context);
//   }
// }