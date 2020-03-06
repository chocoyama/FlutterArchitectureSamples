import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterarchitecturesample/count_repository.dart';
import 'package:provider/provider.dart';

class TopPage8 extends StatelessWidget {
  final _repository = CountRepository();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<_LoadingValue>(
          create: (_) => _LoadingValue(),
        ),
        ChangeNotifierProvider<_CounterValue>(
          create: (context) {
            final loading = Provider.of<_LoadingValue>(context, listen: false);
            return _CounterValue(_repository, loading);
          },
        )
      ],
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              title: const Text('ValueNotifier+Provider Demo'),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _WidgetA(),
                _WidgetB(),
                _WidgetC(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _WidgetA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('called _WidgetA#build()');
    final counterValue = Provider.of<_CounterValue>(context, listen: false);

    return Center(
      // build()が呼ばれなくて良いようにBuilderを利用する
      child: ValueListenableBuilder<int>(
        // ValueListenable型が必要なので、ValueNotifierを継承させている
        valueListenable: counterValue,
        builder: (context, count, child) {
          return Text(
              '$count',
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
    return const Text('I am a widget that will not be rebuilt.');
  }
}

class _WidgetC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('called _WidgetC#build()');
    return RaisedButton(
      child: Icon(Icons.add),
      onPressed: () {
        Provider.of<_CounterValue>(context, listen: false).incrementCounter();
      },
    );
  }
}

class _CounterValue extends ValueNotifier<int> {
  final CountRepository _repository;
  final _LoadingValue _loadingValue;

  _CounterValue(this._repository, this._loadingValue) : super(0);

  void incrementCounter() async {
    _loadingValue.loading(true);
    final increaseCount = await _repository.fetch().whenComplete(() {
      _loadingValue.loading(false);
    });
    super.value += increaseCount;
  }
}

class _LoadingValue extends ValueNotifier<bool> {
  _LoadingValue() : super(false);

  loading(bool isLoading) {
    super.value = isLoading;
  }
}

// ChangeNotifierを利用するとValueListenableListenerが使えない
// そのため、ofメソッドをlisten:trueで呼び出す必要が出てしまい、これを使うとbuild()メソッドが何度も呼ばれる
class _CounterValue2 extends ChangeNotifier {
  final CountRepository _repository;
  final _LoadingValue _loadingValue;

  _CounterValue2(this._repository, this._loadingValue);

  int _counter = 0;
  int get counter => _counter;

  void incrementCounter() async {
    _loadingValue.loading(true);
    final increaseCount = await _repository.fetch().whenComplete(() {
      _loadingValue.loading(false);
    });
    _counter *= increaseCount;
    notifyListeners();
  }
}