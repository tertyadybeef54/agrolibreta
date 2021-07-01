import 'package:agrolibreta_v2/src/modelos/usuario_model.dart';
import 'package:agrolibreta_v2/src/providers/db_provider.dart';

class UsuarioOperations {
  UsuarioOperations usuarioOperations;

  final dbProvider = DBProvider.db;

//C - crear
  Future<int> nuevoUsuario(RegistroUsuariosModel nuevoUsuario) async {
    final db = await dbProvider.database;
    final res = await db.insert('Usuario', nuevoUsuario.toJson());
    // Es el ID del último registro insertado;
    return res;
  }

//R - leer
  Future<List<RegistroUsuariosModel>> consultarUsuario() async {
    final db = await dbProvider.database;
    final res = await db.query('Usuario');

    return res.isNotEmpty
        ? res.map((s) => RegistroUsuariosModel.fromJson(s)).toList()
        : [];
  }

//U - actualizar
  Future<int> updateUsuarios(RegistroUsuariosModel nuevoUsuario) async {
    final db = await dbProvider.database;
    final res = await db.update('Usuario', nuevoUsuario.toJson(),
        where: 'idUsuario = ?', whereArgs: [nuevoUsuario.idUsuario]);
    return res;
  }

//D - borrar un registro
  Future<int> deleteUsuario(int id) async {
    final db = await dbProvider.database;
    final res =
        await db.delete('Usuario', where: 'idUsuario = ?', whereArgs: [id]);
    return res;
  }

  Future<RegistroUsuariosModel> getUsuarioById(int id) async {
    final db = await dbProvider.database;
    final res =
        await db.query('Usuario', where: 'idUsuario = ?', whereArgs: [id]);
    print(res);
    return res.isNotEmpty ? RegistroUsuariosModel.fromJson(res.first) : null;
  }

  Future<String> password(int id) async {
    final db = await dbProvider.database;
    final res =
        await db.query('Usuario', where: 'idUsuario = ?', whereArgs: [id]);
    RegistroUsuariosModel usuario = new RegistroUsuariosModel();
    String password= '1';
    if (res.isNotEmpty) {
      usuario = RegistroUsuariosModel.fromJson(res.first);
      password = usuario.password.toString();
      return password;
    }
    return password;
  }
}
