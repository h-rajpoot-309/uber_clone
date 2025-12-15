import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:uber_clone/common/widgets/elevatedButtonCommon.dart';
import 'package:uber_clone/constant/utils/colors.dart';
import 'package:uber_clone/constant/utils/textStyles.dart';

import '../../../constant/constants.dart';
import '../../controller/services/ImageServices.dart';
import '../../controller/services/profileDataCRUDServices.dart';
import '../../controller/services/toastService.dart';
import '../../model/profileDataModel.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController vehicleModelNameController = TextEditingController();
  TextEditingController vehicleBrandNameController = TextEditingController();
  TextEditingController vehicleRegistrationNumberController =
      TextEditingController();
  TextEditingController drivingLicenseNumberController =
      TextEditingController();

  String selectedVehicleType = 'Select Vehicle Type';
  List<String> vehicleTypes = [
    'Select Vehicle Type',
    'Mini',
    'Sedan',
    'SUV',
    'Bike',
  ];
  String userType = 'Customer';
  File? profilePic;
  bool registerButtonPressed = false;

  @override
  void initState() {
    super.initState();
    mobileController.text = auth.currentUser!.phoneNumber!;
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    vehicleBrandNameController.dispose();
    vehicleModelNameController.dispose();
    vehicleRegistrationNumberController.dispose();
    drivingLicenseNumberController.dispose();
  }

  // checks if all fields are filled and then registers the driver
  registerDriver() async {
    if (profilePic == null) {
      ToastService.sendScaffoldAlert(
        msg: 'Select a Profile Pic',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (nameController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter your Name',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (mobileController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter your Mobile number',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (emailController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter your Email',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (vehicleBrandNameController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter the Vehicle Brand Name',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (vehicleModelNameController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter the vehicle model name',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (selectedVehicleType == 'Select Vehicle Type') {
      ToastService.sendScaffoldAlert(
        msg: 'Select a vehicle type',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (vehicleRegistrationNumberController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter vehicle registration number',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (drivingLicenseNumberController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter your Driving license number',
        toastStatus: 'WARNING',
        context: context,
      );
    } else {
      String profilePicURL = await ImageServices.uploadImageToFirebaseStorage(
        image: File(profilePic!.path),
        context: context,
      );
      ProfileDataModel profileData = ProfileDataModel(
        profilePicUrl: profilePicURL,
        name: nameController.text.trim(),
        mobileNumber: auth.currentUser!.phoneNumber!,
        email: emailController.text.trim(),
        userType: 'PARTNER',
        vehicleBrandName: vehicleBrandNameController.text.trim(),
        vehicleModel: vehicleModelNameController.text.trim(),
        vehicleType: selectedVehicleType,
        vehicleRegistrationNumber: vehicleRegistrationNumberController.text
            .trim(),
        drivingLicenseNumber: drivingLicenseNumberController.text.trim(),
        registeredDateTime: DateTime.now(),
      );
      await ProfileDataCRUDServices.registerUserToDatabase(
        profileData: profileData,
        context: context,
      );
    }
  }

  // checks if all fields are filled and then registers the customer
  registerCustomer() async {
    if (profilePic == null) {
      ToastService.sendScaffoldAlert(
        msg: 'Select a Profile Pic',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (nameController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter your Name',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (mobileController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter your Mobile number',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (emailController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter your Email',
        toastStatus: 'WARNING',
        context: context,
      );
    } else {
      String profilePicURL = await ImageServices.uploadImageToFirebaseStorage(
        image: File(profilePic!.path),
        context: context,
      );
      ProfileDataModel profileData = ProfileDataModel(
        profilePicUrl: profilePicURL,
        name: nameController.text.trim(),
        mobileNumber: auth.currentUser!.phoneNumber!,
        email: emailController.text.trim(),
        userType: 'CUSTOMER',
        registeredDateTime: DateTime.now(),
      );
      await ProfileDataCRUDServices.registerUserToDatabase(
        profileData: profileData,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          children: [
            SizedBox(height: 2.h),
            //for profile pic
            InkWell(
              onTap: () async {
                final image = await ImageServices.getImageFromGallery(
                  context: context,
                );
                if (image != null) {
                  setState(() {
                    profilePic = File(image.path);
                  });
                }
              },
              child: CircleAvatar(
                radius: 8.h,
                backgroundColor: greyShade3,
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: Builder(
                    builder: (context) {
                      if (profilePic != null) {
                        return CircleAvatar(
                          radius: 8.h - 2,
                          backgroundColor: Colors.white,
                          backgroundImage: FileImage(profilePic!),
                        );
                      } else {
                        return CircleAvatar(
                          radius: 8.h - 2,
                          backgroundColor: Colors.white,
                          child: const Image(
                            image: AssetImage(
                              'assets/images/uberLogo/uberLogoBlack.png',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.h),
            // Name
            RegistrationScreenTextField(
              controller: nameController,
              hint: '',
              title: 'Name',
              keyBoardType: TextInputType.name,
              readOnly: false,
            ),
            SizedBox(height: 2.h),
            // Mobile Number
            RegistrationScreenTextField(
              controller: mobileController,
              hint: '',
              title: 'Mobile Number',
              keyBoardType: TextInputType.number,
              readOnly: false,
            ),
            SizedBox(height: 2.h),
            // Email
            RegistrationScreenTextField(
              controller: emailController,
              hint: '',
              title: 'Email',
              keyBoardType: TextInputType.emailAddress,
              readOnly: false,
            ),
            SizedBox(height: 4.h),
            selectUserType('Customer'),
            SizedBox(height: 2.h),
            selectUserType('Partner'),
            SizedBox(height: 4.h),
            Builder(
              builder: (context) {
                if (userType == 'Partner') {
                  return partner();
                } else {
                  return customer();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  selectUserType(String updateUserType) {
    return InkWell(
      onTap: () {
        if (registerButtonPressed == false) {
          setState(() {
            userType = updateUserType;
          });
        }
      },
      child: Row(
        children: [
          Container(
            height: 2.5.h,
            width: 2.5.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.sp),
              border: Border.all(
                color: userType == updateUserType ? Colors.black : Colors.grey,
              ),
            ),
            child: Icon(
              Icons.check,
              color: userType == updateUserType
                  ? Colors.black
                  : Colors.transparent,
              size: 2.h,
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            'Continue as a ${updateUserType}',
            style: AppTextStyles.small10.copyWith(
              color: userType == updateUserType ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  customer() {
    return Column(
      children: [
        SizedBox(height: 10.h),
        ElevatedButtonCommon(
          onPressed: () async {
            setState(() {
              registerButtonPressed = true;
            });
            await registerCustomer();
          },
          backgroundColor: Colors.black87,
          height: 6.h,
          width: 94.w,
          child: registerButtonPressed == true
              ? CircularProgressIndicator(color: Colors.white)
              : Text(
                  'Continue',
                  style: AppTextStyles.small12Bold.copyWith(
                    color: Colors.white,
                  ),
                ),
        ),
      ],
    );
  }

  partner() {
    return Column(
      children: [
        // Vehicle Brand Name
        RegistrationScreenTextField(
          controller: vehicleBrandNameController,
          hint: '',
          title: 'Vehice Brand Name',
          keyBoardType: TextInputType.name,
          readOnly: false,
        ),
        SizedBox(height: 2.h),
        // Vehicle Model Name
        RegistrationScreenTextField(
          controller: vehicleModelNameController,
          hint: '',
          title: 'Vehicle Model Name',
          keyBoardType: TextInputType.name,
          readOnly: false,
        ),
        SizedBox(height: 2.h),
        // Drop Down Menu
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vehicle Type', style: AppTextStyles.body14Bold),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.sp),
                border: Border.all(color: grey),
              ),
              child: DropdownButton(
                isExpanded: true,
                value: selectedVehicleType,
                icon: const Icon(Icons.keyboard_arrow_down),
                underline: const SizedBox(),
                items: vehicleTypes
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: AppTextStyles.small12),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedVehicleType = value!;
                  });
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        // Vehicle Registration Number
        RegistrationScreenTextField(
          controller: vehicleRegistrationNumberController,
          hint: '',
          title: 'Vehicle Registration Number',
          keyBoardType: TextInputType.number,
          readOnly: false,
        ),
        SizedBox(height: 2.h),
        //Driving License Number
        RegistrationScreenTextField(
          controller: drivingLicenseNumberController,
          hint: '',
          title: 'Driving License Number',
          keyBoardType: TextInputType.number,
          readOnly: false,
        ),
        SizedBox(height: 2.h),
        //Elevated CONTINUE Button
        ElevatedButtonCommon(
          onPressed: () async {
            setState(() {
              registerButtonPressed = true;
            });
            await registerDriver();
          },
          backgroundColor: Colors.black87,
          height: 6.h,
          width: 94.w,
          child: registerButtonPressed == true
              ? CircularProgressIndicator(color: Colors.white)
              : Text(
                  'Continue',
                  style: AppTextStyles.small12Bold.copyWith(
                    color: Colors.white,
                  ),
                ),
        ),
      ],
    );
  }
}

class RegistrationScreenTextField extends StatefulWidget {
  const RegistrationScreenTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.title,
    required this.keyBoardType,
    required this.readOnly,
  });
  final TextEditingController controller;
  final String title;
  final String hint;
  final bool readOnly;
  final TextInputType keyBoardType;

  @override
  State<RegistrationScreenTextField> createState() =>
      _RegistrationScreenTextFieldState();
}

class _RegistrationScreenTextFieldState
    extends State<RegistrationScreenTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: AppTextStyles.body14Bold),
        SizedBox(height: 1.h),
        TextFormField(
          controller: widget.controller,
          cursorColor: black,
          style: AppTextStyles.textFieldTextStyle,
          keyboardType: widget.keyBoardType,
          readOnly: widget.readOnly,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 2.w),
            hintText: widget.hint,
            hintStyle: AppTextStyles.textFieldHintTextStyle,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: black),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: grey),
            ),
          ),
        ),
      ],
    );
  }
}
