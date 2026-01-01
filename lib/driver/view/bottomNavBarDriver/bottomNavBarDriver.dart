import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sizer/sizer.dart';
import 'package:uber_clone/constant/utils/colors.dart';
import 'package:uber_clone/driver/view/accountScreenDriver/accountScreenDriver.dart';
import 'package:uber_clone/driver/view/activityScreenDriver/activityScreenDriver.dart';
import 'package:uber_clone/driver/view/homeScreenDriver/driverHomeScreen.dart';
import 'package:uber_clone/driver/view/homeScreenDriver/driverHomeScreenBuilder.dart';
import 'package:uber_clone/rider/view/account/accountScreenRider.dart';
import 'package:uber_clone/rider/view/activity/activityScreen.dart';
import 'package:uber_clone/rider/view/homeScreen/riderHomeScreen.dart';
import 'package:uber_clone/rider/view/serviceScreen/serviceScreen.dart';

import '../../../common/controller/services/firebasePushNotificationServices/pushNotificationServices.dart';
import '../../../common/controller/services/profileDataCRUDServices.dart';
import '../../../common/model/profileDataModel.dart';
import '../../../constant/constants.dart';

class BottomNavBarDriver extends StatefulWidget {
  const BottomNavBarDriver({super.key});

  @override
  State<BottomNavBarDriver> createState() => _BottomNavBarDriverState();
}

class _BottomNavBarDriverState extends State<BottomNavBarDriver> {
  late PersistentTabController _controller;

  void initState() {
    super.initState();
    // Initialize with the first tab (index 0)
    _controller = PersistentTabController(initialIndex: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ProfileDataModel profileData =
          await ProfileDataCRUDServices.getProfileDataFromRealTimeDatabase(
            auth.currentUser!.phoneNumber!,
          );
      PushNotificationServices.initializeFirebaseMessagingForUsers(
        profileData,
        context,
      );
    });
  }

  //list of screens
  List<Widget> screens = [
    HomeScreenBuilder(),
    ActivityScreenDriver(),
    AccountScreenDriver(),
  ];
  final List<PersistentTabConfig> tabs = [
    PersistentTabConfig(
      screen: const HomeScreenBuilder(),
      item: ItemConfig(
        icon: const Icon(Icons.home),
        title: "Home",
        activeColorSecondary: Colors.black,
      ),
    ),
    PersistentTabConfig(
      screen: const ActivityScreenDriver(),
      item: ItemConfig(
        icon: const Icon(Icons.history),
        title: "Activity",
        activeColorSecondary: Colors.black,
      ),
    ),
    PersistentTabConfig(
      screen: const AccountScreenDriver(),
      item: ItemConfig(
        icon: const Icon(Icons.person),
        title: "Account",
        activeColorSecondary: Colors.black,
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      tabs: tabs,
      navBarBuilder: (NavBarConfig) => Style6BottomNavBar(
        navBarConfig: NavBarConfig,
        navBarDecoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(12.sp),
          color: white,
        ),
      ),
    );
  }
}
