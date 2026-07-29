import 'package:flutter_code_structure/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_code_structure/features/auth/data/models/user_model.dart';
import 'package:flutter_code_structure/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_code_structure/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_code_structure/services/storage/storage_keys.dart';
import 'package:flutter_code_structure/services/storage/storage_services.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    final responseData = await remoteDataSource.signIn(
      email: email,
      password: password,
    );

    // Save Auth Tokens in local storage
    final Map<String, dynamic> data = responseData['data'] ?? responseData;
    if (data.containsKey('accessToken')) {
      await LocalStorage.setString(LocalStorageKeys.token, data['accessToken'] ?? '');
    }
    if (data.containsKey('refreshToken')) {
      await LocalStorage.setString(LocalStorageKeys.refreshToken, data['refreshToken'] ?? '');
    }

    final userJson = data['attributes'] ?? data['user'] ?? data;
    return UserModel.fromJson(userJson);
  }

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await remoteDataSource.signUp(
      name: name,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await remoteDataSource.forgotPassword(email: email);
  }

  @override
  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    await remoteDataSource.verifyOtp(email: email, otp: otp);
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    await remoteDataSource.resetPassword(
      email: email,
      newPassword: newPassword,
    );
  }
}
