import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';



class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final emailController = TextEditingController();
  final rfcController = TextEditingController();
  final newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> cambiarPassword() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/auth/change-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text,
          'rfc': rfcController.text,
          'newPassword': newPasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Contraseña actualizada')));
      } else {
        final message = jsonDecode(response.body)['message'];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $message')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cambiar Contraseña')),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Correo'),
              validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
            ),
            TextFormField(
              controller: rfcController,
              decoration: InputDecoration(labelText: 'RFC'),
              validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
            ),
            TextFormField(
              controller: newPasswordController,
              decoration: InputDecoration(labelText: 'Nueva Contraseña'),
              obscureText: true,
              validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: cambiarPassword, child: Text('Actualizar Contraseña')),
          ]),
        ),
      ),
    );
  }
}
