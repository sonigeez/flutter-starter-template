import 'package:flutter/material.dart';

class InputField extends StatelessWidget {

  const InputField({
    required this.labelText, super.key,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.onChanged,
    this.maxLength,
    this.value = '',
  });
  final String labelText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final String value;
  final int? maxLength;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        labelStyle: const TextStyle(color: Colors.black),
        floatingLabelStyle: MaterialStateTextStyle.resolveWith(
          (Set<MaterialState> states) {
            final color = states.contains(MaterialState.focused)
                ? Colors.black
                : Colors.grey;
            return TextStyle(color: color);
          },
        ),
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }
}
