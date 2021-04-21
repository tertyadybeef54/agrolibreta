import 'package:agrolibreta_v2/src/modelos/unidad_medida_model.dart';
import 'package:agrolibreta_v2/src/providers/db_provider.dart';

class UnidadMedidaOperations {
  UnidadMedidaOperations unidadMedidaOperations;

  final dbProvider = DBProvider.db;

//C - crear
  Future<int> nuevoUnidadMedida(UnidadMedidaModel nuevoUnidadMedida) async {
    final db = await dbProvider.database;
    final res = await db.insert('UnidadesMedida', nuevoUnidadMedida.toJson());
    // Es el ID del último registro insertado;
    print(res);
    print('unidad me creada');
    return res;
  }

//R - leer
  Future<List<UnidadMedidaModel>> consultarUnidadesMedida() async {
    final db = await dbProvider.database;
    final res = await db.query('UnidadesMedida');

    return res.isNotEmpty
        ? res.map((s) => UnidadMedidaModel.fromJson(s)).toList()
        : [];
  }

//U - actualizar
  Future<int> updateUnidadesMedida(UnidadMedidaModel nuevoUnidadMedida) async {
    final db = await dbProvider.database;
    final res = await db.update('UnidadesMedida', nuevoUnidadMedida.toJson(),
        where: 'id = ?', whereArgs: [nuevoUnidadMedida.idUnidadMedida]);
    return res;
  }

//D - borrar un registro
  Future<int> deleteUnidadMedida(int id) async {
    final db = await dbProvider.database;
    final res = await db
        .delete('UnidadesMedida', where: 'idUnidadMedida = ?', whereArgs: [id]);
    return res;
  }

  Future<UnidadMedidaModel> getUnidadMedidaById(int id) async {
    final db = await dbProvider.database;
    final res = await db
        .query('UnidadesMedida', where: 'idUnidadMedida = ?', whereArgs: [id]);

    return res.isNotEmpty ? UnidadMedidaModel.fromJson(res.first) : null;
  }
}
