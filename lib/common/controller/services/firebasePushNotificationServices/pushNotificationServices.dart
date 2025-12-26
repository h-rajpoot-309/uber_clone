import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:uber_clone/common/controller/services/firebasePushNotificationServices/FCMDialogue.dart';
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
      // if the driver app is closed
      FirebaseMessaging.onBackgroundMessage(
        firebaseMessagingBackgroundHandlerDriver,
      );
      // if the driver app is  open
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          log('Got a message whilst in the foreground!');
          log('Message data: ${message.data}');
          firebaseMessagingForegroundHandlerDriver(message, context);
        }
      });
    } else {
      // if the rider app is closed
      FirebaseMessaging.onBackgroundMessage(
        firebaseMessagingBackgroundHandlerRider,
      );
      // if the rider app is open
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
    BuildContext context,
  ) async {
    String rideID = getRideRequestID(message);
    fetchRideRequestInfo(rideID, context);
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
            log(
              'In fetch ride request info: ${rideRequestModel.toMap().toString()}',
            );
            //show a dialogue to accept ride request
            PushNotificationDialogue.rideRequestDialogue(
              rideRequestModel,
              context,
            );
          }
        })
        .onError((error, stackTrace) {
          throw Exception(error);
        });
  }

  static subscribeToNotification(ProfileDataModel model) {
    if (model.userType == 'PARTNER') {
      firebaseMessaging.subscribeToTopic('PARTNER');
      firebaseMessaging.subscribeToTopic('USER');
    } else {
      firebaseMessaging.subscribeToTopic('CUSTOMER');
      firebaseMessaging.subscribeToTopic('USER');
    }
  }

  static initializeFirebaseMessagingForUsers(
    ProfileDataModel model,
    BuildContext context,
  ) {
    log('In init Firebase Messaging');
    initializeFirebaseMessaging(model, context);
    getToken(model);
    subscribeToNotification(model);
  }
}
