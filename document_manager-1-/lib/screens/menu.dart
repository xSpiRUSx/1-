import 'package:flutter/material.dart';

class AppMenu extends StatelessWidget {
  const AppMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
          centerTitle: true,
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          }),
          title: const Text(
            'Меню',
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.send_to_mobile_sharp),
              tooltip: 'Show Snackbar',
              onPressed: () {
                // ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(content: Text('This is a snackbar')));
              },
            ),
          ]),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.fitHeight,
          image: AssetImage('images/menu_back.png'),
        )),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Container(
              width: double.infinity,
              height: 80,
              // decoration: BoxDecoration(border: Border.all(width: 1)),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const SecondScreen();
                  }));
                  //print('asdas');
                },
                child: Row(
                  children: const [
                    SizedBox(width: 10),
                    Icon(
                      Icons.mail_outline_rounded,
                      size: 65,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                        child: Text(
                      'Задачи мне',
                      style: TextStyle(fontSize: 30),
                    )),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: const [
              SizedBox(width: 10),
              Icon(
                Icons.mail,
                size: 65,
              ),
              SizedBox(width: 10),
              Expanded(
                  child: Text(
                'Задачи от меня',
                style: TextStyle(fontSize: 30),
              )),
              Icon(Icons.arrow_forward_ios)
            ],
          ),
        ]),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            // leading: Builder(builder: (BuildContext context) {
            //   return IconButton(
            //     icon: const Icon(Icons.menu),
            //     onPressed: () {
            //       Scaffold.of(context).openDrawer();
            //     },
            //     tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            //   );
            // }),
            title: const Text('Меню'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.send_to_mobile_sharp),
                tooltip: 'Show Snackbar',
                onPressed: () {},
              ),
            ]),
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fitHeight,
              image: AssetImage('images/menu_back.png'),
            )),
            child: Container()));
  }
}
