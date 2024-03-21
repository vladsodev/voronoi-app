import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController textEditingController;
  const MyTextField({
    super.key,
    required this.hintText,
    required this.textEditingController,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(10),
      child: TextField(
        controller: textEditingController,
          decoration: InputDecoration(
            hintText: hintText,
          ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r'^\d{0,4}')
          ),
        ],
      ),
    );
  }
}