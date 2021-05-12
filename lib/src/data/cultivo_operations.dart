import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';
import 'package:agrolibreta_v2/src/providers/db_provider.dart';

class CultivoOperations {
  CultivoOperations cultivoOperations;

  final dbProvider = DBProvider.db;

//C - crear
  Future<int> nuevoCultivo(CultivoModel nuevoCultivo) async {
    final db = await dbProvider.database;
    final res = await db.insert('Cultivos', nuevoCultivo.toJson());
    // Es el ID del último registro insertado;
    print('cul');
    print(res);
    return res;
  }

//R - leer
  Future<List<CultivoModel>> consultarCultivos() async {
    final db = await dbProvider.database;
    final res = await db.query('Cultivos');

    return res.isNotEmpty
        ? res.map((s) => CultivoModel.fromJson(s)).toList()
        : [];
  }

//U - actualizar
  Future<int> updateCultivos(CultivoModel nuevoCultivo) async {
    final db = await dbProvider.database;
    final res = await db.update('Cultivos', nuevoCultivo.toJson(),
        where: 'idCultivo = ?', whereArgs: [nuevoCultivo.idCultivo]);
    return res;
  }

//D - borrar un registro
  Future<int> deleteCultivo(int id) async {
    final db = await dbProvider.database;
    final res = await db
        .delete('Cultivos', where: 'idCultivo = ?', whereArgs: [id]);
    return res;
  }

  Future<CultivoModel> getCultivoById(int id) async {
    final db = await dbProvider.database;
    final res = await db.query('Cultivos', where: 'idCultivo = ?', whereArgs: [id]);

    return res.isNotEmpty ? CultivoModel.fromJson(res.first) : null;
  }
  
}
