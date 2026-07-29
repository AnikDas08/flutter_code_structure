import 'package:flutter/material.dart';
import 'package:flutter_code_structure/component/text/common_text.dart';
import 'package:flutter_code_structure/component/text_field/common_text_field.dart';
import 'package:flutter_code_structure/utils/constants/app_string.dart';
import 'package:flutter_code_structure/utils/helpers/validation.dart';
import '../controller/sign_up_controller.dart';

class SignUpAllField extends StatelessWidget {
  const SignUpAllField({super.key, required this.controller});

  final SignUpController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonText(text: AppString.fullName, bottom: 8, top: 12),
        CommonTextField(
          hintText: AppString.fullName,
          controller: controller.nameController,
          validator: AppValidation.required,
        ),
        const CommonText(text: AppString.email, bottom: 8, top: 12),
        CommonTextField(
          controller: controller.emailController,
          hintText: AppString.email,
          validator: AppValidation.email,
        ),
        const CommonText(text: AppString.password, bottom: 8, top: 12),
        CommonTextField(
          controller: controller.passwordController,
          isPassword: true,
          hintText: AppString.password,
          validator: AppValidation.password,
        ),
        const CommonText(text: AppString.confirmPassword, bottom: 8, top: 12),
        CommonTextField(
          controller: controller.confirmPasswordController,
          isPassword: true,
          hintText: AppString.confirmPassword,
          validator: (value) => AppValidation.confirmPassword(
            value,
            controller.passwordController,
          ),
        ),
      ],
    );
  }
}
