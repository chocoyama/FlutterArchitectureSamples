import 'package:flutter/material.dart';

class TopPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _TopPage1(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('InheritedWidget Demo'),
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
    );
  }
}

class _TopPage1 extends StatefulWidget {
  final Widget child;

  const _TopPage1({Key key, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TopPage1State();

  // Stateを取得する関数を定義する。
  // SubWidgetに対してイニシャライザで状態を受け渡さず、
  // 各Widgetはこの関数を通してStateにアクセスする。
  static _TopPage1State of(BuildContext context, {bool rebuild = true}) {
    // Widgetの先祖を辿ってGenericsで指定した型のインスタンスを探している。
    // InheritedWidgetのプロパティにStateを保持させておいているので、そこから取り出すことができる。
    if (rebuild) {
      return (context.dependOnInheritedWidgetOfExactType<_MyInheritedWidget>()).data;
    } else {
      return (context.getElementForInheritedWidgetOfExactType<_MyInheritedWidget>().widget as _MyInheritedWidget).data;
    }
  }
}

class _TopPage1State extends State<_TopPage1> {
  int counter = 0;

  void _incrementCounter() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _MyInheritedWidget(
      data: this,
      child: widget.child,
    );
  }
}

class _MyInheritedWidget extends InheritedWidget {
  final _TopPage1State data;

  _MyInheritedWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class _WidgetA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("called _WidgetA#build()");
    final state = _TopPage1.of(context);

    return Center(
      child: Text(
        '${state.counter}',
        style: Theme.of(context).textTheme.display1,
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
    final state = _TopPage1.of(context, rebuild: false);
    return RaisedButton(
      child: Icon(Icons.add),
      onPressed: () {
        state._incrementCounter();
      },
    );
  }
}