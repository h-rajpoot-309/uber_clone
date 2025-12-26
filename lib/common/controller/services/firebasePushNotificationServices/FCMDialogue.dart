import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:sizer/sizer.dart';
import 'package:uber_clone/common/model/rideRequestModel.dart';
import 'package:uber_clone/constant/constants.dart';
import 'package:uber_clone/constant/utils/textStyles.dart';
import 'package:uber_clone/driver/controller/services/rideRequestServices.dart';
import 'package:uber_clone/main.dart';

import '../../../../constant/utils/colors.dart';

class PushNotificationDialogue {
  static rideRequestDialogue(
    RideRequestModel rideRequestModel,
    BuildContext context,
  ) {
    final ctx = navigatorKey.currentContext!;
    return showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (context) {
        audioPlayer.setAsset('assets/sounds/alert.mp3');
        audioPlayer.play();
        RideRequestServicesDriver.checkRideAavailability(
          context,
          rideRequestModel.riderProfile.mobileNumber!,
        );
        return AlertDialog(
          content: SizedBox(
            height: 50.h,
            width: 90.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // for car image
                Builder(
                  builder: (context) {
                    if (rideRequestModel.carType == 'Uber Go') {
                      return Image(
                        image: const AssetImage(
                          'assets/images/vehicle/uberGo.png',
                        ),
                        height: 5.h,
                      );
                    } else if (rideRequestModel.carType == 'Uber Go Sedan') {
                      return Image(
                        image: const AssetImage(
                          'assets/images/vehicle/uberGoSedan.png',
                        ),
                        height: 5.h,
                      );
                    } else if (rideRequestModel.carType == 'Uber Premier') {
                      return Image(
                        image: const AssetImage(
                          'assets/images/vehicle/uberPremier.png',
                        ),
                        height: 5.h,
                      );
                    } else {
                      return Image(
                        image: const AssetImage(
                          'assets/images/vehicle/uberXL.png',
                        ),
                        height: 5.h,
                      );
                    }
                  },
                ),
                SizedBox(height: 3.w),
                // title
                Text('Ride Request', style: AppTextStyles.body18Bold),
                SizedBox(height: 4.h),
                // pickup location icon and name
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 4.h,
                      child: const Image(
                        image: AssetImage('assets/images/icons/pickupPng.png'),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: Text(
                        rideRequestModel.pickupLocation.name!,
                        maxLines: 2,
                        style: AppTextStyles.body16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                // drop location icon and name
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 4.h,
                      child: const Image(
                        image: AssetImage('assets/images/icons/dropPng.png'),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: Text(
                        rideRequestModel.dropLocation.name!,
                        maxLines: 2,
                        style: AppTextStyles.body16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                // Swipe Buttons for accepting and denying a ride request
                SwipeButton(
                  thumbPadding: EdgeInsets.all(1.w),
                  thumb: Icon(Icons.chevron_right, color: Colors.white),
                  inactiveThumbColor: success,
                  activeThumbColor: success,
                  inactiveTrackColor: greyShade3,
                  activeTrackColor: greyShade3,
                  elevationThumb: 2,
                  elevationTrack: 2,
                  onSwipe: () {},
                  child: Builder(
                    builder: (context) {
                      return Text('Accept', style: AppTextStyles.body16Bold);
                    },
                  ),
                ),
                SizedBox(height: 2.h),
                SwipeButton(
                  thumbPadding: EdgeInsets.all(1.w),
                  thumb: Icon(Icons.chevron_right, color: Colors.white),
                  inactiveThumbColor: Colors.red,
                  activeThumbColor: Colors.red,
                  inactiveTrackColor: greyShade3,
                  activeTrackColor: greyShade3,
                  elevationThumb: 2,
                  elevationTrack: 2,
                  onSwipe: () {
                    audioPlayer.stop();
                    Navigator.pop(context);
                  },
                  child: Builder(
                    builder: (context) {
                      return Text('Deny', style: AppTextStyles.body16Bold);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
