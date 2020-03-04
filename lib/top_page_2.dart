import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CounterLogic {
  final _valueController = StreamController<int>();
  Stream<int> get value => _valueController.stream;

  int _counter = 0;

  CounterLogic() {
    _valueController.sink.add(_counter);
  }

  void incrementCounter() async {
    _valueController.sink.add(++_counter);
  }

  void dispose() {
    _valueController.close();
  }
}

class TopPage2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage2> {
  CounterLogic counterLogic;

  @override
  void initState() {
    super.initState();
    counterLogic = CounterLogic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Block Simple Demo')
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _WidgetA(counterLogic),
          _WidgetB(),
          _WidgetC(counterLogic),
        ],
      ),
    );
  }

  @override
  void dispose() {
    counterLogic.dispose();
    super.dispose();
  }
}

class _WidgetA extends StatelessWidget {
  final CounterLogic counterLogic;

  const _WidgetA(this.counterLogic);

  @override
  Widget build(BuildContext context) {
    print('called_WidgetA#build()');
    return Center(
      child: StreamBuilder(
        stream: counterLogic.value,
        builder: (context, snapshot) {
          return Text(
            '${snapshot.data}',
            style: Theme.of(context).textTheme.display1,
          );
        },
      ),
    );
  }
}

class _WidgetB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('called_WidgetB#build()');
    return const Text('I am a widget that will not be rebuilt.');
  }
}

class _WidgetC extends StatelessWidget {
  final CounterLogic counterLogic;
  
  _WidgetC(this.counterLogic);
  
  @override
  Widget build(BuildContext context) {
    print('Called_WidgetC#build()');
    return RaisedButton(
      child: Icon(Icons.add),
      onPressed: () {
        counterLogic.incrementCounter();
      },
    );
  }
}