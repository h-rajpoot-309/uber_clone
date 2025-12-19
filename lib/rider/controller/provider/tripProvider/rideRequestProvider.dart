import 'dart:developer';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone/common/model/pickupNDropLocationModel.dart';
import 'package:flutter/services.dart';

import '../../../../common/model/directionModel.dart';

class RideRequestProvider extends ChangeNotifier {
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(37.4, -122),
    zoom: 14.4746,
  );
  Set<Marker> riderMarker = Set<Marker>();
  Set<Polyline> polylineSet = {};
  Polyline? polyline;
  List<LatLng> polylineCoordinatesList = [];
  DirectionModel? directionDetails;
  BitmapDescriptor? carIconForMap;
  BitmapDescriptor? destinationIconForMap;
  BitmapDescriptor? pickupIconForMap;
  bool updateMarkerbool = false;
  PickupNDropLocationModel? pickupLocation;
  PickupNDropLocationModel? dropLocation;
  int uberGoFare = 0;
  int uberGoSedanFare = 0;
  int uberPremierFare = 0;
  int uberXLFare = 0;

  makeFareZero() {
    int uberGoFare = 0;
    int uberGoSedanFare = 0;
    int uberPremierFare = 0;
    int uberXLFare = 0;
    notifyListeners();
  }

  getFare() {
    int baseFare = 50;
    int uberGoDistancePerKM = 12;
    int uberGoSedanDistancePerKM = 15;
    int uberPremierDistancePerKM = 17;
    int uberXLDistancePerKM = 20;
    int uberGoDurationPerMinute = 1;
    int uberGoSedanDurationPerMinute = 2;
    double uberPremierDurationPerMinute = 2.5;
    int uberXLDurationPerMinute = 3;

    uberGoFare =
        (baseFare +
                uberGoDistancePerKM *
                    (directionDetails!.distanceInMeter / 1000) +
                (uberGoDurationPerMinute * (directionDetails!.duration / 60)))
            .round();
    uberGoSedanFare =
        (baseFare +
                uberGoSedanDistancePerKM *
                    (directionDetails!.distanceInMeter / 1000) +
                (uberGoSedanDurationPerMinute *
                    (directionDetails!.duration / 60)))
            .round();
    uberPremierFare =
        (baseFare +
                uberPremierDistancePerKM *
                    (directionDetails!.distanceInMeter / 1000) +
                (uberPremierDurationPerMinute *
                    (directionDetails!.duration / 60)))
            .round();
    uberXLFare =
        (baseFare +
                uberXLDistancePerKM *
                    (directionDetails!.distanceInMeter / 1000) +
                (uberXLDurationPerMinute * (directionDetails!.duration / 60)))
            .round();
    notifyListeners();
  }

  updateRidePickupAndDropLocation(
    PickupNDropLocationModel pickup,
    PickupNDropLocationModel drop,
  ) {
    pickupLocation = pickup;
    dropLocation = drop;
    notifyListeners();
    log('Pickup and Drop location is');
    log(pickupLocation!.toMap().toString());
    log(dropLocation!.toMap().toString());
  }

  updateUpdateMarkerBool(bool newStatus) {
    updateMarkerbool = newStatus;
    notifyListeners();
  }

  updateDirection(DirectionModel newDirection) {
    directionDetails = newDirection;
    notifyListeners();
  }

  decodePolylineAndUpdatePolylineField() {
    PolylinePoints polylinePoints = PolylinePoints();
    polylineCoordinatesList.clear();
    polylineSet.clear();
    List<PointLatLng> data = polylinePoints.decodePolyline(
      directionDetails!.polylinePoints,
    );
    if (data.isNotEmpty) {
      for (var latlngPoints in data) {
        polylineCoordinatesList.add(
          LatLng(latlngPoints.latitude, latlngPoints.longitude),
        );
      }
    }
    polyline = Polyline(
      polylineId: const PolylineId('Trip Polyline'),
      color: Colors.black,
      points: polylineCoordinatesList,
      jointType: JointType.round,
      width: 3,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );
    polylineSet.add(polyline!);
    notifyListeners();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!.buffer.asUint8List();
  }

  createIcons(BuildContext context) async {
    if (pickupIconForMap == null) {
      // ImageConfiguration imageConfiguration = createLocalImageConfiguration(
      //   context,
      //   size: const Size(32, 32),
      // );
      // BitmapDescriptor.asset(
      //   imageConfiguration,
      //   'assets/images/icons/pickupPng.png',
      // ).then((icon) {
      //   pickupIconForMap = icon;
      //   notifyListeners();
      // });
      final Uint8List markerIcon = await getBytesFromAsset(
        'assets/images/icons/pickupPng.png',
        30,
      );

      pickupIconForMap = BitmapDescriptor.bytes(markerIcon);
      notifyListeners();
    }
    if (destinationIconForMap == null) {
      // ImageConfiguration imageConfiguration = createLocalImageConfiguration(
      //   context,
      //   size: const Size(48, 48),
      // );
      // BitmapDescriptor.asset(
      //   imageConfiguration,
      //   'assets/images/icons/dropPng.png',
      // ).then((icon) {
      //   destinationIconForMap = icon;
      //   notifyListeners();
      // });
      final Uint8List markerIcon = await getBytesFromAsset(
        'assets/images/icons/dropPng.png',
        35,
      );

      destinationIconForMap = BitmapDescriptor.bytes(markerIcon);
      notifyListeners();
    }
    if (carIconForMap == null) {
      // ImageConfiguration imageConfiguration = createLocalImageConfiguration(
      //   context,
      //   size: const Size(2, 2),
      // );
      // BitmapDescriptor.asset(
      //   imageConfiguration,
      //   'assets/images/vehicle/mapCar.png',
      // ).then((icon) {
      //   carIconForMap = icon;
      //   notifyListeners();
      // });
      final Uint8List markerIcon = await getBytesFromAsset(
        'assets/images/vehicle/mapCar.png',
        35,
      );

      carIconForMap = BitmapDescriptor.bytes(markerIcon);
      notifyListeners();
    }
  }

  updateMarker() async {
    if (pickupIconForMap == null || destinationIconForMap == null) {
      print("Icons not ready yet");
      return;
    }
    riderMarker.clear();
    Marker pickupMarker = Marker(
      markerId: const MarkerId('Pickup Marker'),
      position: LatLng(pickupLocation!.latitude!, pickupLocation!.longitude!),
      icon: pickupIconForMap!,
      anchor: Offset(0.5, 1.0),
    );
    Marker destinationMarker = Marker(
      markerId: const MarkerId('Destination Marker'),
      position: LatLng(dropLocation!.latitude!, dropLocation!.longitude!),
      icon: destinationIconForMap!,
      anchor: Offset(0.5, 1.0),
    );
    if (updateMarkerbool == true) {
      Marker carMarker = Marker(
        markerId: const MarkerId('Car Marker'),
        position: LatLng(pickupLocation!.latitude!, pickupLocation!.longitude!),
        icon: carIconForMap!,
      );
      riderMarker.add(carMarker);
    }
    riderMarker.add(pickupMarker);
    riderMarker.add(destinationMarker);
    notifyListeners();
    if (updateMarkerbool == true) {
      await Future.delayed(const Duration(seconds: 5), () async {
        await updateMarker();
      });
    }
  }
}
