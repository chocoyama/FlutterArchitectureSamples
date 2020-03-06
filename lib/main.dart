import 'package:flutter/material.dart';
import 'package:flutterarchitecturesample/count_repository.dart';
import 'package:flutterarchitecturesample/top_page_1.dart';
import 'package:flutterarchitecturesample/top_page_2.dart';
import 'package:flutterarchitecturesample/top_page_8.dart';
import 'package:flutterarchitecturesample/top_page_9.dart';

import 'top_page_0.dart';
import 'top_page_3.dart';
import 'top_page_4.dart';
import 'top_page_5.dart';
import 'top_page_6.dart';
import 'top_page_7.dart';

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
          ),
          ListTile(
            title: const Text('InheritedWidgetの場合'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TopPage1(),
                    fullscreenDialog: true,
                  )
              );
            },
          ),
          ListTile(
            title: const Text('BLoCの場合'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TopPage2(),
                    fullscreenDialog: true,
                  )
              );
            },
          ),
          ListTile(
            title: const Text('BLoC+InheritedWidgetの場合'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TopPage3(),
                    fullscreenDialog: true,
                  )
              );
            },
          ),
          ListTile(
            title: const Text('BLoC+Providerの場合（個人的おすすめ1）'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TopPage4(),
                    fullscreenDialog: true,
                  )
              );
            },
          ),
          ListTile(
            title: const Text('BLoC+MultiProviderの場合'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TopPage5(),
                    fullscreenDialog: true,
                  )
              );
            },
          ),
          ListTile(
            title: const Text('ScopedModelの場合（個人的おすすめ2）'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TopPage6(),
                    fullscreenDialog: true,
                  )
              );
            },
          ),
          ListTile(
            title: const Text('ValueNotifierの場合'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TopPage7(),
                    fullscreenDialog: true,
                  )
              );
            },
          ),
          ListTile(
            title: const Text('ValueNotifier+Providerの場合'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TopPage8(),
                    fullscreenDialog: true,
                  )
              );
            },
          ),
          ListTile(
            title: const Text('Reduxの場合'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TopPage9(CountRepository()),
                    fullscreenDialog: true,
                  )
              );
            },
          ),
        ],
      ),
    );
  }
}
