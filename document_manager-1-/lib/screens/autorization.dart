import 'dart:convert' show utf8, base64;
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../api_manager.dart';

class AutoriazationScreen extends StatelessWidget {
  const AutoriazationScreen({Key? key}) : super(key: key);

  final String _title = "Авторизация";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        title: _title,
        home: Scaffold(
            appBar: AppBar(title: Text(_title)), body: const _InputWidget()));
  }
}

class _InputWidget extends StatefulWidget {
  const _InputWidget({Key? key}) : super(key: key);

  @override
  __InputWidgetState createState() => __InputWidgetState();
}

class __InputWidgetState extends State<_InputWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Логин',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Пароль',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState!.validate()) {
                      var result = doWork('Администратор', '162185');
                    }
                  },
                  child: const Text('Подвердить'),
                )),
          ],
        ));
  }
}

Future<bool> doWork(log, pass) async {
  var result;
  var dir = API_Manager().getNews(log, pass);
  // await Future.wait([TestAutorization(log, pass)]).then((message) {
  //   result = message[0];
  //   return message[0];
  // });
  print(dir);
  return true;
}

Future<bool> TestAutorization(log, pass) async {
  String? loginPassBase64 = "";

  loginPassBase64 = 'Basic ' + base64.encode(utf8.encode("${log}:${pass}"));

  Map<String, String>? headers = {"Authorization": loginPassBase64};

  var url = Uri.parse('http://192.168.1.2:443/sz/hs/RestAPI/v1/');

  http.get(url, headers: headers).then((response) {
    print(response.statusCode);
    //if (response.statusCode == 200) {
    // response.body
    return true;
    //} else {
    //  return false;
    //}
  });

  return false;
}
