import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_code_structure/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_code_structure/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/utils/helpers/other_helper.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find<SignUpController>();

  final AuthRepository _authRepository;

  SignUpController({AuthRepository? authRepository})
      : _authRepository = authRepository ??
            AuthRepositoryImpl(
              remoteDataSource: AuthRemoteDataSourceImpl(),
            );

  bool isLoading = false;
  bool isLoadingVerify = false;
  String selectRole = 'User';
  String countryCode = '+880';
  String? image;
  String signUpToken = '';
  Timer? _timer;
  int _seconds = 0;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final numberController = TextEditingController();
  final otpController = TextEditingController();

  String get time {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void onCountryChange(Country value) {
    countryCode = value.dialCode;
  }

  void setSelectedRole(String value) {
    selectRole = value;
    update();
  }

  Future<void> openGallery() async {
    image = await OtherHelper.pickImage();
    update();
  }

  Future<void> signUpUser() async {
    if (isLoading) return;
    try {
      isLoading = true;
      update();

      await _authRepository.signUp(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Get.toNamed(AppRoutes.verifyUser);
    } catch (e) {
      AppSnackbar.error(title: 'Error', message: e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  void startTimer() {
    _timer?.cancel();
    _seconds = 180;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();
        return;
      }
      _seconds--;
      update();
    });
  }

  Future<void> verifyOtp() async {
    Get.offAllNamed(AppRoutes.signIn);
  }

  @override
  void onClose() {
    _timer?.cancel();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    numberController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
