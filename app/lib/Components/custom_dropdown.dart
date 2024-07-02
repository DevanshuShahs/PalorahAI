import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String hint;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;

  const CustomDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString()),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
        hintText: hint,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
    );
  }
}