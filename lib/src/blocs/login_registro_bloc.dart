import 'dart:async';
import 'package:agrolibreta_v2/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';


class LoginRegistroBloc with Validators{

  final _emailController    = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  
  
  //Insertar valores al Stream (entradas)
  Function(String) get changeEmail    => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  

  //Recuperar los datos del Stream (salidas)
  Stream <String> get emailStream    =>_emailController.stream.transform(validarEmail);
  Stream <String> get passwordStream =>_passwordController.stream.transform(validarPassword);
 
 
  //si el fomulario es valido activar el boton 
  Stream<bool> get formValidStream => 
    Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

  //Obtenr el ultimo valor ingresado a los streams
  String get email    => _emailController.value;
  String get password => _passwordController.value;
  

  dispose(){
    _emailController?.close();
    _passwordController?.close();
    
  }
}