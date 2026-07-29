import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:flutter_code_structure/component/button/common_button.dart';
import 'package:flutter_code_structure/component/text/common_text.dart';
import 'package:flutter_code_structure/component/text_field/common_text_field.dart';
import 'package:flutter_code_structure/utils/constants/app_string.dart';
import 'package:flutter_code_structure/utils/helpers/validation.dart';
import '../controller/change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText(
          text: AppString.changePassword,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: GetBuilder<ChangePasswordController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CommonTextField(
                    controller: controller.currentPasswordController,
                    isPassword: true,
                    hintText: AppString.currentPassword,
                    validator: AppValidation.password,
                  ),
                  SizedBox(height: 16.h),
                  CommonTextField(
                    controller: controller.newPasswordController,
                    isPassword: true,
                    hintText: AppString.newPassword,
                    validator: AppValidation.password,
                  ),
                  SizedBox(height: 16.h),
                  CommonTextField(
                    controller: controller.confirmPasswordController,
                    isPassword: true,
                    hintText: AppString.confirmPassword,
                    validator: (val) => AppValidation.confirmPassword(
                      val,
                      controller.newPasswordController,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  CommonButton(
                    titleText: AppString.changePassword,
                    isLoading: controller.isLoading,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        controller.changePassword();
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
