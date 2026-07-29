import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:flutter_code_structure/component/button/common_button.dart';
import 'package:flutter_code_structure/component/text/common_text.dart';
import 'package:flutter_code_structure/utils/constants/app_colors.dart';
import 'package:flutter_code_structure/utils/constants/app_string.dart';
import '../controller/forget_password_controller.dart';

class VerifyScreen extends StatelessWidget {
  VerifyScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText(
          text: AppString.otpVerify,
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),
      ),
      body: GetBuilder<ForgetPasswordController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: CommonText(
                      text:
                          '${AppString.codeHasBeenSendTo} ${controller.emailController.text}',
                      fontSize: 18,
                      top: 60,
                      bottom: 40,
                      maxLines: 3,
                    ),
                  ),
                  PinCodeTextField(
                    controller: controller.otpController,
                    autoDisposeControllers: false,
                    cursorColor: AppColors.black,
                    appContext: context,
                    autoFocus: true,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(16.r),
                      fieldHeight: 60.h,
                      fieldWidth: 60.w,
                      selectedColor: AppColors.primaryColor,
                      activeColor: AppColors.primaryColor,
                      inactiveColor: AppColors.black,
                    ),
                    length: 6,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {},
                  ),
                  SizedBox(height: 40.h),
                  CommonButton(
                    titleText: AppString.verify,
                    isLoading: controller.isLoading,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        controller.verifyOtp();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
