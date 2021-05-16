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
  Future<int> updateCostos(CostoModel nuevoCosto) async {
    final db = await dbProvider.database;
    final res = await db.update('Costos', nuevoCosto.toJson(),
        where: 'idCostos = ?', whereArgs: [nuevoCosto.idCosto]);
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
//costo por id
  Future<CostoModel> getCostoById(int id) async {
    final db = await dbProvider.database;
    final res = await db.query('Costos', where: 'idCosto = ?', whereArgs: [id]);

    return res.isNotEmpty ? CostoModel.fromJson(res.first) : null;
  }

//Suma de costos por concepto
  Future<double> sumaCostosByConcepto(int idCultivo, String idConcepto) async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> res = await db.rawQuery('''

      SELECT * FROM Costos WHERE fkidProductoActividad IN (SELECT idProductoActividad FROM ProductosActividades WHERE fkidConcepto = '$idConcepto') AND fkidCultivo = '$idCultivo'
    
    ''');
    double suma = 0;
    if (res.isNotEmpty) {
      final costos = res.map((s) => CostoModel.fromJson(s)).toList();
      costos.forEach((costo) {
        suma += costo.cantidad * costo.valorUnidad;
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

  Future<List<CostoModel>> costosFiltrados(
      String fkidCultivo,
      String fechaDesde,
      String fechaHasta,
      String fkidproAct,
      String fkidConcepto) async {
    final db = await dbProvider.database;

    //1. esta se hace si se indica un cultvio y un producto o actividad, concepto = todos
    if (fkidCultivo != 'todos' &&
        fkidproAct != 'todos' &&
        fkidConcepto == 'todos') {
      final res = await db.rawQuery('''

      SELECT * FROM Costos WHERE fkidProductoActividad = '$fkidproAct' AND fkidCultivo = '$fkidCultivo' 
    
    ''');
        return res.isNotEmpty
      ? res.map((s) => CostoModel.fromJson(s)).toList()
      : [];
    }

    //2. esta se hace si se indica el cultivo,  fecha = todas, produc act = todas concep = todos
    if (fkidCultivo != 'todos' &&
        fkidproAct == 'todos' &&
        fkidConcepto == 'todos') {
      final res = await db.rawQuery('''

        SELECT * FROM Costos WHERE fkidCultivo = '$fkidCultivo'
        
      ''');
          return res.isNotEmpty
      ? res.map((s) => CostoModel.fromJson(s)).toList()
      : [];
    }
    //3. no aplica filtros
    if (fkidCultivo == 'todos' &&
        fkidproAct == 'todos' &&
        fkidConcepto == 'todos') {
      final res = await db.rawQuery('''

        SELECT * FROM Costos
        
      ''');
          return res.isNotEmpty
      ? res.map((s) => CostoModel.fromJson(s)).toList()
      : [];
    }

    //4. esta si se indica el concepto, cultivos = todos, producto Act = todos, fecha = todas
    if (fkidCultivo == 'todos' &&
        fkidproAct == 'todos' &&
        fkidConcepto != 'todos') {
      final res = await db.rawQuery('''

        SELECT * FROM Costos WHERE fkidProductoActividad IN (SELECT idProductoActividad FROM ProductosActividades WHERE fkidConcepto = '$fkidConcepto')
      
      ''');
          return res.isNotEmpty
      ? res.map((s) => CostoModel.fromJson(s)).toList()
      : [];
    }

    //5. esta si se indica el concepto y el cultivo , producto act = todas
    if (fkidCultivo != 'todos' &&
        fkidproAct == 'todos' &&
        fkidConcepto != 'todos') {
      final res = await db.rawQuery('''

        SELECT * FROM Costos WHERE fkidProductoActividad IN (SELECT idProductoActividad FROM ProductosActividades WHERE fkidConcepto = '$fkidConcepto') AND fkidCultivo = '$fkidCultivo'
      
      ''');
          return res.isNotEmpty
      ? res.map((s) => CostoModel.fromJson(s)).toList()
      : [];
    }

    //6. si se indican el cultivo, producAtc, concepto y fechas todas
    // if (fkidCultivo == 'todos' &&
    //     fkidproAct == 'todos' &&
    //     fkidConcepto == 'todos') {
      final res = await db.rawQuery('''

        SELECT * FROM Costos WHERE fkidProductoActividad IN (SELECT idProductoActividad FROM ProductosActividades WHERE fkidConcepto = '$fkidConcepto') AND fkidCultivo = '$fkidCultivo' AND fkidProductoActividad = '$fkidproAct'
      
      ''');

    return res.isNotEmpty
      ? res.map((s) => CostoModel.fromJson(s)).toList()
      : [];
    //}
  }

  Future<List<CostoModel>> costosFecha(
      String fechaDesde, String fechaHasta) async {
    final db = await dbProvider.database;

    final res = await db.rawQuery('''

      SELECT * FROM Costos WHERE  fecha >= DATE($fechaDesde) AND fecha <= DATE($fechaHasta)
    
    ''');

    return res.isNotEmpty
      ? res.map((s) => CostoModel.fromJson(s)).toList()
      : [];

  }
}
