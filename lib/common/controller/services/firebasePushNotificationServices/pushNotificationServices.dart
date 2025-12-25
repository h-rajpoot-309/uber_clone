import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:uber_clone/common/model/profileDataModel.dart';
import 'package:uber_clone/common/model/rideRequestModel.dart';
import 'package:uber_clone/rider/view/homeScreen/riderHomeScreen.dart';

import '../../../../constant/constants.dart';

class PushNotificationServices {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static Future initializeFirebaseMessaging(
    ProfileDataModel profileData,
    BuildContext context,
  ) async {
    await firebaseMessaging.requestPermission();
    if (profileData.userType == 'PARTNER') {
      FirebaseMessaging.onBackgroundMessage(
        firebaseMessagingBackgroundHandlerDriver,
      );
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          firebaseMessagingForegroundHandlerDriver(message);
        }
      });
    } else {
      FirebaseMessaging.onBackgroundMessage(
        firebaseMessagingBackgroundHandlerRider,
      );
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          firebaseMessagingForegroundHandlerRider(message);
        }
      });
    }
  }

  static getRideRequestID(RemoteMessage message) {
    String rideID = message.data['rideRequestID'];
    log(rideID);
    return rideID;
  }

  // Rider Cloud Messaging Functions
  static Future<void> firebaseMessagingBackgroundHandlerRider(
    RemoteMessage message,
  ) async {}
  static Future<void> firebaseMessagingForegroundHandlerRider(
    RemoteMessage message,
  ) async {}

  // Driver Cloud Messaging Functions
  static Future<void> firebaseMessagingBackgroundHandlerDriver(
    RemoteMessage message,
  ) async {
    String rideID = getRideRequestID(message);
  }

  static Future<void> firebaseMessagingForegroundHandlerDriver(
    RemoteMessage message,
  ) async {
    String rideID = getRideRequestID(message);
  }

  static Future getToken(ProfileDataModel model) async {
    String? token = await firebaseMessaging.getToken();
    log('Cloud Messaging Token : ${token}');
    DatabaseReference tokenRef = FirebaseDatabase.instance.ref().child(
      'User/${auth.currentUser!.phoneNumber}/cloudMessagingToken',
    );
    tokenRef.set(token);
  }

  static fetchRideRequestInfo(String rideID, BuildContext context) {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child(
      'RideRequest/$rideID',
    );
    ref
        .once()
        .then((databaseEvent) {
          if (databaseEvent.snapshot.value != null) {
            RideRequestModel rideRequestModel = RideRequestModel.fromMap(
              jsonDecode(jsonEncode(databaseEvent.snapshot.value))
                  as Map<String, dynamic>,
            );
            log(rideRequestModel.toMap().toString());
            //show a dialogue to accept ride request
          }
        })
        .onError((error, stackTrace) {
          throw Exception(error);
        });
  }
}
