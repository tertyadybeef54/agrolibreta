import 'package:agrolibreta_v2/src/modelos/ubicacion_model.dart';
import 'package:agrolibreta_v2/src/providers/db_provider.dart';

//CRUD PARA Ubicacaciones
class UbicacionesOperations {
  UbicacionesOperations ubicacionesOperations;

  final dbProvider = DBProvider.db;

//C - crear
  Future<int> nuevaUbicacion(UbicacionModel nuevaUbicacion) async {
    final db = await dbProvider.database;
    final res = await db.insert('Ubicaciones', nuevaUbicacion.toJson());
    // Es el ID del último registro insertado;
    print(res);
    return res;
  }

//R - leer
  Future<List<UbicacionModel>> consultarUbicaciones() async {
    final db = await dbProvider.database;
    final res = await db.query('Ubicaciones');

    return res.isNotEmpty
        ? res.map((s) => UbicacionModel.fromJson(s)).toList()
        : [];
  }

//U - actualizar
  Future<int> updateUbicaciones(UbicacionModel nuevaUbicacion) async {
    final db = await dbProvider.database;
    final res = await db.update('Ubicaciones', nuevaUbicacion.toJson(),
        where: 'idUbicacion = ?', whereArgs: [nuevaUbicacion.idUbicacion]);
    return res;
  }

//D - borrar un registro
  Future<int> deleteUbicacion(int id) async {
    final db = await dbProvider.database;
    final res = await db
        .delete('Ubicaciones', where: 'idUbicacion = ?', whereArgs: [id]);
    return res;
  }
  Future<UbicacionModel> getUbicacionById(String id) async {
    final db = await dbProvider.database;
    final res = await db.query('Ubicaciones', where: 'idUbicacion = ?', whereArgs: [id]);

    return res.isNotEmpty ? UbicacionModel.fromJson(res.first) : null;
  }
}
