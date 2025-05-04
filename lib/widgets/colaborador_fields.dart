import 'package:flutter/material.dart';

Widget buildTextField(TextEditingController controller, String label,
    {bool email = false, bool numeric = false}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(labelText: label),
    keyboardType: numeric ? TextInputType.number : TextInputType.text,
    validator: (value) {
      if (value == null || value.isEmpty) return 'Campo requerido';
      if (email && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Correo inválido';
      return null;
    },
  );
}

Widget buildDropdown(String label, List<String> options, String? value, Function(String?) onChanged) {
  return DropdownButtonFormField<String>(
    decoration: InputDecoration(labelText: label),
    value: value,
    items: options.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
    onChanged: onChanged,
    validator: (value) => value == null ? 'Seleccione una opción' : null,
  );
}

Widget buildDatePicker(BuildContext context, DateTime? selectedDate, Function(DateTime) onPicked) {
  return ListTile(
    title: Text(
      'Fecha de Inicio Laboral: ${selectedDate != null ? selectedDate.toLocal().toString().split(' ')[0] : 'Seleccionar'}',
    ),
    trailing: const Icon(Icons.calendar_today),
    onTap: () async {
      final picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
      );
      if (picked != null) onPicked(picked);
    },
  );
}
