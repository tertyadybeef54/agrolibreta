import 'package:agrolibreta_v2/src/modelos/porcentaje_model.dart';
import 'package:agrolibreta_v2/src/providers/db_provider.dart';

class PorcentajeOperations {
  PorcentajeOperations porcentajeOperations;

  final dbProvider = DBProvider.db;

//C - crear
  Future<int> nuevoPorcentaje(PorcentajeModel nuevoPorcentaje) async {
    final db = await dbProvider.database;
    final res = await db.insert('Porcentajes', nuevoPorcentaje.toJson());
    // Es el ID del último registro insertado;
    print(res);
    return res;
  }

//R - leer
  Future<List<PorcentajeModel>> consultarPorcentajes() async {
    final db = await dbProvider.database;
    final res = await db.query('Porcentajes');

    return res.isNotEmpty
        ? res.map((s) => PorcentajeModel.fromJson(s)).toList()
        : [];
  }

//U - actualizar
  Future<int> updatePorcentajes(PorcentajeModel nuevoPorcentaje) async {
    final db = await dbProvider.database;
    final res = await db.update('Porcentajes', nuevoPorcentaje.toJson(),
        where: 'id = ?', whereArgs: [nuevoPorcentaje.idPorcentaje]);
    return res;
  }

//D - borrar un registro
  Future<int> deletePorcentaje(int id) async {
    final db = await dbProvider.database;
    final res = await db
        .delete('Porcentajes', where: 'idPorcentaje = ?', whereArgs: [id]);
    return res;
  }
//otros R otras consultas
  Future<PorcentajeModel> getPorcentajeById(int id) async {
    final db = await dbProvider.database;
    final res = await db.query('Porcentajes', where: 'idPorcentaje = ?', whereArgs: [id]);

    return res.isNotEmpty ? PorcentajeModel.fromJson(res.first) : null;
  }
  Future<List<PorcentajeModel>> consultarPorcentajesbyModeloReferencia(String idModeloReferencia) async {
    final db = await dbProvider.database;
    final res = await db.query('Porcentajes', where: 'fk2idModeloReferencia = ?', whereArgs: [idModeloReferencia]);

    return res.isNotEmpty
        ? res.map((s) => PorcentajeModel.fromJson(s)).toList()
        : [];
  }
}