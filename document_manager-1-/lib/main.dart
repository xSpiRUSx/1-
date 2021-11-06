import 'package:document_manager/screens/autorization.dart';
import 'package:document_manager/screens/login_screen/login_screen.dart';
import 'package:document_manager/screens/menu.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          '/login_screen': (context) => LoginScreen(),
          '/main_screen': (context) => SecondScreen()
        },
        theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(
              color: Colors.blue,
            ),
            labelStyle: TextStyle(
              color: Colors.green,
            ),
          ),
          primarySwatch: Colors.orange,
        ),
        //home: LoginScreen());
        initialRoute: '/login_screen');
  }
}

class MenuRowData {
  final IconData icon;
  final String textData;

  MenuRowData(this.icon, this.textData);
}
