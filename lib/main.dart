import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:uber_clone/common/controller/provider/authProvide.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uber_clone/common/controller/provider/locationProvider.dart';
import 'package:uber_clone/common/controller/provider/profileDataProvider.dart';
import 'package:uber_clone/common/view/SignInLogic/signInLogic.dart';
import 'package:uber_clone/driver/controller/providers/mapsProviderDriver.dart';
import 'package:uber_clone/driver/view/bottomNavBarDriver/bottomNavBarDriver.dart';
import 'package:uber_clone/rider/controller/provider/bottomNavBarRiderProvider/bottomNavBarRiderProvider.dart';
import 'package:uber_clone/rider/controller/provider/tripProvider/rideRequestProvider.dart';
import 'driver/controller/providers/bottomNavBarDriverProvider.dart';
import 'firebase_options.dart';
import 'package:uber_clone/common/view/authScreens/loginScreen.dart';
import 'package:uber_clone/common/view/authScreens/otpScreen.dart';
import 'package:uber_clone/common/view/registrationScreen/registrationScreen.dart';
import 'package:uber_clone/rider/view/bottomNavBar/bottomNavBarRider.dart';
import 'package:uber_clone/rider/view/homeScreen/riderHomeScreen.dart';
import 'package:uber_clone/rider/view/serviceScreen/serviceScreen.dart';
import 'package:uber_clone/rider/view/account/accountScreenRider.dart';
import 'package:uber_clone/rider/view/activity/activityScreen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // try {
  //   // Prevent duplicate initialization
  //   print(Firebase.apps);
  //   if (Firebase.apps.isEmpty) {
  //     await Firebase.initializeApp(
  //       options: DefaultFirebaseOptions.currentPlatform,
  //     );
  //   } else {
  //     Firebase.app(); // use existing app
  //   }
  // } catch (e) {
  //   print("FIREBASE INIT ERROR: $e");
  // }
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("FIREBASE INIT ERROR: $e");
  }
  runApp(const Uber());
}

class Uber extends StatefulWidget {
  const Uber({super.key});

  @override
  State<Uber> createState() => _UberState();
}

class _UberState extends State<Uber> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<MobileAuthProvider>(
              create: (_) => MobileAuthProvider(),
            ),
            ChangeNotifierProvider<LocationProvider>(
              create: (_) => LocationProvider(),
            ),
            ChangeNotifierProvider<ProfileDataProvider>(
              create: (_) => ProfileDataProvider(),
            ),
            // Driver Providers
            ChangeNotifierProvider<BottomNavBarDriverProvider>(
              create: (_) => BottomNavBarDriverProvider(),
            ),
            ChangeNotifierProvider<MapsProviderDriver>(
              create: (_) => MapsProviderDriver(),
            ),
            // Rider Providers
            ChangeNotifierProvider<BottomNavBarRiderProvider>(
              create: (_) => BottomNavBarRiderProvider(),
            ),
            ChangeNotifierProvider<RideRequestProvider>(
              create: (_) => RideRequestProvider(),
            ),
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              appBarTheme: const AppBarTheme(color: Colors.white, elevation: 0),
            ),
            home: const SignInLogic(),
          ),
        );
      },
    );
  }
}
