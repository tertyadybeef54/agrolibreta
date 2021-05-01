import 'package:agrolibreta_v2/src/modelos/producto_actividad_model.dart';
import 'package:agrolibreta_v2/src/providers/db_provider.dart';

class ProductoActividadOperations {
  ProductoActividadOperations productoActividadOperations;

  final dbProvider = DBProvider.db;

//C - crear
  Future<int> nuevoProductoActividad(ProductoActividadModel nuevoProductoActividad) async {
    final db = await dbProvider.database;
    final res = await db.insert('ProductosActividades', nuevoProductoActividad.toJson());
    // Es el ID del último registro insertado;
    print('proAct creada');
    print(res);
    return res;
  }

//R - leer
  Future<List<ProductoActividadModel>> consultarProductosActividades() async {
    final db = await dbProvider.database;
    final res = await db.query('ProductosActividades');

    return res.isNotEmpty
        ? res.map((s) => ProductoActividadModel.fromJson(s)).toList()
        : [];
  }

//U - actualizar
  Future<int> updateProductosActividades(ProductoActividadModel nuevoProductoActividad) async {
    final db = await dbProvider.database;
    final res = await db.update('ProductosActividades', nuevoProductoActividad.toJson(),
        where: 'id = ?', whereArgs: [nuevoProductoActividad.idProductoActividad]);
    return res;
  }

//D - borrar un registro
  Future<int> deleteProductoActividad(int id) async {
    final db = await dbProvider.database;
    final res = await db
        .delete('ProductosActividades', where: 'idProductoActividad = ?', whereArgs: [id]);
    return res;
  }

  Future<ProductoActividadModel> getProductoActividadById(int id) async {
    final db = await dbProvider.database;
    final res = await db.query('ProductosActividades', where: 'idProductoActividad = ?', whereArgs: [id]);

    return res.isNotEmpty ? ProductoActividadModel.fromJson(res.first) : null;
  }
}
