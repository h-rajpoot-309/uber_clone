import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/common/controller/provider/authProvide.dart';
import 'package:uber_clone/common/controller/provider/profileDataProvider.dart';
import 'package:uber_clone/common/controller/services/profileDataCRUDServices.dart';
import 'package:uber_clone/common/view/SignInLogic/signInLogic.dart';
import 'package:uber_clone/common/view/authScreens/loginScreen.dart';
import 'package:uber_clone/common/view/authScreens/otpScreen.dart';
import 'package:uber_clone/common/view/registrationScreen/registrationScreen.dart';
import 'package:uber_clone/driver/view/bottomNavBarDriver/bottomNavBarDriver.dart';
import 'package:uber_clone/driver/view/homeScreenDriver/driverHomeScreen.dart';
import 'package:uber_clone/rider/view/bottomNavBar/bottomNavBarRider.dart';
import '../../../constant/constants.dart';

class MobileAuthServices {
  static recieveOTP({
    required BuildContext context,
    required String mobileNumber,
  }) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: mobileNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          log(credential.toString());
        },
        verificationFailed: (FirebaseAuthException exception) {
          log(exception.toString());
        },
        codeSent: (String verificationCode, int? resendToken) {
          context.read<MobileAuthProvider>().updateVerificationCode(
            verificationCode,
          );
          Navigator.push(
            context,
            PageTransition(
              child: const OTPScreen(),
              type: PageTransitionType.rightToLeft,
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationID) {},
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  static verifyOTP({required BuildContext context, required String otp}) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: context.read<MobileAuthProvider>().verificationCode!,
        smsCode: otp,
      );
      await auth.signInWithCredential(credential);
      Navigator.push(
        context,
        PageTransition(
          child: const SignInLogic(),
          type: PageTransitionType.rightToLeft,
        ),
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  static bool checkAuthentication() {
    User? user = auth.currentUser;
    print(user);
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  static checkAuthenticationAndNavigate({required BuildContext context}) async {
    print('check auth and nav start');
    bool userIsAuthenticated = checkAuthentication();
    print('User authentication: $userIsAuthenticated');
    userIsAuthenticated
        ? await checkUser(context)
        : Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.rightToLeft,
            ),
            (route) => false,
          );
    print('check auth and nav end');
  }

  static checkUser(BuildContext context) async {
    print('check user start');
    bool userIsRegistered =
        await ProfileDataCRUDServices.checkForRegisteredUser(context);
    print('user reg check start');
    // check if the user is registered, if it is then go to rider/driver screen else registration screen
    if (userIsRegistered == true) {
      bool userIsDriver = await ProfileDataCRUDServices.userIsDriver(context);
      // check if user is driver or rider and go to respective screen
      if (userIsDriver == true) {
        context.read<ProfileDataProvider>().getProfileData();
        // if user is driver go to driver screen
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            child: const BottomNavBarDriver(),
            type: PageTransitionType.rightToLeft,
          ),
          (route) => false,
        );
      } else {
        context.read<ProfileDataProvider>().getProfileData();
        // if user is rider go to rider screen
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            child: const BottomNavBarRider(),
            type: PageTransitionType.rightToLeft,
          ),
          (route) => false,
        );
      }
    } else {
      // if user is not registered go to registration screen
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          child: const RegistrationScreen(),
          type: PageTransitionType.rightToLeft,
        ),
        (route) => false,
      );
    }
    print('check user end');
  }
}
