import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Auth App',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bienvenido')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Iniciar Sesión'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Registrarse'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RegisterScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
