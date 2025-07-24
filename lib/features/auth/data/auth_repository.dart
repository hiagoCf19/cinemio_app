import 'package:cinemio_app/features/auth/data/auth_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final AuthApi api;
  final FlutterSecureStorage storage;

  AuthRepository(this.api, this.storage);

  Future<void> login(String email, String password) async {
    final token = await api.login(email, password);
    await storage.write(key: 'token', value: token);
  }

  Future<void> logout() async {
    await storage.delete(key: 'token');
  }
}
