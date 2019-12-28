
import 'package:flutter/material.dart';

class StreamBuilderWithProgress<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget Function(BuildContext ctx, T data) builder;

  const StreamBuilderWithProgress({@required this.stream, @required this.builder});

  @override
  Widget build(BuildContext ctx) => StreamBuilder(
        stream: stream,
        builder: (ctx, snapshot) =>
            snapshot.hasData ? builder(ctx, snapshot.data) : Center(child: CircularProgressIndicator()),
      );
}
