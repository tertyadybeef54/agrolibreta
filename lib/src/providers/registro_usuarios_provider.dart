import 'dart:convert';

import 'package:agrolibreta_v2/src/modelos/usuario_model.dart';
import 'package:http/http.dart' as http;

//registrar un usuario en real time database
class RegistroUsuariosProvider{

  final String _url = 'https://agrolibretav1-default-rtdb.firebaseio.com';

  Future<bool> crearUsuario(RegistroUsuariosModel registro) async{
    
    final url = '$_url/usuarios.json';

    final resp = await http.post(Uri.parse(url), body: registroUsuariosModelToJson(registro)); 
   
    final decodedData = json.decode(resp.body);

    print (decodedData);
    return true;
  }
}