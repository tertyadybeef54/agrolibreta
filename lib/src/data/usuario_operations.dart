import 'package:agrolibreta_v2/src/modelos/registro_usuarios_model.dart';
import 'package:agrolibreta_v2/src/providers/db_provider.dart';

class UsuarioOperations {
  UsuarioOperations usuarioOperations;

  final dbProvider = DBProvider.db;

//C - crear
   Future<int> nuevoUsuario(RegistroUsuariosModel nuevoUsuario) async {
    final db = await dbProvider.database;
    final res = await db.insert('Usuarios', nuevoUsuario.toJson());
    // Es el ID del último registro insertado;
    print(res);
    print('Usuario creado');
    return res;
  }

//R - leer
  Future<List<RegistroUsuariosModel>> consultarUsuario() async {
    final db = await dbProvider.database;
    final res = await db.query('Usuarios');

    return res.isNotEmpty
        ? res.map((s) => RegistroUsuariosModel.fromJson(s)).toList()
        : [];
  }

//U - actualizar
  Future<int> updateUsuarios(RegistroUsuariosModel nuevoUsuario) async {
    final db = await dbProvider.database;
    final res = await db.update('Usuarios', nuevoUsuario.toJson(),
        where: 'idUsuario = ?', whereArgs: [nuevoUsuario.idUsuario]);
    return res;
  }

//D - borrar un registro
  Future<int> deleteUsuario(int id) async {
    final db = await dbProvider.database;
    final res =
        await db.delete('Usuarios', where: 'idUsuario = ?', whereArgs: [id]);
    return res;
  }

  Future<RegistroUsuariosModel> getUsuarioById(int id) async {
    final db = await dbProvider.database;
    final res =
        await db.query('Usuarios', where: 'idUsuario = ?', whereArgs: [id]);
    print(res);
    return res.isNotEmpty ? RegistroUsuariosModel.fromJson(res.first) : null;
  }
}
