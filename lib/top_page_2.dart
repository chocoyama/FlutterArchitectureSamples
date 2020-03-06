import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterarchitecturesample/count_repository.dart';

import 'counter_bloc.dart';
import 'loading_widget_1.dart';

class TopPage2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage2> {
  CounterBloc counterBloc;

  @override
  void initState() {
    super.initState();
    counterBloc = CounterBloc(CountRepository());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
              title: const Text('Block Simple Demo')
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _WidgetA(counterBloc),
              _WidgetB(),
              _WidgetC(counterBloc),
            ],
          ),
        ),
        LoadingWidget1(counterBloc.isLoading),
      ],
    );
  }

  @override
  void dispose() {
    counterBloc.dispose();
    super.dispose();
  }
}

class _WidgetA extends StatelessWidget {
  final CounterBloc counterBloc;

  const _WidgetA(this.counterBloc);

  @override
  Widget build(BuildContext context) {
    print('called_WidgetA#build()');
    return Center(
      child: StreamBuilder(
        stream: counterBloc.value,
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
  final CounterBloc counterBloc;
  
  _WidgetC(this.counterBloc);
  
  @override
  Widget build(BuildContext context) {
    print('Called_WidgetC#build()');
    return RaisedButton(
      child: Icon(Icons.add),
      onPressed: () {
        counterBloc.incrementCounter();
      },
    );
  }
}
