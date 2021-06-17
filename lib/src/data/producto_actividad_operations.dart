import 'package:agrolibreta_v2/src/modelos/producto_actividad_model.dart';
import 'package:agrolibreta_v2/src/modelos/unidad_medida_model.dart';
import 'package:agrolibreta_v2/src/providers/db_provider.dart';

class ProductoActividadOperations {
  ProductoActividadOperations productoActividadOperations;

  final dbProvider = DBProvider.db;

//C - crear
  Future<int> nuevoProductoActividad(
      ProductoActividadModel nuevoProductoActividad) async {
    final db = await dbProvider.database;
    final res = await db.insert(
        'ProductosActividades', nuevoProductoActividad.toJson());
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

  Future<List<ProductoActividadModel>> consultarProductosActividadesOrder() async {
    final db = await dbProvider.database;
    final res = await db.rawQuery('''
      SELECT *FROM ProductosActividades ORDER BY nombreProductoActividad
    ''');

    return res.isNotEmpty
        ? res.map((s) => ProductoActividadModel.fromJson(s)).toList()
        : [];
  }

//U - actualizar
  Future<int> updateProductosActividades(
      ProductoActividadModel nuevoProductoActividad) async {
    final db = await dbProvider.database;
    final res = await db.update(
        'ProductosActividades', nuevoProductoActividad.toJson(),
        where: 'idProductoActividade = ?',
        whereArgs: [nuevoProductoActividad.idProductoActividad]);
    return res;
  }

//D - borrar un registro
  Future<int> deleteProductoActividad(int id) async {
    final db = await dbProvider.database;
    final res = await db.delete('ProductosActividades',
        where: 'idProductoActividad = ?', whereArgs: [id]);
    return res;
  }

  Future<ProductoActividadModel> getProductoActividadById(int id) async {
    final db = await dbProvider.database;
    final res = await db.query('ProductosActividades',
        where: 'idProductoActividad = ?', whereArgs: [id]);

    return res.isNotEmpty ? ProductoActividadModel.fromJson(res.first) : null;
  }

  Future<String> consultarNombre(String fkProdAct) async {
    final db = await dbProvider.database;
    final res = await db.rawQuery('''
    SELECT * FROM ProductosActividades WHERE idProductoActividad = $fkProdAct
    ''');
    String nombre = 'nn';
    if (res.isNotEmpty) {
      final costo = ProductoActividadModel.fromJson(res.first);
      nombre = costo.nombreProductoActividad;
    }
    return nombre;
  }
  //consultar en nombre de la unidad de medida que pertenece al costo
    Future<String> consultarNombreUnidad(String fkProdAct) async {
    final db = await dbProvider.database;
    final res = await db.rawQuery('''
    SELECT * FROM UnidadesMedida WHERE idUnidadMedida IN (SELECT fkidUnidadMedida FROM ProductosActividades WHERE idProductoActividad = $fkProdAct)
    ''');
    String unidad = 'nn';
    if (res.isNotEmpty) {
      final unidadTemp = UnidadMedidaModel.fromJson(res.first);
      unidad = unidadTemp.nombreUnidadMedida;
    }
    return unidad;
  }
}
