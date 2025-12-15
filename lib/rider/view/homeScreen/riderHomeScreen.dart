import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:uber_clone/constant/utils/colors.dart';
import 'package:uber_clone/constant/utils/textStyles.dart';
import 'package:uber_clone/rider/view/selectPickupAndDropLocationScreen/selectPickupAndDropLocationScreen.dart';

class RiderHomeScreen extends StatefulWidget {
  const RiderHomeScreen({super.key});

  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  List suggestions = [
    ['assets/images/suggestions/trip.png', 'Trip'],
    ['assets/images/suggestions/rentals.png', 'Rentals'],
    ['assets/images/suggestions/reserve.png', 'Reserve'],
    ['assets/images/suggestions/intercity.png', 'Intercity'],
  ];
  List moreWaysToUseUber = [
    [
      'assets/images/moreWaysUber/sendAPackage.png',
      'Send a Package',
      'On demand delivery across town',
    ],
    [
      'assets/images/moreWaysUber/premierTrips.png',
      'Premier Trips',
      'Top-rated Drivers, Newer Cars',
    ],
    [
      'assets/images/moreWaysUber/safetyToolKit.png',
      'Safety Toolkit',
      'On-trip with safety issues',
    ],
  ];
  List planYourNextTrip = [
    [
      'assets/images/planNextTrip/travelIntercity.png',
      'Travel Intercity',
      'Get to remote locations with ease',
    ],
    [
      'assets/images/planNextTrip/rentals.png',
      'Rentals',
      'Travel from 1 to 12 hours',
    ],
  ];
  List saveEveryDay = [
    [
      'assets/images/saveEveryDay/uberMotoTrips.png',
      'Uber Moto Trips',
      'Affordable Motorcycle Pick-ups',
    ],
    [
      'assets/images/saveEveryDay/tryAGroupTrip.png',
      'Try a group Trip',
      'Seamless trips, together',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('uber', style: AppTextStyles.heading20Bold)),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          //where to button search
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: const PickupAndDropLocationScreen(),
                  type: PageTransitionType.rightToLeft,
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.sp),
                color: Colors.grey[300],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.black87, size: 4.h),
                  SizedBox(width: 5.w),
                  Text('where to?', style: AppTextStyles.body14Bold),
                ],
              ),
            ),
          ),
          // Previous Trip Records
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 0.5.h),
                padding: EdgeInsets.symmetric(vertical: 0.5.h),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 3.h,
                      backgroundColor: greyShade3,
                      child: Icon(Icons.location_on, color: Colors.black),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Main Address', style: AppTextStyles.body14Bold),
                          Text(
                            'Main Address Description',
                            style: AppTextStyles.body14Bold.copyWith(
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: greyShade3,
                      size: 15.sp,
                    ),
                  ],
                ),
              );
            },
          ),
          //suggestions
          SizedBox(height: 4.h),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Suggestions', style: AppTextStyles.body14Bold),
                  Text(
                    'See All',
                    style: AppTextStyles.small10.copyWith(
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: suggestions
                    .map(
                      (e) => SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 15.w,
                              width: 20.w,
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.sp),
                                color: greyShadeButton,
                              ),
                              child: Image(image: AssetImage(e[0])),
                            ),
                            Text(
                              e[1],
                              style: AppTextStyles.small10Bold.copyWith(
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          //Promo Banner
          SizedBox(height: 2.h),
          const Image(image: AssetImage('assets/images/promotion/promo.png')),
          SizedBox(height: 4.h),

          ExploreFeaturesHorizontalListView(
            title: 'More ways to use Uber',
            list: moreWaysToUseUber,
          ),
          SizedBox(height: 1.h),
          ExploreFeaturesHorizontalListView(
            title: 'Plan your next trip',
            list: planYourNextTrip,
          ),
          SizedBox(height: 1.h),
          ExploreFeaturesHorizontalListView(
            title: 'Save Everyday',
            list: saveEveryDay,
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }
}

class ExploreFeaturesHorizontalListView extends StatelessWidget {
  const ExploreFeaturesHorizontalListView({
    super.key,
    required this.list,
    required this.title,
  });

  final List list;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //More Ways to use Uber
        Text(title, style: AppTextStyles.body14Bold),
        SizedBox(height: 1.h),
        SizedBox(
          height: 22.h,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(
                  left: index == 0 ? 0 : 0.5.w,
                  right: index == (list.length - 1) ? 0 : 0.5.w,
                ),
                width: 65.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 12.h,
                      width: 65.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.sp),
                        image: DecorationImage(
                          image: AssetImage(list[index][0]),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Text(list[index][1], style: AppTextStyles.small12Bold),
                        SizedBox(width: 3.w),
                        Icon(
                          Icons.arrow_forward,
                          size: 2.h,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      list[index][2],
                      style: AppTextStyles.small8.copyWith(
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
