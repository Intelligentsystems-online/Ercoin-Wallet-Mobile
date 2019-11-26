import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef FutureBuilderBuilder<T> = Widget Function(T);
typedef FutureBuilderProgressBuilder = Widget Function();

FutureBuilderProgressBuilder _defaultProgressBuilder =
    () => Center(child: CircularProgressIndicator());

class FutureBuilderWithProgress<T> extends FutureBuilder {
  FutureBuilderWithProgress({
    @required Future<T> future, 
    @required FutureBuilderBuilder<T> builder,
    FutureBuilderProgressBuilder progressBuilder
  }) : super(
    future: future,
    builder: (_, AsyncSnapshot snapshot) =>
        snapshot.hasData ? builder(snapshot.data)
            : (progressBuilder ?? _defaultProgressBuilder)()
  );

}
