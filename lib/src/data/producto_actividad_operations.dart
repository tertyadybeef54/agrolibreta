import 'package:agrolibreta_v2/src/modelos/costo_model.dart';
import 'package:agrolibreta_v2/src/providers/db_provider.dart';

class CostoOperations {
  CostoOperations costoOperations;

  final dbProvider = DBProvider.db;

//C - crear
  Future<int> nuevoCosto(CostoModel nuevoCosto) async {
    final db = await dbProvider.database;
    final res = await db.insert('Costos', nuevoCosto.toJson());
    // Es el ID del último registro insertado;
    print(res);
    return res;
  }

//R - leer
  Future<List<CostoModel>> consultarCostos() async {
    final db = await dbProvider.database;
    final res = await db.query('Costos');

    return res.isNotEmpty
        ? res.map((s) => CostoModel.fromJson(s)).toList()
        : [];
  }

//U - actualizar
  Future<int> updateCostos(CostoModel nuevoCosto) async {
    final db = await dbProvider.database;
    final res = await db.update('Costos', nuevoCosto.toJson(),
        where: 'id = ?', whereArgs: [nuevoCosto.idCosto]);
    return res;
  }

//D - borrar un registro
  Future<int> deleteCosto(int id) async {
    final db = await dbProvider.database;
    final res = await db
        .delete('Costos', where: 'idCosto = ?', whereArgs: [id]);
    return res;
  }

  Future<CostoModel> getCostoById(int id) async {
    final db = await dbProvider.database;
    final res = await db.query('Costos', where: 'idCosto = ?', whereArgs: [id]);

    return res.isNotEmpty ? CostoModel.fromJson(res.first) : null;
  }
}
