import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/rider/controller/provider/tripProvider/rideRequestProvider.dart';

import '../../../common/controller/services/locationServices.dart';

class BookARideScreen extends StatefulWidget {
  const BookARideScreen({super.key});

  @override
  State<BookARideScreen> createState() => _BookARideScreenState();
}

class _BookARideScreenState extends State<BookARideScreen> {
  Completer<GoogleMapController> mapControllerDriver = Completer();
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RideRequestProvider>(
      builder: (context, rideRequestProvider, child) {
        return GoogleMap(
          initialCameraPosition: rideRequestProvider.initialCameraPosition,
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          zoomControlsEnabled: true,
          zoomGesturesEnabled: true,
          polylines: rideRequestProvider.polylineSet,
          markers: rideRequestProvider.riderMarker,
          onMapCreated: (GoogleMapController controller) async {
            if (!mapControllerDriver.isCompleted) {
              mapControllerDriver.complete(controller);
            }
            mapController = controller;
            LatLng pickupLocation = LatLng(
              rideRequestProvider.pickupLocation!.latitude!,
              rideRequestProvider.pickupLocation!.longitude!,
            );
            CameraPosition cameraPosition = CameraPosition(
              target: pickupLocation,
              zoom: 14,
            );
            mapController!.animateCamera(
              CameraUpdate.newCameraPosition(cameraPosition),
            );
          },
        );
      },
    );
  }
}
