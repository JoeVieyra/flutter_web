import 'package:flutter/material.dart';
import 'package:flutter_web/services/auth_service.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _rfcController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? rfcValidator(String? value) {
    final rfcRegExp = RegExp(r"^([A-ZÑ&]{3,4})\d{6}([A-Z\d]{3})?$");
    if (value == null || value.isEmpty) return 'Campo requerido';
    if (!rfcRegExp.hasMatch(value)) return 'RFC no válido';
    return null;
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final success = await AuthService.registerUser(
        nombre: _nombreController.text,
        email: _correoController.text,
        rfc: _rfcController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario registrado con éxito')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar. Verifica los datos')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                  validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                ),
                TextFormField(
                  controller: _correoController,
                  decoration: InputDecoration(labelText: 'Correo'),
                  validator: (value) =>
                      value!.isEmpty || !value.contains('@') ? 'Correo inválido' : null,
                ),
                TextFormField(
                  controller: _rfcController,
                  decoration: InputDecoration(labelText: 'RFC'),
                  validator: rfcValidator,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? 'Campo requerido' : null,
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(labelText: 'Confirmar Contraseña'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) return 'Campo requerido';
                    if (value != _passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register,
                  child: Text('Registrarse'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
