import 'package:agrolibreta_v2/src/blocs/login_registro_bloc.dart';
import 'package:flutter/material.dart';
export 'package:agrolibreta_v2/src/blocs/login_registro_bloc.dart';

class BlocProvider extends InheritedWidget{

  final loginRegistroBloc = LoginRegistroBloc();

  BlocProvider({Key key, Widget child})
  : super (key:key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) =>true;

  static LoginRegistroBloc of (BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<BlocProvider>().loginRegistroBloc;
  }
}
