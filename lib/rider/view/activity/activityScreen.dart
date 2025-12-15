import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:uber_clone/constant/utils/colors.dart';
import 'package:uber_clone/constant/utils/textStyles.dart';
import 'package:intl/intl.dart';

class ActivityScreenRider extends StatefulWidget {
  const ActivityScreenRider({super.key});

  @override
  State<ActivityScreenRider> createState() => _ActivityScreenRiderState();
}

class _ActivityScreenRiderState extends State<ActivityScreenRider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Uber', style: AppTextStyles.heading20Bold)),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 1.7.h),
        itemCount: 10,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 1.7.h),
            height: 11.4.h,
            width: 94.w,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: index == 9 ? transparent : greyShade3,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 0.5.h,
                    horizontal: 1.w,
                  ),
                  height: 8.h,
                  width: 8.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.sp),
                    color: greyShadeButton,
                    image: const DecorationImage(
                      image: AssetImage('assets/images/vehicle/car.png'),
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Stewart Road Quetta',
                        style: AppTextStyles.small12Bold,
                        maxLines: 2,
                      ),
                      Text(
                        DateFormat('dd MMM, kk:mm a').format(DateTime.now()),
                        style: AppTextStyles.small10.copyWith(
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '150:00',
                        style: AppTextStyles.small10.copyWith(
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
