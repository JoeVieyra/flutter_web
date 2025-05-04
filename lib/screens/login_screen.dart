import 'package:flutter/material.dart';
import 'package:flutter_web/screens/change_password_screen.dart';
import 'package:flutter_web/screens/home_screen.dart';
import 'package:flutter_web/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nombreController = TextEditingController();
  final _rfcController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final result = await AuthService.loginUser(
        nombre: _nombreController.text,
        email: _correoController.text,
        password: _passwordController.text,
        rfc: _rfcController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(
              nombre: result['nombre']?.toString() ?? '',
              rfc: result['rfc'],
              email: result['email'],
            ),
          ),
        );
      } else {
        setState(() {
          _errorMessage = result['message'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_open, size: 48, color: Theme.of(context).primaryColor),
                    const SizedBox(height: 16),
                    Text('Iniciar Sesión',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),

                    
                    TextFormField(
                      controller: _correoController,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value!.isEmpty || !value.contains('@')
                          ? 'Correo inválido'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                    ),

                    if (_errorMessage.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(_errorMessage, style: const TextStyle(color: Colors.red)),
                    ],

                    const SizedBox(height: 24),

                    _isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.login),
                              label: const Text('Iniciar Sesión'),
                              onPressed: _login,
                            ),
                          ),

                    const SizedBox(height: 16),

                    TextButton.icon(
                      icon: const Icon(Icons.password),
                      label: const Text('Cambiar contraseña'),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) =>  ChangePasswordScreen()),
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
