import 'package:flutter_code_structure/config/api/api_end_point.dart';
import 'package:flutter_code_structure/services/api/api_service.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<void> forgotPassword({required String email});

  Future<void> verifyOtp({
    required String email,
    required String otp,
  });

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    final response = await ApiService.post(
      ApiEndPoint.signIn,
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.isSuccess) {
      return response.data;
    } else {
      throw Exception(response.message);
    }
  }

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await ApiService.post(
      ApiEndPoint.signUp,
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    if (!response.isSuccess) {
      throw Exception(response.message);
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    final response = await ApiService.post(
      ApiEndPoint.forgotPassword,
      body: {'email': email},
    );

    if (!response.isSuccess) {
      throw Exception(response.message);
    }
  }

  @override
  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await ApiService.post(
      ApiEndPoint.verifyOtp,
      body: {
        'email': email,
        'otp': otp,
      },
    );

    if (!response.isSuccess) {
      throw Exception(response.message);
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final response = await ApiService.post(
      ApiEndPoint.resetPassword,
      body: {
        'email': email,
        'newPassword': newPassword,
      },
    );

    if (!response.isSuccess) {
      throw Exception(response.message);
    }
  }
}
