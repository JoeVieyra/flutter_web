import 'package:flutter/material.dart';
import 'package:flutter_web/widgets/colaborador_form.dart';


class ColaboradorFormScreen extends StatelessWidget {
  const ColaboradorFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Colaborador')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: ColaboradorForm(),
      ),
    );
  }
}
