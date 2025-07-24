import 'package:cinemio_app/features/auth/presentation/auth_controller.dart';
import 'package:cinemio_app/features/auth/presentation/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authControllerProvider.notifier).login(
            emailCtrl.text,
            passCtrl.text,
          );

      final status = ref.read(authControllerProvider);
      if (status == AuthStatus.success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else if (status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Credenciais inválidas")),
        );
      }
    }
  }

  void _goToRegister() {
    // TODO: aqui a navegação para tela de registro
  }

  void _recoverPassword() {
    // TODO:  aqui a lógica para recuperar senha
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(authControllerProvider);
    final loading = status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Entrar",
          style: TextStyle(
            color: Color(0xFF4B0082), // roxo índigo
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          // <-- Coloque o padding aqui
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Email
                    TextFormField(
                      controller: emailCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFF4B0082)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.redAccent),
                        ),
                      ),
                      validator: (v) => v == null || !v.contains('@')
                          ? 'Email inválido'
                          : null,
                    ),
                    const SizedBox(height: 20),

                    // Senha
                    TextFormField(
                      controller: passCtrl,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFF4B0082)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.redAccent),
                        ),
                      ),
                      validator: (v) => v != null && v.length >= 6
                          ? null
                          : 'Mínimo 6 caracteres',
                    ),

                    const SizedBox(height: 30),

                    // Botão Login
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: loading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4B0082),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                        ),
                        child: loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Recuperar senha
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: loading ? null : _recoverPassword,
                        child: const Text(
                          "Recuperar senha",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Linha separadora com texto
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.grey[600], thickness: 1),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            "ou",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: Colors.grey[600], thickness: 1),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Botão Registrar
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: loading ? null : _goToRegister,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF4B0082)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "Registrar-se",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF4B0082),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
