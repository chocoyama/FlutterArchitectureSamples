import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterarchitecturesample/count_repository.dart';

class TopPage7 extends StatefulWidget {
  final repository = CountRepository();
  final loadingValue = LoadingValue();

  @override
  State<StatefulWidget> createState() => _TopPageState(
    child: Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: const Text('ValueNotifier Demo'),
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
        _LoadingWidget(),
      ],
    )
  );
}

class _TopPageState extends State<TopPage7> {
  CounterValue counter;

  final Widget child;

  _TopPageState({this.child});

  static _TopPageState of(BuildContext context, {bool rebuild = true}) {
    if (rebuild) {
      return context.dependOnInheritedWidgetOfExactType<_MyInheritedWidget>().data;
    } else {
      return (context.getElementForInheritedWidgetOfExactType<_MyInheritedWidget>().widget as _MyInheritedWidget).data;
    }
  }

  @override
  void initState() {
    super.initState();
    counter = CounterValue(widget.repository, widget.loadingValue);
  }

  @override
  Widget build(BuildContext context) {
    return _MyInheritedWidget(
      data: this,
      child: child,
    );
  }
}

class _MyInheritedWidget extends InheritedWidget {
  _MyInheritedWidget({
    Key key,
    @required Widget child,
    @required this.data
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
    print('called_WidgetA#build()');
    final state = _TopPageState.of(context, rebuild: false);

    return Center(
      child: ValueListenableBuilder<int>(
        valueListenable: state.counter.valueNotifier,
        builder: (context, count, child) {
          return Text(
            '$count',
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
    print('called WidgetB#build()');
    return const Text('I am a widget that will not be rebuilt.');
  }
}

class _WidgetC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('called _WidgetC#build()');
    final state = _TopPageState.of(context, rebuild: false);

    return RaisedButton(
      child: Icon(Icons.add),
      onPressed: () {
        state.counter.incrementCounter();
      },
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = _TopPageState.of(context, rebuild: false);

    return ValueListenableBuilder<bool>(
      valueListenable: state.counter._loadingValue.isLoading,
      builder: (context, isLoading, child) {
        if (isLoading) {
          return const DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0x44000000),
              ),
              child: Center(
                child: CircularProgressIndicator(),
              )
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

class CounterValue {
  final CountRepository _repository;
  final LoadingValue _loadingValue;

  CounterValue(this._repository, this._loadingValue);
  final valueNotifier = ValueNotifier<int>(0);

  void incrementCounter() async {
    _loadingValue.loading(true);
    final increaseCount = await _repository.fetch().whenComplete(() {
      _loadingValue.loading(false);
    });
    valueNotifier.value += increaseCount;
  }
}

class LoadingValue {
  final isLoading = ValueNotifier<bool>(false);

  loading(bool isLoading) {
    this.isLoading.value = isLoading;
  }
}