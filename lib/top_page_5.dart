import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'count_repository.dart';

class TopPage5 extends StatelessWidget {
  final _repository = CountRepository();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 先にLoadingBlocのProviderをインスタンス化
        Provider<_LoadingBloc>(
          create: (_) => _LoadingBloc(),
          dispose: (_, bloc) => bloc.dispose(),
        ),
        // インスタンス化済みのBlocをcontextから取り出す
        Provider<_CounterBloc>(
          create: (context) {
            final bloc = Provider.of<_LoadingBloc>(context, listen: false);
            return _CounterBloc(_repository, bloc);
          },
          dispose: (_, bloc) => bloc.dispose(),
        )
      ],
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              title: const Text('BLoC Demo'),
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
          // この時点でのcontextにはProviderが含まれていないため、Consumerを利用する必要がある
          Consumer<_CounterBloc>(builder: (context, value, child) {
            return _LoadingWidget();
          }),
        ],
      ),
    );
  }
}

class _WidgetA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('called _WidgetA#build()');
    // StreamBuilderを利用しているため、BLoCクラス自体をlistenする必要がない
    var bloc = Provider.of<_CounterBloc>(context, listen: false);

    return Center(
      child: StreamBuilder<int>(
        stream: bloc.value,
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
    print('called _WidgetB#build()');
    return const Text('I am a widget that will not be built.');
  }
}

class _WidgetC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('called _WidgetC#build()');
    return RaisedButton(
      child: Icon(Icons.add),
      onPressed: () {
        Provider.of<_CounterBloc>(context, listen: false).incrementCounter();
      },
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<_LoadingBloc>(context, listen: false);
    return StreamBuilder<bool>(
      initialData: false,
      stream: bloc.value,
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

class _CounterBloc {
  final CountRepository _repository;
  final _LoadingBloc _loadingBloc;
  final _valueController = StreamController<int>();

  Stream<int> get value => _valueController.stream;

  int _counter = 0;

  _CounterBloc(this._repository, this._loadingBloc) {
    _valueController.sink.add(_counter);
  }

  void incrementCounter() async {
    _loadingBloc.loading(true);
    var increaseCount = await _repository.fetch().whenComplete(() {
      _loadingBloc.loading(false);
    });
    _counter += increaseCount;
    _valueController.sink.add(_counter);
  }

  void dispose() {
    _valueController.close();
  }
}

class _LoadingBloc {
  final _valueController = StreamController<bool>();
  Stream<bool> get value => _valueController.stream;

  _LoadingBloc() {
    loading(false);
  }

  loading(bool isLoading) {
    _valueController.sink.add(isLoading);
  }

  void dispose() {
    _valueController.close();
  }
}