import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone/driver/view/homeScreenDriver/driverHomeScreen.dart';
import 'package:uber_clone/driver/view/homeScreenDriver/tripScreen.dart';

import '../../../common/model/profileDataModel.dart';
import '../../../constant/constants.dart';

class _HomeScreenBuilderState extends State<HomeScreenBuilder> {
  DatabaseReference driverProfileRef = FirebaseDatabase.instance.ref().child(
    'User/${auth.currentUser!.phoneNumber!}',
  );
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: driverProfileRef.onValue,
      builder: (context, event) {
        if (event.connectionState == ConnectionState.waiting) {
          return HomeScreenDriver();
        }
        //log(event.data!.snapshot.value.toString());
        if (event.data != null) {
          ProfileDataModel profileData = ProfileDataModel.fromMap(
            jsonDecode(jsonEncode(event.data!.snapshot.value))
                as Map<String, dynamic>,
          );
          //log(profileData.toMap().toString());
          // log(
          //   'HomeScreenBuilder: activeRideRequestID = ${profileData.activeRideRequestID}',
          // );
          if (profileData.activeRideRequestID != null) {
            return const TripScreen();
          } else {
            return const HomeScreenDriver();
          }
        } else {
          return const HomeScreenDriver();
        }
      },
    );
  }
}

class HomeScreenBuilder extends StatefulWidget {
  const HomeScreenBuilder({super.key});

  @override
  State<HomeScreenBuilder> createState() => _HomeScreenBuilderState();
}
