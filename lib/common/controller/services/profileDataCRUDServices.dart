import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone/common/controller/services/toastService.dart';
import 'package:uber_clone/common/model/profileDataModel.dart';
import 'package:uber_clone/constant/constants.dart';
import 'package:uber_clone/constant/utils/colors.dart';
import 'package:page_transition/page_transition.dart';
import '../../view/SignInLogic/signInLogic.dart';

class ProfileDataCRUDServices {
  static getProfileDataFromRealTimeDatabase(String userID) async {
    try {
      final snapshot = await realTimeDatabaseRef.child('User/$userID').get();
      if (snapshot.exists) {
        ProfileDataModel userModel = ProfileDataModel.fromMap(
          jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>,
        );
        log('profile data crud: ${userModel.toMap().toString()}');
        return userModel;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<bool> checkForRegisteredUser(BuildContext context) async {
    try {
      print("Firebase app name: ${Firebase.app().name}");
      print(
        "Firebase databaseURL (configured): ${Firebase.app().options.databaseURL}",
      );
    } catch (e) {
      print('Could not read Firebase.app() info: $e');
    }
    try {
      print('arrived in check reg user');
      print("Current user: ${auth.currentUser}");
      print("Phone number: ${auth.currentUser?.phoneNumber}");
      print(realTimeDatabaseRef);
      final snapshot = await realTimeDatabaseRef
          .child('User/${auth.currentUser!.phoneNumber}')
          .get();
      // .timeout(
      //   const Duration(seconds: 10),
      //   onTimeout: () async {
      //     // print("Firebase request timed out");
      //     // return await realTimeDatabaseRef.child("_timeout_empty").get();
      //     throw Exception("Firebase request timed out");
      //     // snapshot will be null
      //   },
      // );
      print('snapshot: ${snapshot.value}');
      if (snapshot != null && snapshot.exists) {
        return true;
      }

      log('User Data not found');
      return false;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> registerUserToDatabase({
    required ProfileDataModel profileData,
    required BuildContext context,
  }) async {
    try {
      await realTimeDatabaseRef
          .child('User/${auth.currentUser!.phoneNumber}')
          .set(profileData.toMap());

      ToastService.sendScaffoldAlert(
        msg: 'User Registration Successful',
        toastStatus: 'SUCCESS',
        context: context,
      );
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          child: const SignInLogic(),
          type: PageTransitionType.rightToLeft,
        ),
        (route) => false,
      );
    } catch (e) {
      ToastService.sendScaffoldAlert(
        msg: 'Oops! Error getting Registered',
        toastStatus: 'ERROR',
        context: context,
      );
      // throw Exception(e);
    }
  }

  static Future<bool> userIsDriver(BuildContext context) async {
    try {
      DataSnapshot snapshot = await realTimeDatabaseRef
          .child('User/${auth.currentUser!.phoneNumber}')
          .get();

      if (snapshot.exists) {
        ProfileDataModel userModel = ProfileDataModel.fromMap(
          jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>,
        );

        log('User Type is ${userModel.userType}');
        if (userModel.userType != 'CUSTOMER') {
          return true;
        }
      }
    } catch (e) {
      throw Exception(e);
    }
    return false;
  }
}
