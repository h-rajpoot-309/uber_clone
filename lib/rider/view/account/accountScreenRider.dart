// ignore: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:uber_clone/common/controller/provider/profileDataProvider.dart';
import 'package:uber_clone/constant/utils/colors.dart';
import 'package:uber_clone/constant/utils/textStyles.dart';

class AccountScreenRider extends StatefulWidget {
  const AccountScreenRider({super.key});

  @override
  State<AccountScreenRider> createState() => _AccountScreenRiderState();
}

class _AccountScreenRiderState extends State<AccountScreenRider> {
  List accountTopButtons = [
    [CupertinoIcons.shield_fill, 'Help'],
    [CupertinoIcons.creditcard_fill, 'Payment'],
    [CupertinoIcons.square_list_fill, 'Activity'],
  ];

  List accountButtons = [
    [CupertinoIcons.gift_fill, 'Send A gift'],
    [CupertinoIcons.gear_alt_fill, 'Settings'],
    [CupertinoIcons.envelope_fill, 'Messages'],
    [CupertinoIcons.money_dollar_circle_fill, 'Earn by driving and Delivering'],
    [CupertinoIcons.briefcase_fill, 'Business Hub'],
    [CupertinoIcons.person_2_fill, 'Refer Friends, Unlock Details'],
    [CupertinoIcons.person_fill, 'Manage Uber Account'],
    [CupertinoIcons.power, 'Logout'],
  ];

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<ProfileDataProvider>().getProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Top row Profile data
            ListView(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Consumer<ProfileDataProvider>(
                  builder: (context, profileProvider, child) {
                    if (profileProvider.profileData == null) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 70.w,
                            child: Text(
                              'User',
                              style: AppTextStyles.heading26Bold,
                            ),
                          ),
                          Container(
                            height: 16.w,
                            width: 16.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: black87),
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/uberLogo/uberLogoBlack.png',
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 70.w,
                            child: Text(
                              profileProvider.profileData!.name!,
                              style: AppTextStyles.heading26Bold,
                            ),
                          ),
                          Container(
                            height: 16.w,
                            width: 16.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: black87),
                              image: DecorationImage(
                                image: NetworkImage(
                                  profileProvider.profileData!.profilePicUrl!,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),

                //Top section with name and dp
                SizedBox(height: 3.h),
                // section with help/payment/activity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: accountTopButtons
                      .map(
                        (e) => Container(
                          height: 10.h,
                          width: 28.w,
                          decoration: BoxDecoration(
                            color: greyShade3,
                            borderRadius: BorderRadius.circular(8.sp),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(e[0], size: 4.h, color: black87),
                              Text(e[1], style: AppTextStyles.small10),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
            Divider(color: greyShade2, thickness: 0.5.h),
            SizedBox(height: 5.h),
            ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: accountButtons.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.fromLTRB(3.w, 1.h, 2.w, 1.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        accountButtons[index][0],
                        size: 2.h,
                        color: Colors.black87,
                      ),
                      SizedBox(width: 7.w),
                      Text(
                        accountButtons[index][1],
                        style: AppTextStyles.small12,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
