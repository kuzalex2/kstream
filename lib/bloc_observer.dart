// ignore_for_file: avoid_print
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('$event');
  }

  // @override
  // void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
  //   debugPrint('$error');
  //   super.onError(bloc, error, stackTrace);
  // }
  //
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
      debugPrint('onChange: $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('$transition');
  }
}
