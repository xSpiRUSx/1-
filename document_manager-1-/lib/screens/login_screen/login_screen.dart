import 'package:document_manager/screens/autorization.dart';
import 'package:document_manager/screens/login_screen/login_screen_style.dart';
import 'package:document_manager/screens/login_screen/login_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:document_manager/screens/menu.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void pushSecondScreen() {
    final navigator = Navigator.of(context);

    navigator.pushNamed(
      '/main_screen',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.fitHeight,
          image: AssetImage('images/black-370118.png'),
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoginScreenTextField(labelText: 'Логин', obscureText: false),
            const SizedBox(height: 15),
            LoginScreenTextField(
              labelText: 'Пароль',
              obscureText: true,
            ),
            const SizedBox(height: 15),
            _loginButtonNew(context),
            const SizedBox(height: 15),
            _signUpButtonNew(context),
            //_title()
          ],
        ),
      ),
    );
  }

  Widget _loginButtonNew(context) {
    return ElevatedButton(
      onPressed: pushSecondScreen,
      child: const Text(
        'Авторизация',
        style: TextStyle(fontSize: 15),
      ),
      style: ElevatedButton.styleFrom(fixedSize: const Size(300, 50)),
    );
  }

  Widget _signUpButtonNew(context) {
    return OutlinedButton(
      onPressed: () {},
      child: const Text(
        'Зарегистрироваться',
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(300, 50),
      ),
    );
  }
}
