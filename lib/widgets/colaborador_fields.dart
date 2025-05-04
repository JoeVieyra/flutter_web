import 'package:flutter/material.dart';

Widget buildTextField(TextEditingController controller, String label,
    {bool email = false, bool numeric = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      controller: controller,
      keyboardType: numeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: email
            ? const Icon(Icons.email)
            : numeric
                ? const Icon(Icons.numbers)
                : const Icon(Icons.text_fields),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Campo requerido';

        if (email && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Correo inválido';
        }

        if (label.toLowerCase() == 'rfc') {
          final rfcRegex = RegExp(r'^([A-ZÑ&]{3,4})(\d{6})([A-Z\d]{3})?$');
          if (!rfcRegex.hasMatch(value.toUpperCase())) {
            return 'RFC inválido';
          }
        }

        return null;
      },
    ),
  );
}

Widget buildDropdown(
    String label, List<String> options, String? value, Function(String?) onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      value: value,
      items: options
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Seleccione una opción' : null,
    ),
  );
}

Widget buildDatePicker(BuildContext context, DateTime? selectedDate, Function(DateTime) onPicked) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (picked != null) onPicked(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Fecha de Inicio Laboral',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate != null
                  ? selectedDate.toLocal().toString().split(' ')[0]
                  : 'Seleccionar fecha',
              style: TextStyle(fontSize: 16),
            ),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    ),
  );
}
