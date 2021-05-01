import 'package:agrolibreta_v2/src/modelos/estado_model.dart';
import 'package:agrolibreta_v2/src/providers/db_provider.dart';

class EstadosOperations {
  EstadosOperations estadosOperations;

  final dbProvider = DBProvider.db;

//C - crear
  Future<int> nuevoEstado(EstadoModel nuevoEstado) async {
    final db = await dbProvider.database;
    final res = await db.insert('EstadosCultivo', nuevoEstado.toJson());
    // Es el ID del último registro insertado;
    print('est');
    print(res);
    return res;
  }

//R - leer
  Future<List<EstadoModel>> consultarEstados() async {
    final db = await dbProvider.database;
    final res = await db.query('EstadosCultivo');

    return res.isNotEmpty
        ? res.map((s) => EstadoModel.fromJson(s)).toList()
        : [];
  }

//U - actualizar
  Future<int> updateEstados(EstadoModel nuevoEstado) async {
    final db = await dbProvider.database;
    final res = await db.update('EstadosCultivo', nuevoEstado.toJson(),
        where: 'id = ?', whereArgs: [nuevoEstado.idEstado]);
    return res;
  }

//D - borrar un registro
  Future<int> deleteEstado(int id) async {
    final db = await dbProvider.database;
    final res =
        await db.delete('Estados', where: 'idEstado = ?', whereArgs: [id]);
    return res;
  }

  Future<EstadoModel> getEstadoById(int id) async {
    final db = await dbProvider.database;
    final res = await db
        .query('EstadosCultivo', where: 'idEstado = ?', whereArgs: [id]);

    return res.isNotEmpty ? EstadoModel.fromJson(res.first) : null;
  }
}
