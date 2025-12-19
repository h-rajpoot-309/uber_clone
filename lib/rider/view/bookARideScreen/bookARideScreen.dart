import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:uber_clone/constant/utils/colors.dart';
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
                        SizedBox(height: 2.h),
                        ListView.builder(
                          itemCount: ridesList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              child: Row(
                                children: [
                                  Container(
                                    height: 6.h,
                                    width: 6.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.sp),
                                      border: Border.all(color: Colors.black38),
                                      color: Colors.white,
                                      image: DecorationImage(
                                        image: AssetImage(ridesList[0]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
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
