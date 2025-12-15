import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone/common/model/pickupNDropLocationModel.dart';

import '../../../../common/model/directionModel.dart';

class RideRequestProvider extends ChangeNotifier {
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

  createIcons(BuildContext context) {
    if (pickupIconForMap == null) {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(
        context,
        size: const Size(2, 2),
      );
      BitmapDescriptor.fromAssetImage(
        imageConfiguration,
        'assets/images/icons/pickupPng.png',
      ).then((icon) {
        pickupIconForMap = icon;
        notifyListeners();
      });
    }
    if (destinationIconForMap == null) {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(
        context,
        size: const Size(2, 2),
      );
      BitmapDescriptor.fromAssetImage(
        imageConfiguration,
        'assets/images/icons/dropPng.png',
      ).then((icon) {
        destinationIconForMap = icon;
        notifyListeners();
      });
    }
    if (carIconForMap == null) {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(
        context,
        size: const Size(2, 2),
      );
      BitmapDescriptor.fromAssetImage(
        imageConfiguration,
        'assets/images/vehicle/mapCar.png',
      ).then((icon) {
        carIconForMap = icon;
        notifyListeners();
      });
    }
  }
}
