import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterarchitecturesample/count_repository.dart';

class CounterBloc {
  final CountRepository _repository;
  final _valueController = StreamController<int>();
  final _loadingController = StreamController<bool>();

  Stream<int> get value => _valueController.stream;
  Stream<bool> get isLoading => _loadingController.stream;

  int _counter = 0;

  CounterBloc(this._repository) {
    _valueController.sink.add(_counter);
    _loadingController.sink.add(false);
  }

  void incrementCounter() async {
    _loadingController.sink.add(true);
    var increaseCount = await _repository.fetch().whenComplete(() {
      _loadingController.sink.add(false);
    });
    _counter += increaseCount;
    _valueController.sink.add(_counter);
  }

  void dispose() {
    _valueController.close();
    _loadingController.close();
  }
}

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
        _LoadingWidget(counterBloc.isLoading),
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

class _LoadingWidget extends StatelessWidget {
  final Stream<bool> stream;

  const _LoadingWidget(this.stream);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.data) {
          return const DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0x44000000),
            ),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}