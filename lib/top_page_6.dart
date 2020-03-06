import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterarchitecturesample/count_repository.dart';
import 'package:scoped_model/scoped_model.dart';

class TopPage6 extends StatelessWidget {
  final _repository = CountRepository();
  final _loadingModel = LoadingModel();

  @override
  Widget build(BuildContext context) {
    // 階層の上位にScopedModelを置く
    return ScopedModel<LoadingModel>(
      model: _loadingModel,
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              title: const Text('Scoped Model Demo'),
            ),
            body: ScopedModel<CounterModel>(
              model: CounterModel(_repository, _loadingModel),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _WidgetA(),
                  _WidgetB(),
                  _WidgetC(),
                ],
              ),
            ),
          ),
          _LoadingWidget()
        ],
      ),
    );
  }
}

class _WidgetA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('called _WidgetA#build()');
    return Center(
      // モデルの変更を購読し自動でbuilder関数の中だけで再構築される
      child: ScopedModelDescendant<CounterModel>(
        builder: (context, child, model) {
          return Text(
            '${model.counter}',
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
        // ofを使う際にrebuildOnChangeをtrueにすると、buildメソッド自体が呼ばれてWidgetが再構築される
        ScopedModel.of<CounterModel>(context, rebuildOnChange: false).incrementCounter();
      },
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LoadingModel>(
      builder: (context, child, model) {
        if (model.value) {
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

class CounterModel extends Model {
  final CountRepository _repository;
  final LoadingModel _loadingModel;

  int _counter = 0;
  int get counter => _counter;

  CounterModel(this._repository, this._loadingModel);

  void incrementCounter() async {
    _loadingModel.loading(true);
    final increaseCount = await _repository.fetch().whenComplete(() {
      _loadingModel.loading(false);
    });
    _counter += increaseCount;

    // ウィジェットに状態の変更を伝える
    notifyListeners();
  }
}

class LoadingModel extends Model {
  LoadingModel() {
    loading(false);
  }

  bool value = false;

  loading(bool isLoading) {
    value = isLoading;
    notifyListeners();
  }
}