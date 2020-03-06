import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'count_repository.dart';
import 'counter_bloc.dart';
import 'loading_widget_1.dart';

class TopPage4 extends StatelessWidget {
  final _repository = CountRepository();

  @override
  Widget build(BuildContext context) {
    return Provider<CounterBloc>(
      create: (context) => CounterBloc(_repository),
      dispose: (_, bloc) => bloc.dispose(),
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
          Consumer<CounterBloc>(builder: (context, value, child) {
            return LoadingWidget1(value.isLoading);
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
    var bloc = Provider.of<CounterBloc>(context, listen: false);
    
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
        Provider.of<CounterBloc>(context, listen: false).incrementCounter();
      },
    );
  }
}