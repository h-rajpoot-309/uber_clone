import 'package:flutter/material.dart';
import 'package:uber_clone/common/controller/services/mobileAuthServices.dart';

import '../../../constant/constants.dart';

class SignInLogic extends StatefulWidget {
  const SignInLogic({super.key});

  @override
  State<SignInLogic> createState() => _SignInLogicState();
}

class _SignInLogicState extends State<SignInLogic> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MobileAuthServices.checkAuthenticationAndNavigate(context: context);
      //testDB();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image(image: AssetImage('assets/images/uberLogo/uber.png')),
      ),
    );
  }
}
