import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';
import 'package:uber_clone/common/controller/provider/authProvide.dart';
import 'package:uber_clone/constant/utils/textStyles.dart';
import 'package:provider/provider.dart';

import '../../../constant/utils/colors.dart';
import '../../controller/services/mobileAuthServices.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  int num = 60;
  TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  decreseNum() {
    if (num > 0) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          num = num - 1;
        });
        decreseNum();
      });
    }
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      decreseNum();
    });
  }

  void dispose() {
    super.dispose();
    otpController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Padding(
          padding: EdgeInsets.only(left: 6.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(6.w, 6.h),
                  backgroundColor: greyShade3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.sp),
                  ),
                ),
                child: Icon(Icons.arrow_back),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(6.w, 6.h),
                  backgroundColor: greyShade3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.sp),
                  ),
                ),
                child: Row(
                  children: [
                    Text('Continue', style: AppTextStyles.small12),
                    SizedBox(width: 2.w),
                    Icon(Icons.arrow_forward, color: Colors.black),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          children: [
            Text('Welcome', style: AppTextStyles.body18),
            SizedBox(height: 2.h),
            Text(
              'Enter the 6-digit code sent to you at ${context.read<MobileAuthProvider>().mobileNumber}',
              style: AppTextStyles.small10,
            ),
            SizedBox(height: 4.h),
            PinCodeTextField(
              appContext: context,
              length: 6,
              obscureText: false,
              animationType: AnimationType.fade,
              textStyle: AppTextStyles.body14,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5.sp),
                fieldHeight: 50,
                fieldWidth: 50,
                activeFillColor: white,
                inactiveColor: greyShade3,
                inactiveFillColor: greyShade3,
                selectedFillColor: white,
                selectedColor: black,
                activeColor: black,
              ),
              animationDuration: const Duration(milliseconds: 300),
              backgroundColor: transparent,
              enableActiveFill: true,
              errorAnimationController: errorController,
              controller: otpController,
              onCompleted: (value) {
                MobileAuthServices.verifyOTP(
                  context: context,
                  otp: otpController.text.trim(),
                );
              },
              onChanged: (value) {},
              beforeTextPaste: (text) {
                return true;
              },
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: greyShade3, // same as your InkWell background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.sp),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.5.h),
              ),
              onPressed: num > 0
                  ? null
                  : () {
                      // Button disabled when timer is running (num > 0)
                      // Add your "resend code" logic here when timer hits 0
                    },
              child: Text(
                num > 0
                    ? 'I did not receive a code (00:$num)'
                    : 'I did not receive the code',
                style: TextStyle(
                  color: num > 1 ? Colors.black38 : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
