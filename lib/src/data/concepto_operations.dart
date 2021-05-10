import 'package:agrolibreta_v2/src/modelos/concepto_model.dart';
import 'package:agrolibreta_v2/src/providers/db_provider.dart';

class ConceptoOperations {
  ConceptoOperations conceptoOperations;

  final dbProvider = DBProvider.db;

//C - crear
  Future<int> nuevoConcepto(ConceptoModel nuevoConcepto) async {
    final db = await dbProvider.database;
    final res = await db.insert('Conceptos', nuevoConcepto.toJson());
    // Es el ID del último registro insertado;
    print(res);
    print('concepto creado');
    return res;
  }

//R - leer
  Future<List<ConceptoModel>> consultarConceptos() async {
    final db = await dbProvider.database;
    final res = await db.query('Conceptos');

    return res.isNotEmpty
        ? res.map((s) => ConceptoModel.fromJson(s)).toList()
        : [];
  }

//U - actualizar
  Future<int> updateConceptos(ConceptoModel nuevoConcepto) async {
    final db = await dbProvider.database;
    final res = await db.update('Conceptos', nuevoConcepto.toJson(),
        where: 'idConcepto = ?', whereArgs: [nuevoConcepto.idConcepto]);
    return res;
  }

//D - borrar un registro
  Future<int> deleteConcepto(int id) async {
    final db = await dbProvider.database;
    final res =
        await db.delete('Conceptos', where: 'idConcepto = ?', whereArgs: [id]);
    return res;
  }

  Future<ConceptoModel> getConceptoById(int id) async {
    final db = await dbProvider.database;
    final res =
        await db.query('Conceptos', where: 'idConcepto = ?', whereArgs: [id]);
    //print(res);
    return res.isNotEmpty ? ConceptoModel.fromJson(res.first) : null;
  }


}
