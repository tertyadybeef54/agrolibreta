import 'package:agrolibreta_v2/src/modelos/registro_fotografico_model.dart';
import 'package:agrolibreta_v2/src/providers/db_provider.dart';

class RegistroFotograficoOperations {
  RegistroFotograficoOperations registroFotograficoOperations;

  final dbProvider = DBProvider.db;

//C - crear
  Future<int> nuevoRegistroFotografico(RegistroFotograficoModel nuevoRegistroFotografico) async {
    final db = await dbProvider.database;
    final res = await db.insert('RegistrosFotograficos', nuevoRegistroFotografico.toJson());
    // Es el ID del último registro insertado;
    print(res);
    return res;
  }

//R - leer
  Future<List<RegistroFotograficoModel>> consultarRegistrosFotograficos() async {
    final db = await dbProvider.database;
    final res = await db.query('RegistrosFotograficos');

    return res.isNotEmpty
        ? res.map((s) => RegistroFotograficoModel.fromJson(s)).toList()
        : [];
  }

//U - actualizar
  Future<int> updateRegistrosFotograficos(RegistroFotograficoModel nuevoRegistroFotografico) async {
    final db = await dbProvider.database;
    final res = await db.update('RegistrosFotograficos', nuevoRegistroFotografico.toJson(),
        where: 'idRegistroFotografico = ?', whereArgs: [nuevoRegistroFotografico.idRegistroFotografico]);
    return res;
  }

//D - borrar un registro
  Future<int> deleteRegistroFotografico(int id) async {
    final db = await dbProvider.database;
    final res = await db
        .delete('RegistrosFotograficos', where: 'idRegistroFotografico = ?', whereArgs: [id]);
    return res;
  }

  Future<RegistroFotograficoModel> getRegistroFotograficoById(int id) async {
    final db = await dbProvider.database;
    final res = await db.query('RegistrosFotograficos', where: 'idRegistroFotografico = ?', whereArgs: [id]);

    return res.isNotEmpty ? RegistroFotograficoModel.fromJson(res.first) : null;
  }
}
