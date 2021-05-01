import 'package:agrolibreta_v2/src/modelos/producto_agricola_model.dart';
import 'package:agrolibreta_v2/src/providers/db_provider.dart';

class ProductoAgricolaOperations {
  ProductoAgricolaOperations productoAgricolaOperations;

  final dbProvider = DBProvider.db;

//C - crear
  Future<int> nuevoProductoAgricola(ProductoAgricolaModel nuevoProductoAgricola) async {
    final db = await dbProvider.database;
    final res = await db.insert('ProductosAgricolas', nuevoProductoAgricola.toJson());
    // Es el ID del último registro insertado;
    print('proAgr');
    print(res);
    return res;
  }

//R - leer
  Future<List<ProductoAgricolaModel>> consultarProductosAgricolas() async {
    final db = await dbProvider.database;
    final res = await db.query('ProductosAgricolas');

    return res.isNotEmpty
        ? res.map((s) => ProductoAgricolaModel.fromJson(s)).toList()
        : [];
  }

//U - actualizar
  Future<int> updateProductoAgricolas(ProductoAgricolaModel nuevaProductoAgricola) async {
    final db = await dbProvider.database;
    final res = await db.update('ProductosAgricolas', nuevaProductoAgricola.toJson(),
        where: 'id = ?', whereArgs: [nuevaProductoAgricola.idProductoAgricola]);
    return res;
  }

//D - borrar un registro
  Future<int> deleteProductoAgricola(int id) async {
    final db = await dbProvider.database;
    final res = await db
        .delete('ProductosAgricolas', where: 'idProductoAgricola = ?', whereArgs: [id]);
    return res;
  }

  Future<ProductoAgricolaModel> getProductoAgricolaById(int id) async {
    final db = await dbProvider.database;
    final res = await db.query('ProductosAgricolas', where: 'idProductoAgricola = ?', whereArgs: [id]);

    return res.isNotEmpty ? ProductoAgricolaModel.fromJson(res.first) : null;
  }
}
