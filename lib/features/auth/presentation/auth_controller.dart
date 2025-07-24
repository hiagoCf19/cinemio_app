import 'package:cinemio_app/features/auth/data/auth_api.dart';
import 'package:cinemio_app/features/auth/data/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(baseUrl: 'https://sua-api.com'));
});

final storageProvider = Provider((_) => const FlutterSecureStorage());
final authApiProvider = Provider((ref) => AuthApi(ref.read(dioProvider)));
final authRepoProvider = Provider((ref) =>
    AuthRepository(ref.read(authApiProvider), ref.read(storageProvider)));

enum AuthStatus { initial, loading, success, error }

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthStatus>((ref) {
  return AuthController(ref.read(authRepoProvider));
});

class AuthController extends StateNotifier<AuthStatus> {
  final AuthRepository repo;

  AuthController(this.repo) : super(AuthStatus.initial);

  Future<void> login(String email, String password) async {
    state = AuthStatus.loading;
    try {
      await repo.login(email, password);
      state = AuthStatus.success;
    } catch (_) {
      state = AuthStatus.error;
    }
  }

  Future<void> logout() async {
    await repo.logout();
    state = AuthStatus.initial;
  }
}
