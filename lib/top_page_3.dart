import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterarchitecturesample/count_repository.dart';
import 'package:flutterarchitecturesample/loading_widget_1.dart';

import 'counter_bloc.dart';

class TopPage3 extends StatefulWidget {
  final repository = CountRepository();

  @override
  State<StatefulWidget> createState() => _TopPageState();

  static _TopPageState of(BuildContext context, { bool rebuild = true}) {
    if (rebuild) {
      return context.dependOnInheritedWidgetOfExactType<_MyInheritedWidget>().data;
    } else {
      return (context.getElementForInheritedWidgetOfExactType<_MyInheritedWidget>().widget as _MyInheritedWidget).data;
    }
  }
}

class _TopPageState extends State<TopPage3> {
  CounterBloc counterBloc;

  @override
  void initState() {
    super.initState();
    counterBloc = CounterBloc(widget.repository);
  }

  @override
  Widget build(BuildContext context) {
    return _MyInheritedWidget(
      data: this,
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              title: const Text('InheriteWidget BLoC Demo'),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _WidgetA(),
                _WidgetB(),
                _WidgetC(),
              ],
            ),
          ),
          LoadingWidget1(counterBloc.isLoading),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    counterBloc.dispose();
  }
}

class _MyInheritedWidget extends InheritedWidget {
  _MyInheritedWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  final _TopPageState data;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class _WidgetA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('called _WidgetA#build()');
    final state = TopPage3.of(context, rebuild: false);
    
    return Center(
      child: StreamBuilder(
        stream: state.counterBloc.value,
        builder: (context, snapshot) {
          return Text(
            '${snapshot.data}',
            style: Theme.of(context).textTheme.display1
          );
        },
      ),
    );
  }
}

class _WidgetB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('called _WidgetB#build()');
    return const Text('I am a widget that will not be rebuild.');
  }
}

class _WidgetC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('called _WidgetC#build()');
    final state = TopPage3.of(context, rebuild: false);
    
    return RaisedButton(
      child: Icon(Icons.add),
      onPressed: () {
        state.counterBloc.incrementCounter();
      },
    );
  }
}