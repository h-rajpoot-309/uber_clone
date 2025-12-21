import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:uber_clone/common/widgets/elevatedButtonCommon.dart';
import 'package:uber_clone/constant/utils/colors.dart';
import 'package:uber_clone/constant/utils/textStyles.dart';
import 'package:uber_clone/rider/controller/provider/tripProvider/rideRequestProvider.dart';

import '../../../common/controller/services/locationServices.dart';

class BookARideScreen extends StatefulWidget {
  const BookARideScreen({super.key});

  @override
  State<BookARideScreen> createState() => _BookARideScreenState();
}

class _BookARideScreenState extends State<BookARideScreen> {
  Completer<GoogleMapController> mapControllerDriver = Completer();
  GoogleMapController? mapController;
  int selectedCarType = 0;
  bool bookRideButtonPressed = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  int getFare(int index) {
    if (index == 0) {
      return context.read<RideRequestProvider>().uberGoFare;
    }
    if (index == 1) {
      return context.read<RideRequestProvider>().uberGoSedanFare;
    }
    if (index == 2) {
      return context.read<RideRequestProvider>().uberPremierFare;
    }
    if (index == 3) {
      return context.read<RideRequestProvider>().uberXLFare;
    }
    return 0;
  }

  getCarType(int carType) {
    switch (carType) {
      case 0:
        return 'Uber Go';
      case 1:
        return 'Uber Go Sedan';
      case 2:
        return 'Uber Premier';
      case 3:
        return 'Uber XL';
      default:
        return 'Uber Go';
    }
  }

  List ridesList = [
    ['assets/images/vehicle/uberGo.png', 'Uber Go', '4'],
    ['assets/images/vehicle/uberGoSedan.png', 'Uber Go Sedan', '4'],
    ['assets/images/vehicle/uberPremier.png', 'Uber Premier', '4'],
    ['assets/images/vehicle/uberXL.png', 'Uber XL', '6'],
  ];

  final panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        controller: panelController,
        panelBuilder: (context) {
          return Consumer<RideRequestProvider>(
            builder: (context, rideRequestProvider, child) {
              if ((rideRequestProvider.uberGoFare == 0) &&
                  (rideRequestProvider.uberGoSedanFare == 0) &&
                  (rideRequestProvider.uberPremierFare == 0) &&
                  (rideRequestProvider.uberXLFare == 0)) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              } else {
                return ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 1.h,
                          width: 20.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.sp),
                            color: greyShade3,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    ListView.builder(
                      itemCount: ridesList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedCarType = index;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 0.5.h),
                            padding: EdgeInsets.symmetric(
                              vertical: 1.h,
                              horizontal: 3.w,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.sp),
                              border: Border.all(
                                color: index == selectedCarType
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 8.h,
                                  width: 8.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.sp),
                                    border: Border.all(color: Colors.black38),
                                    color: Colors.white,
                                    image: DecorationImage(
                                      image: AssetImage(ridesList[index][0]),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        getCarType(index),
                                        style: AppTextStyles.body14Bold,
                                      ),
                                      SizedBox(width: 2.w),
                                      Icon(Icons.person, color: Colors.black),
                                      Text(ridesList[index][2]),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Rs. ${getFare(index).toString()}',
                                      style: AppTextStyles.body14Bold,
                                    ),
                                    Text(
                                      (getFare(index) * 1.15)
                                          .round()
                                          .toString(),
                                      style: AppTextStyles.small12.copyWith(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 1.h),
                    ElevatedButtonCommon(
                      width: 94.w,
                      height: 6.h,
                      onPressed: () {},
                      backgroundColor: Colors.black,
                      child: Builder(
                        builder: (context) {
                          if (bookRideButtonPressed == true) {
                            return CircularProgressIndicator(
                              color: Colors.white,
                            );
                          } else {
                            return Text(
                              'Continue',
                              style: AppTextStyles.body16Bold.copyWith(
                                color: Colors.white,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          );
        },
        body: Consumer<RideRequestProvider>(
          builder: (context, rideRequestProvider, child) {
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition:
                      rideRequestProvider.initialCameraPosition,
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  polylines: rideRequestProvider.polylineSet,
                  markers: rideRequestProvider.riderMarker,
                  onMapCreated: (GoogleMapController controller) async {
                    if (!mapControllerDriver.isCompleted) {
                      mapControllerDriver.complete(controller);
                    }
                    mapController = controller;
                    LatLng pickupLocation = LatLng(
                      rideRequestProvider.pickupLocation!.latitude!,
                      rideRequestProvider.pickupLocation!.longitude!,
                    );
                    CameraPosition cameraPosition = CameraPosition(
                      target: pickupLocation,
                      zoom: 14,
                    );
                    mapController!.animateCamera(
                      CameraUpdate.newCameraPosition(cameraPosition),
                    );
                  },
                ),
                //Back Button
                Positioned(
                  top: 4.h,
                  left: 5.w,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 5.h,
                      width: 5.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 4.h,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
