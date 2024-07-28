import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String labelText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final String value;
  final int? maxLength;
  final ValueChanged<String>? onChanged;

  const InputField({
    super.key,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.onChanged,
    this.maxLength,
    this.value = '',
  });

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
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        labelStyle: const TextStyle(color: Colors.black),
        floatingLabelStyle: MaterialStateTextStyle.resolveWith(
          (Set<MaterialState> states) {
            final Color color = states.contains(MaterialState.focused)
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
