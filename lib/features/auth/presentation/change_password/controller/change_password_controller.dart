import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';

class ChangePasswordController extends GetxController {
  bool isLoading = false;
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> changePassword() async {
    if (isLoading) return;
    try {
      isLoading = true;
      update();

      AppSnackbar.success(
        title: 'Success',
        message: 'Password changed successfully.',
      );
      Get.back();
    } catch (e) {
      AppSnackbar.error(title: 'Error', message: e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
