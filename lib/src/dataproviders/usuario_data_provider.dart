import 'package:agrolibreta_v2/src/data/usuario_operations.dart';
import 'package:agrolibreta_v2/src/modelos/usuario_model.dart';
import 'package:flutter/material.dart';

UsuarioOperations _usuOper = new UsuarioOperations();

//provider que maneja los datos del usuario
class UsuarioProvider with ChangeNotifier {
  List<RegistroUsuariosModel> usuarios = [];
  int a;

  UsuarioProvider() {
    this.getUsuarios();
  }
  getUsuarios() async {
    final resp = await _usuOper.consultarUsuario();
    this.usuarios = [...resp];
    print(resp);
    notifyListeners();
  }

  actualizarData(RegistroUsuariosModel nuevoUsuario) async {
    final res = await _usuOper.updateUsuarios(nuevoUsuario);
    notifyListeners();
    print(res.toString());
  }
}
