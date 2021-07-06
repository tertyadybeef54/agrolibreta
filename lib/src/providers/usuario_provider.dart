import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:agrolibreta_v2/src/preferencias_usuario/preferencias_usuario.dart';

class UsuarioProvider {
  final String _firebaseToken = 'AIzaSyBBG_M9eHHmqnNsfRilGTLSAVflwSd_YNs';
  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };
    try {
      final resp = await http.post(
          Uri.parse(
              'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken'),
          body: json.encode(authData));

      Map<String, dynamic> decodedResp = json.decode(resp.body);

      print(decodedResp);

      if (decodedResp.containsKey('idToken')) {
        _prefs.token = decodedResp['idToken'];
        //TODOO: Salvar el token en el storage
        return {'ok': true, 'token': decodedResp['idToken']};
      } else {
        return {'ok': false, 'mensaje': decodedResp['error']['message']};
      }
    } catch (e) {
      return {'ok': false, 'mensaje': 'Verifique su concexión a internet'};
    }
  }

  //crear usuario en autenticacion
  Future<Map<String, dynamic>> nuevoUsuario(
      String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final resp = await http.post(
        Uri.parse(
            'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken'),
        body: json.encode(authData));

    Map<String, dynamic> decodedResp = json.decode(resp.body);


    if (decodedResp.containsKey('idToken')) {
      _prefs.password = password;
      _prefs.token = decodedResp['idToken'];
      //TODOO: Salvar el token en el storage
      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }
  }
}
