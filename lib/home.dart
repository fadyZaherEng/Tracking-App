// ignore_for_file: must_be_immutable

// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_app/home_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  dynamic destination;
  var destController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) =>
          Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: const Text(
                'Google Maps',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
              actions: [
                Center(
                  child: SizedBox(
                    width: 150,
                    child: TextFormField(
                      controller: destController,
                      decoration: const InputDecoration(
                        labelText: 'Destination',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            color: Colors.white),
                        prefixIcon: Icon(Icons.share_arrival_time_outlined,color: Colors.white,),
                      ),
                      style:const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                          color: Colors.white),
                      onChanged: (val) {
                        destination = val.toString();
                      },
                    ),
                  ),
                ),
              ],
            ),
            body: GoogleMap(
              initialCameraPosition: controller.cameraPosition,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController googleMapController) {
                controller.onMapCreated(googleMapController);
              },
              markers: Set.of(
                  controller.origin != null ? [controller.origin as Marker] : [
                  ]),
              circles: Set.of(
                  controller.circle != null ? [controller.circle as Circle] : [
                  ]),
              //polylines: controller.polylines,
              polylines: myPolyLines.toSet(),
            ),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () async {
                    await controller.getCurrentLocation();
                    createPolyLine(controller.currLocation, destController.text);
                  },
                  child: const Icon(CupertinoIcons.location),
                ),
                const SizedBox(
                  width: 5,
                ),
                FloatingActionButton(
                  onPressed: () async {
                    var location = controller.currLocation;
                    print(destController.text);
                    dynamic locations =
                    await locationFromAddress(destController.text);
                    controller.drawPolyline(
                      LatLng(location.latitude as double,
                          location.longitude as double),
                      LatLng(
                          locations.first.latitude, locations.first.longitude),
                    );
                  },
                  child: const Icon(Icons.settings_ethernet_rounded),
                ),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation
                .centerFloat,
          ),
    );
  }

  List<Polyline> myPolyLines = [];

  createPolyLine(LocationData start, String des) async {
    dynamic locations = await locationFromAddress(des);
    myPolyLines.add(
      Polyline(
        polylineId: const PolylineId(
          'way',
        ),
        color: Colors.blue,
        width: 3,
        points: [
          LatLng(start.latitude as double, start.longitude as double),
          LatLng(locations.first.latitude, locations.first.longitude),
        ],
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ),
    );
  }
}
