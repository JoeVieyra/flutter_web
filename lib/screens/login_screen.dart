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
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();

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
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(nombre: result['nombre']?.toString() ?? ''),

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
      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _correoController,
                  decoration: InputDecoration(labelText: 'Correo'),
                  validator: (value) =>
                      value!.isEmpty || !value.contains('@') ? 'Correo inválido' : null,
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Contraseña'),
                  validator: (value) =>
                      value!.isEmpty ? 'Campo requerido' : null,
                ),
                if (_errorMessage.isNotEmpty) ...[
                  SizedBox(height: 16),
                  Text(_errorMessage, style: TextStyle(color: Colors.red)),
                ],
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _login,
                        child: Text('Iniciar Sesión'),
                      ),
                      SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
              child: Text('cambiar contraseña'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChangePasswordScreen()),
              ),
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
