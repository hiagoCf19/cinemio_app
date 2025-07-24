import 'package:dio/dio.dart';

class AuthApi {
  final Dio dio;

  AuthApi(this.dio);

  Future<String> login(String email, String password) async {
    final response = await dio.post('/login', data: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200 && response.data['token'] != null) {
      return response.data['token'];
    } else {
      throw Exception('Login inválido');
    }
  }
}
