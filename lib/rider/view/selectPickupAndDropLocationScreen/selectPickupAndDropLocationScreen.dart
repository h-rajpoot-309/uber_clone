import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:uber_clone/common/controller/provider/locationProvider.dart';
import 'package:uber_clone/common/controller/services/directionServices.dart';
import 'package:uber_clone/common/controller/services/locationServices.dart';
import 'package:uber_clone/common/model/pickupNDropLocationModel.dart';
import 'package:uber_clone/common/model/searchAddressModel.dart';
import 'package:uber_clone/constant/utils/colors.dart';
import 'package:uber_clone/rider/controller/provider/tripProvider/rideRequestProvider.dart';
import 'package:uber_clone/rider/view/bookARideScreen/bookARideScreen.dart';
import '../../../constant/utils/textStyles.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickupAndDropLocationScreen extends StatefulWidget {
  const PickupAndDropLocationScreen({super.key});

  @override
  State<PickupAndDropLocationScreen> createState() =>
      _PickupAndDropLocationScreenState();
}

class _PickupAndDropLocationScreenState
    extends State<PickupAndDropLocationScreen> {
  TextEditingController pickupLocationController = TextEditingController();
  TextEditingController dropLocationController = TextEditingController();
  String locationType = 'DROP';

  getCurrentAddress() async {
    LatLng currentLocation = await LocationServices.getCurrentLocation();
    print(currentLocation);
    PickupNDropLocationModel currentLocationAddress =
        await LocationServices.getAddressFromLatLng(
          position: currentLocation,
          context: context,
        );
    log(currentLocationAddress.toMap().toString());
    pickupLocationController.text = currentLocationAddress.name!;
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentAddress();
      context.read<RideRequestProvider>().createIcons(context);
    });
  }

  navigateToBookRideScreen() async {
    if (context.read<LocationProvider>().pickupLocation != null &&
        context.read<LocationProvider>().dropLocation != null) {
      PickupNDropLocationModel pickup = context
          .read<LocationProvider>()
          .pickupLocation!;
      PickupNDropLocationModel drop = context
          .read<LocationProvider>()
          .dropLocation!;
      context.read<RideRequestProvider>().updateRidePickupAndDropLocation(
        pickup,
        drop,
      );
      LatLng pickupLocation = LatLng(pickup.latitude!, pickup.longitude!);
      LatLng dropLocation = LatLng(drop.latitude!, drop.longitude!);
      await DirectionServices.getDirectionDetails(
        pickupLocation,
        dropLocation,
        context,
      );
      context.read<RideRequestProvider>().makeFareZero();
      await context.read<RideRequestProvider>().createIcons(context);
      context.read<RideRequestProvider>().updateMarker();
      context.read<RideRequestProvider>().getFare();
      context
          .read<RideRequestProvider>()
          .decodePolylineAndUpdatePolylineField();
      Navigator.push(
        context,
        PageTransition(
          child: const BookARideScreen(),
          type: PageTransitionType.rightToLeft,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(100.w, 22.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            //Column containing Back button and location form fields
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Back Button
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back, size: 4.h, color: Colors.black),
                ),
                //Pickup and Drop Location Form Fields
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //circle and square icons on left
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: Column(
                          children: [
                            Icon(Icons.circle, size: 2.h, color: Colors.black),
                            Expanded(
                              child: Container(
                                width: 1.w,
                                color: Colors.black,
                                padding: EdgeInsets.symmetric(vertical: 0.5.h),
                              ),
                            ),
                            Icon(Icons.square, size: 2.h, color: Colors.black),
                          ],
                        ),
                      ),
                      SizedBox(width: 3.w),
                      //Actual Pickup and Drop Location Form Fields
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Select Pickup Location
                            TextFormField(
                              controller: pickupLocationController,
                              cursorColor: Colors.black87,
                              style: AppTextStyles.textFieldTextStyle,
                              keyboardType: TextInputType.name,
                              onChanged: (value) {
                                setState(() {
                                  locationType = 'PICKUP';
                                });
                                LocationServices.getSearchedAddress(
                                  placeName: value,
                                  context: context,
                                );
                              },
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () {
                                    context
                                        .read<LocationProvider>()
                                        .nullifyPickupLocation();
                                    pickupLocationController.clear();
                                  },
                                  child: Icon(
                                    CupertinoIcons.xmark,
                                    color: Colors.black38,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 2.w,
                                ),
                                hintText: 'Pickup Address',
                                hintStyle: AppTextStyles.textFieldHintTextStyle,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.sp),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.sp),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.sp),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.sp),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                            ),
                            // SizedBox(height: 1.h),
                            //Select Drop Location
                            TextFormField(
                              controller: dropLocationController,
                              cursorColor: Colors.black87,
                              style: AppTextStyles.textFieldTextStyle,
                              keyboardType: TextInputType.name,
                              onChanged: (value) {
                                setState(() {
                                  locationType = 'DROP';
                                });
                                LocationServices.getSearchedAddress(
                                  placeName: value,
                                  context: context,
                                );
                              },
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () {
                                    context
                                        .read<LocationProvider>()
                                        .nullifyDropLocation();
                                    dropLocationController.clear();
                                  },
                                  child: Icon(
                                    CupertinoIcons.xmark,
                                    color: Colors.black38,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 2.w,
                                ),
                                hintText: 'Drop Adress',
                                hintStyle: AppTextStyles.textFieldHintTextStyle,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.sp),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.sp),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.sp),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.sp),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Consumer<LocationProvider>(
          builder: (context, locationProvider, child) {
            print(locationProvider.searchedAddress);
            if (locationProvider.searchedAddress.isEmpty) {
              return Center(
                child: Text('SearchAddress', style: AppTextStyles.small12),
              );
            } else {
              return ListView.builder(
                itemCount: locationProvider.searchedAddress.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  SearchedAddressModel currentAddress =
                      locationProvider.searchedAddress[index];
                  return ListTile(
                    onTap: () async {
                      log(currentAddress.toMap().toString());
                      if (locationType == 'DROP') {
                        dropLocationController.text = currentAddress.mainName;
                      } else {
                        pickupLocationController.text = currentAddress.mainName;
                      }
                      await LocationServices.getLatLngFromPlaceID(
                        currentAddress,
                        context,
                        locationType,
                      );
                      navigateToBookRideScreen();
                    },
                    leading: CircleAvatar(
                      backgroundColor: greyShade3,
                      radius: 3.h,
                      child: Icon(Icons.location_on, color: Colors.black),
                    ),
                    title: Text(
                      currentAddress.mainName,
                      style: AppTextStyles.small12Bold,
                    ),
                    subtitle: Text(
                      currentAddress.secondaryName,
                      style: AppTextStyles.small10.copyWith(color: Colors.grey),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
