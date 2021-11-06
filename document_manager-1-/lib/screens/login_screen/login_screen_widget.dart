import 'package:flutter/material.dart';

import 'login_screen_style.dart';

class LoginScreenTextField extends StatelessWidget {
  final String labelText;
  bool obscureText = false;
  LoginScreenTextField({
    Key? key,
    required this.labelText,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        obscureText: obscureText,
        style: LoginStyle.textFieldTextStyle,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: LoginStyle.textFieldLabelTextStyle,
          // TO DO добавить цвет для ошибок
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.orange),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          isCollapsed: true,
        ),
      ),
    );
  }
}
