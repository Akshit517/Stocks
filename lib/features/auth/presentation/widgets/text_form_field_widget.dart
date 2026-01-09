import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatefulWidget {
  const TextFormFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.enabled,
    this.labelText,
    this.prefixIcon,
    this.inputType,
  });

  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final bool enabled;
  final TextInputType? inputType;

  @override
  State<TextFormFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      enabled: widget.enabled,

      keyboardType: widget.inputType ?? TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field cannot be empty.';
        } else if (value.length != 10) {
          return '10 Digits are required.';
        }
        return null;
      },

      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefixIcon: widget.prefixIcon,
      ),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
