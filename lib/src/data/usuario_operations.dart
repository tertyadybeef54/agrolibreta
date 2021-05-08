import 'package:agrolibreta_v2/src/providers/db_provider.dart';

class UsuarioOperations {
  UsuarioOperations usuarioOperations;

  final dbProvider = DBProvider.db;

//C - crear
/*   Future<int> nuevoUsuario(UsuarioModel nuevoUsuario) async {
    final db = await dbProvider.database;
    final res = await db.insert('Usuarios', nuevoUsuario.toJson());
    // Es el ID del último registro insertado;
    print(res);
    print('concepto creado');
    return res;
  }

//R - leer
  Future<List<UsuarioModel>> consultarConceptos() async {
    final db = await dbProvider.database;
    final res = await db.query('Usuarios');

    return res.isNotEmpty
        ? res.map((s) => UsuarioModel.fromJson(s)).toList()
        : [];
  }

//U - actualizar
  Future<int> updateConceptos(UsuarioModel nuevoUsuario) async {
    final db = await dbProvider.database;
    final res = await db.update('Usuarios', nuevoUsuario.toJson(),
        where: 'idUsuario = ?', whereArgs: [nuevoUsuario.idUsuario]);
    return res;
  }

//D - borrar un registro
  Future<int> deleteConcepto(int id) async {
    final db = await dbProvider.database;
    final res =
        await db.delete('Usuarios', where: 'idUsuario = ?', whereArgs: [id]);
    return res;
  }

  Future<UsuarioModel> getConceptoById(int id) async {
    final db = await dbProvider.database;
    final res =
        await db.query('Usuarios', where: 'idUsuario = ?', whereArgs: [id]);
    print(res);
    return res.isNotEmpty ? UsuarioModel.fromJson(res.first) : null;
  } */
}
