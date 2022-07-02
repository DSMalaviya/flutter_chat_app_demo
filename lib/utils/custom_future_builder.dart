import 'package:flutter/material.dart';

class CustomFutureBuilder<T> extends StatelessWidget {
  ///See [FutureBuilder.future] for information
  final Future<T>? future;

  ///See [FutureBuilder.initialData] for information
  final T? initialData;

  ///Callback invoked when [future] is not null and it's finished ([ConnectionState.done]), passing data object, or if [future] is null, with data null
  final Widget Function(BuildContext context, T? data) onData;

  ///Callback invoked when [future] is not null, before it will finish
  final Widget Function(BuildContext context)? onWait;

  ///Callback invoked if [future] is not null and it ends in error
  final Widget Function(BuildContext context, Object? error)? onError;

  const CustomFutureBuilder({
    Key? key,
    this.future,
    this.initialData,
    required this.onData,
    this.onWait,
    this.onError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FutureBuilder<T>(
        future: future,
        initialData: initialData,
        builder: advAsyncBuilder(onData, onWait, onError),
      );
}

AsyncWidgetBuilder<T> advAsyncBuilder<T>(
  final Widget Function(BuildContext context, T? data) onData,
  final Widget Function(BuildContext context)? onWait,
  final Widget Function(BuildContext context, Object? error)? onError,
) =>
    (context, snapshot) {
      Widget? _return;
      switch (snapshot.connectionState) {
        //future null case
        case ConnectionState.none:
          _return = onData(context, null);
          break;
        //waiting case
        case ConnectionState.waiting:
        case ConnectionState.active:
          if (onWait != null) {
            _return = onWait(context);
          }
          break;
        //done case, running onError or onData depending on future status
        case ConnectionState.done:
          if (snapshot.hasError) {
            if (onError != null) {
              _return = onError(context, snapshot.error);
            }
          } else {
            _return = onData(context, snapshot.data);
          }
          break;
      }

      //default case, if no one return set was invoked
      _return ??= Container();

      return _return;
    };
