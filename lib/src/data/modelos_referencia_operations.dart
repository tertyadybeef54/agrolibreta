import 'package:agrolibreta_v2/src/providers/db_provider.dart';

//CRUD PARA Ubicacaciones
class ModelosReferenciaOperations {
  ModelosReferenciaOperations modelosReferenciaOperations;

  final dbProvider = DBProvider.db;

//C - crear
  Future<int> nuevoModeloReferencia(
      ModeloReferenciaModel nuevoModeloReferencia) async {
    final db = await dbProvider.database;
    final res =
        await db.insert('ModelosReferencia', nuevoModeloReferencia.toJson());
    // Es el ID del último registro insertado;
    print(res);
    return res;
  }

//R - leer
  Future<List<ModeloReferenciaModel>> consultarModelosReferencia() async {
    final db = await dbProvider.database;
    final res = await db.query('ModelosReferencia');

    return res.isNotEmpty
        ? res.map((s) => ModeloReferenciaModel.fromJson(s)).toList()
        : [];
  }

//U - actualizar
  Future<int> updateModelosReferencia(
      ModeloReferenciaModel nuevoModeloReferencia) async {
    final db = await dbProvider.database;
    final res = await db.update(
        'ModelosReferencia', nuevoModeloReferencia.toJson(),
        where: 'id = ?', whereArgs: [nuevoModeloReferencia.idModeloReferencia]);
    return res;
  }

//D - borrar un registro
  Future<int> deleteModeloReferencia(int id) async {
    final db = await dbProvider.database;
    final res = await db.delete('ModelosReferencia',
        where: 'idModeloReferencia = ?', whereArgs: [id]);
    print('eliminado');
    return res;
  }
}