import 'package:flutter/material.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_code_structure/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_code_structure/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final AuthRepository _authRepository;

  SignInController({AuthRepository? authRepository})
      : _authRepository = authRepository ??
            AuthRepositoryImpl(
              remoteDataSource: AuthRemoteDataSourceImpl(),
            );

  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signInUser() async {
    if (isLoading) return;

    try {
      isLoading = true;
      update();

      await _authRepository.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      emailController.clear();
      passwordController.clear();

      Get.offAllNamed(AppRoutes.profile);
    } catch (e) {
      AppSnackbar.error(
        title: 'Sign In Failed',
        message: e.toString().replaceAll('Exception: ', ''),
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
