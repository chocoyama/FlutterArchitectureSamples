import 'package:flutter/material.dart';

import 'top_page_0.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('setStateの場合'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TopPage0(),
                    fullscreenDialog: true,
                  )
              );
            },
          )
        ],
      ),
    );
  }
}
