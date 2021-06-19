import 'package:agrolibreta_v2/src/modelos/costo_model.dart';
import 'package:agrolibreta_v2/src/providers/db_provider.dart';

class CostoOperations {
  CostoOperations costoOperations;

  final dbProvider = DBProvider.db;

//C - crear
  Future<int> nuevoCosto(CostoModel nuevoCosto) async {
    final db = await dbProvider.database;
    final res = await db.insert('Costos', nuevoCosto.toJson());
    // Es el ID del último registro insertado;
    print('cos');
    print(res);
    return res;
  }

//R - leer
  Future<List<CostoModel>> consultarCostos() async {
    final db = await dbProvider.database;
    final res = await db.query('Costos');

    return res.isNotEmpty
        ? res.map((s) => CostoModel.fromJson(s)).toList()
        : [];
  }

//U - actualizar
  Future<int> updateCosto(CostoModel nuevoCosto) async {
    final db = await dbProvider.database;
    final res = await db.update('Costos', nuevoCosto.toJson(),
        where: 'idCosto = ?', whereArgs: [nuevoCosto.idCosto]);
    print('costo actualizado: $res');
    return res;
  }

//D - borrar un registro
  Future<int> deleteCosto(int id) async {
    final db = await dbProvider.database;
    final res =
        await db.delete('Costos', where: 'idCosto = ?', whereArgs: [id]);
    return res;
  }

//otras consultas
  Future<int> updateCostobyImg(int fkidregistroFotografico) async {
    final db = await dbProvider.database;

    final List<Map<String, dynamic>> res = await db.rawQuery('''
      SELECT * FROM Costos WHERE fkidRegistroFotografico = '$fkidregistroFotografico'
    ''');
    List<CostoModel> costos = [];
    if (res.isNotEmpty) {
      costos = res.map((s) => CostoModel.fromJson(s)).toList();
      costos.forEach((costo) async {
        costo.fkidRegistroFotografico = '0';
        final res = await db.update('Costos', costo.toJson(),
            where: 'idCosto = ?', whereArgs: [costo.idCosto]);
        print('costo actualizado: $res');
      });
      return 1;
    }
    return 0;
  }

//costo por id
  Future<CostoModel> getCostoById(int id) async {
    final db = await dbProvider.database;
    final res = await db.query('Costos', where: 'idCosto = ?', whereArgs: [id]);

    return res.isNotEmpty ? CostoModel.fromJson(res.first) : null;
  }

//Suma de costos por concepto
  Future<int> sumaCostosByConcepto(int idCultivo, String idConcepto) async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> res = await db.rawQuery('''

      SELECT * FROM Costos WHERE fkidProductoActividad IN (SELECT idProductoActividad FROM ProductosActividades WHERE fkidConcepto = '$idConcepto') AND fkidCultivo = '$idCultivo'
    
    ''');
    int suma = 0;
    if (res.isNotEmpty) {
      final costos = res.map((s) => CostoModel.fromJson(s)).toList();
      costos.forEach((costo) {
        suma += (costo.cantidad * costo.valorUnidad).round();
      });
    }
    return suma;
  }

  Future<double> getCostoTotalByCultivo(String fkidCultivo) async {
    final db = await dbProvider.database;
    final res = await db
        .query('Costos', where: 'fkidCultivo = ?', whereArgs: [fkidCultivo]);

    double suma = 0.0;
    if (res.isNotEmpty) {
      final List<CostoModel> costos =
          res.map((s) => CostoModel.fromJson(s)).toList();
      costos.forEach((element) {
        suma += element.valorUnidad * element.cantidad;
      });
    }
    return suma;
  }

//consulta para todos los filtros de los costos
  Future<List<CostoModel>> costosFiltrados(
      String fkidCultivo,
      String fechaDesde,
      String fechaHasta,
      String fkidproAct,
      String fkidConcepto) async {
    final db = await dbProvider.database;
//
    //1.aab esta se hace si se indica un cultvio y un producto o actividad, concepto = todos
    if (fkidCultivo != 'todos' &&
        fkidproAct != 'todos' &&
        fkidConcepto == 'todos') {
      final res = await db.rawQuery('''

      SELECT * FROM Costos WHERE fkidProductoActividad = '$fkidproAct' AND fkidCultivo = '$fkidCultivo' AND fecha BETWEEN '$fechaDesde' AND '$fechaHasta' ORDER BY fecha
    
    ''');
      return res.isNotEmpty
          ? res.map((s) => CostoModel.fromJson(s)).toList()
          : [];
    }
//#############################################
    //2.abb esta se hace si se indica el cultivo,  fecha = todas, produc act = todas concep = todos
    if (fkidCultivo != 'todos' &&
        fkidproAct == 'todos' &&
        fkidConcepto == 'todos') {
      final res = await db.rawQuery('''

        SELECT * FROM Costos WHERE fkidCultivo = '$fkidCultivo' AND fecha BETWEEN '$fechaDesde' AND '$fechaHasta' ORDER BY fecha
        
      ''');
      return res.isNotEmpty
          ? res.map((s) => CostoModel.fromJson(s)).toList()
          : [];
    }
    //3.bbb no aplica filtros
    if (fkidCultivo == 'todos' &&
        fkidproAct == 'todos' &&
        fkidConcepto == 'todos') {
      final res = await db.rawQuery('''

        SELECT * FROM Costos WHERE fecha BETWEEN '$fechaDesde' AND '$fechaHasta' ORDER BY fecha
        
      ''');
      return res.isNotEmpty
          ? res.map((s) => CostoModel.fromJson(s)).toList()
          : [];
    }

    //4.bba esta si se indica el concepto, cultivos = todos, producto Act = todos, fecha = todas
    if (fkidCultivo == 'todos' &&
        fkidproAct == 'todos' &&
        fkidConcepto != 'todos') {
      final res = await db.rawQuery('''

        SELECT * FROM Costos WHERE fkidProductoActividad IN (SELECT idProductoActividad FROM ProductosActividades WHERE fkidConcepto = '$fkidConcepto') AND fecha BETWEEN '$fechaDesde' AND '$fechaHasta' ORDER BY fecha
      
      ''');
      return res.isNotEmpty
          ? res.map((s) => CostoModel.fromJson(s)).toList()
          : [];
    }

    //5.baa esta definido prodAct, concepto, cultivo = todos
    if (fkidCultivo == 'todos' &&
        fkidproAct != 'todos' &&
        fkidConcepto != 'todos') {
      final res = await db.rawQuery('''

        SELECT * FROM Costos WHERE fkidProductoActividad IN (SELECT idProductoActividad FROM ProductosActividades WHERE fkidConcepto = '$fkidConcepto') AND fkidProductoActividad = '$fkidproAct' AND fecha BETWEEN '$fechaDesde' AND '$fechaHasta' ORDER BY fecha
      
      ''');
      return res.isNotEmpty
          ? res.map((s) => CostoModel.fromJson(s)).toList()
          : [];
    }

    //7.aba esta si se indica el concepto y el cultivo , producto act = todas
    if (fkidCultivo != 'todos' &&
        fkidproAct == 'todos' &&
        fkidConcepto != 'todos') {
      final res = await db.rawQuery('''

        SELECT * FROM Costos WHERE fkidProductoActividad IN (SELECT idProductoActividad FROM ProductosActividades WHERE fkidConcepto = '$fkidConcepto') AND fkidCultivo = '$fkidCultivo' AND fecha BETWEEN '$fechaDesde' AND '$fechaHasta' ORDER BY fecha
      
      ''');
      return res.isNotEmpty
          ? res.map((s) => CostoModel.fromJson(s)).toList()
          : [];
    }
    //8.aba esta si se indica el concepto y el cultivo , producto act = todas
    if (fkidCultivo == 'todos' &&
        fkidproAct != 'todos' &&
        fkidConcepto == 'todos') {
      final res = await db.rawQuery('''

        SELECT * FROM Costos WHERE fkidProductoActividad = '$fkidproAct' AND fecha BETWEEN '$fechaDesde' AND '$fechaHasta' ORDER BY fecha
      
      ''');
      return res.isNotEmpty
          ? res.map((s) => CostoModel.fromJson(s)).toList()
          : [];
    }

    //6.aaa si se indican el cultivo, producAtc, concepto y fechas
    final res = await db.rawQuery('''

        SELECT * FROM Costos WHERE fkidProductoActividad IN (SELECT idProductoActividad FROM ProductosActividades WHERE fkidConcepto = '$fkidConcepto') AND fkidCultivo = '$fkidCultivo' AND fkidProductoActividad = '$fkidproAct' AND fecha BETWEEN '$fechaDesde' AND '$fechaHasta' ORDER BY fecha
      
      ''');

    return res.isNotEmpty
        ? res.map((s) => CostoModel.fromJson(s)).toList()
        : [];
  }

//consulttar si el costo pertenece al registro fotografico

  Future<bool> registroFotografico() async {
    bool pertenece = false;
    return pertenece;
  }

  Future<List<CostoModel>> costosByRegisto(String fkidRegistro) async {
    final db = await dbProvider.database;
    final res = await db.rawQuery('''
      SELECT * FROM Costos WHERE fkidRegistroFotografico = $fkidRegistro
    ''');

    return res.isNotEmpty
        ? res.map((s) => CostoModel.fromJson(s)).toList()
        : [];
  }
}
