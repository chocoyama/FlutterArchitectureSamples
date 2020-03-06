import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterarchitecturesample/count_repository.dart';
import 'package:flutterarchitecturesample/redux/action.dart';
import 'package:flutterarchitecturesample/redux/middleware.dart';
import 'package:flutterarchitecturesample/redux/reducer.dart';
import 'package:flutterarchitecturesample/redux/state.dart';
import 'package:redux/redux.dart';

class TopPage9 extends StatelessWidget {
  final CountRepository _repository;
  final Store<AppState> store;

  TopPage9(this._repository)
      : store = Store<AppState>(
    appStateReducer,
    initialState: const AppState(),
    middleware: counterMiddleware(_repository)
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              title: const Text('Redux Demo'),
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
          _LoadingWidget()
        ],
      )
    );
  }
}

class _WidgetA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('called _WidgetA#build()');
    return Center(
      child: StoreConnector<AppState, int>(
        converter: (store) => store.state.counter,
        builder: (context, counter) {
          return Text(
            '$counter',
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
        final store = StoreProvider.of<AppState>(context);
        store.dispatch(CountUpAction(store.state.counter));
      },
    );
  }
}
class _LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
      converter: (store) => store.state.isLoading,
      builder: (context, isLoading) {
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