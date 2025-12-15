import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/common/controller/services/locationServices.dart';
import 'package:uber_clone/constant/constants.dart';
import 'package:uber_clone/driver/controller/providers/locationProviderDriver.dart';

class GeoFireSerivice {
  static DatabaseReference databaseRef = FirebaseDatabase.instance.ref().child(
    'User/${auth.currentUser!.phoneNumber!}/driverStatus',
  );
  StreamSubscription<Position>? driverPositionStream;
  static goOnline() async {
    LatLng currentPosition = await LocationServices.getCurrentLocation();
    Geofire.initialize('OnlineDrivers');
    Geofire.setLocation(
      auth.currentUser!.phoneNumber!,
      currentPosition.latitude,
      currentPosition.longitude,
    );
    databaseRef.set('ONLINE');
    databaseRef.onValue.listen((event) {});
  }

  goOffline(BuildContext context) async {
    Geofire.removeLocation(auth.currentUser!.phoneNumber!);
    databaseRef.set('OFFLINE');
    await driverPositionStream?.cancel();
    driverPositionStream = null;

    databaseRef.onDisconnect().set('OFFLINE');
  }

  updateLocationRealTime(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 10,
    );

    driverPositionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (event) {
            context.read<LocationProviderDriver>().updateDriverPosition(event);
            Geofire.setLocation(
              auth.currentUser!.phoneNumber!,
              event.latitude,
              event.longitude,
            );
          },
        );
  }
}
