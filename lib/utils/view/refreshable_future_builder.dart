import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RefreshableFutureBuilder<T> extends StatefulWidget {
  final Future<T> Function(bool isRefresh) futureBuilder;
  final Widget Function(BuildContext ctx, T value) builder;
  final bool forceScrollable;

  const RefreshableFutureBuilder({
    Key key,
    @required this.futureBuilder,
    @required this.builder,
    @required this.forceScrollable
  }) : super(key: key);

  @override
  RefreshableFutureBuilderState createState() =>
      RefreshableFutureBuilderState<T>(futureBuilder, builder, forceScrollable);
}

class RefreshableFutureBuilderState<T> extends State<RefreshableFutureBuilder> {
  final Future<T> Function(bool isRefresh) futureBuilder;
  final Widget Function(BuildContext ctx, T value) builder;
  final bool forceScrollable;
  final _indicatorKey = GlobalKey<RefreshIndicatorState>();

  T _value;
  bool _isLoaded = false;

  RefreshableFutureBuilderState(this.futureBuilder, this.builder, this.forceScrollable);

  update({@required bool isRefresh}) {
    if(isRefresh) {
      _indicatorKey.currentState.show();
    } else {
      _updateValue(isRefresh: false);
    }
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => update(isRefresh: true));
  }

  @override
  Widget build(BuildContext ctx) => RefreshIndicator(
        key: _indicatorKey,
        onRefresh: () async => await _updateValue(isRefresh: true),
        child: _content(ctx),
      );

  Widget _content(BuildContext ctx) {
    if (_value == null) {
      return Container();
    } else if(forceScrollable) {
      return Stack(
        children: <Widget>[
          ListView(physics: const AlwaysScrollableScrollPhysics()),
          Positioned.fill(child: builder(ctx, _value)),
        ],
      );
    } else {
      return builder(ctx, _value);
    }
  }

  Future _updateValue({@required bool isRefresh}) async {
    final value = await futureBuilder(_isLoaded && isRefresh);
    setState(() {
      _value = value;
      _isLoaded = true;
    });
  }
}
