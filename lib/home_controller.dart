// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_app/polyline_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:location/location.dart';

class HomeController extends GetxController {

  Location liveLocation = Location();
  Marker? origin;
  Circle? circle;
  GoogleMapController? googleMapController;

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(52.2165157, 6.9437819),
    zoom: 14.4746,
  );

  void onMapCreated(GoogleMapController MapController) {
    googleMapController = MapController;
  }
  dynamic currLocation;
  Future<Uint8List> getMarker() async {
    ByteData byteData = await rootBundle.load('assets/images/marker.png');
    return byteData.buffer.asUint8List();
  }
  Future<void> getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      currLocation = await liveLocation.getLocation();
      liveLocation.onLocationChanged.listen((locationData) {
        currLocation=locationData;
        LatLng latLng = LatLng(
            locationData.latitude as double, locationData.longitude as double);
        googleMapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: 18),
          ),
        );
        updateCurrentLocation(imageData, locationData);
      });
    } catch (e) {
      print(e.toString());
    }
  }
  void updateCurrentLocation(Uint8List imageData, LocationData location) {
    LatLng latLng =
        LatLng(location.latitude as double, location.longitude as double);
    origin = Marker(
      markerId: const MarkerId('me'),
      position: latLng,
      icon: BitmapDescriptor.fromBytes(imageData),
      flat: true,
      draggable: false,
      zIndex: 2,
      rotation: location.heading as double,
    );
    circle = Circle(
      circleId: const CircleId('car'),
      center: latLng,
      radius: location.accuracy as double,
      strokeColor: Colors.black,
      strokeWidth: 2,
      zIndex: 1,
      fillColor: Colors.purple.withAlpha(60),
    );
    update();
  }


  //paid
  Set<Polyline> polylines = {};
  Future<void> drawPolyline(LatLng from, LatLng to) async {
    Polyline polyline = await PolylineService().drawPolyline(from, to);
    polylines.add(polyline);
  }
 //search address paid

  // Set<Polyline> polylines = {};
  //
  // Future<void> _showSearchDialog(context) async {
  //   var p = await PlacesAutocomplete.show(
  //       context: context,
  //       apiKey: 'AIzaSyANHFLOPg0mwSHWW1bqBx5XgOrk1SjTVEw',
  //       mode: Mode.fullscreen,
  //       language: "ar",
  //       region: "ar",
  //       offset: 0,
  //       hint: "Type here...",
  //       radius: 1000,
  //       types: [],
  //       strictbounds: false,
  //       components: [Component(Component.country, "ar")]);
  //   _getLocationFromPlaceId(p!.placeId!);
  // }
  //
  // Future<void> _getLocationFromPlaceId(String placeId) async {
  //   GoogleMapsPlaces _places = GoogleMapsPlaces(
  //     apiKey: 'AIzaSyANHFLOPg0mwSHWW1bqBx5XgOrk1SjTVEw',
  //     apiHeaders: await const GoogleApiHeaders().getHeaders(),
  //   );
  //
  //   PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(placeId);
  //
  //   googleMapController!.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(target: LatLng(detail.result.geometry!.location.lat,
  //           detail.result.geometry!.location.lng), zoom: 18),
  //     ),
  //   );
  //   update();
  // }

}
