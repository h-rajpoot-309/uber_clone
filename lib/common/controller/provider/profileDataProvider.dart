import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:uber_clone/common/controller/services/profileDataCRUDServices.dart';
import 'package:uber_clone/common/model/profileDataModel.dart';
import 'package:uber_clone/constant/constants.dart';

class ProfileDataProvider extends ChangeNotifier {
  ProfileDataModel? profileData;

  getProfileData() async {
    profileData =
        await ProfileDataCRUDServices.getProfileDataFromRealTimeDatabase(
          auth.currentUser!.phoneNumber!,
        );
    log(profileData!.toMap().toString());

    notifyListeners();
  }
}
