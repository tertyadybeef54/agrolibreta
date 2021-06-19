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
    print('por');
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
        where: 'idPorcentaje = ?', whereArgs: [nuevoPorcentaje.idPorcentaje]);
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
    final res = await db
        .query('Porcentajes', where: 'idPorcentaje = ?', whereArgs: [id]);

    return res.isNotEmpty ? PorcentajeModel.fromJson(res.first) : null;
  }

  Future<List<PorcentajeModel>> consultarPorcentajesbyModeloReferencia(
      String idModeloReferencia) async {
    final db = await dbProvider.database;
    final res = await db.query('Porcentajes',
        where: 'fk2idModeloReferencia = ?', whereArgs: [idModeloReferencia]);

    return res.isNotEmpty
        ? res.map((s) => PorcentajeModel.fromJson(s)).toList()
        : [];
  }

  Future<int> getPorcenByMRyConcep(
      String fkidMR, String fkidCon, int presupuesto) async {
    final db = await dbProvider.database;
    final res = await db.rawQuery('''
      SELECT * FROM Porcentajes WHERE fk2idModeloReferencia == $fkidMR AND fk2idConcepto == $fkidCon
    ''');
    int valor = 0;
    
    if(res.isNotEmpty){
      final porcentaje = PorcentajeModel.fromJson(res.first);
      valor = (porcentaje.porcentaje * presupuesto * 0.01).round();
    }

    return valor;
  }
 
  //D - borrar un registros
  Future<int> deletePorcentajeByMR(int idMr) async {
    final db = await dbProvider.database;
    final res = await db
        .delete('Porcentajes', where: 'fk2idModeloReferencia = ?', whereArgs: [idMr]);
    return res;
  }
}
