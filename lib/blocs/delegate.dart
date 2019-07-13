import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';

class SimpleBlocDelegate extends BlocDelegate {
  
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    if(!kReleaseMode) {
      print(event);
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if(!kReleaseMode) {
      print(transition);
    }
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if(!kReleaseMode) {
      print(error);
    }
  }
}