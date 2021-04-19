import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
export 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';
export 'package:agrolibreta_v2/src/modelos/ubicacion_model.dart';
export 'package:agrolibreta_v2/src/modelos/modelo_referencia_model.dart';
export 'package:agrolibreta_v2/src/modelos/estado_model.dart';
export 'package:agrolibreta_v2/src/modelos/producto_agricola_model.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  Future<Database> initDB() async {
    // Path de donde almacenaremos la base de datos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'Agrolibreta2.db');
    print(path);
    // Crear base de datos
    return await openDatabase(path, version: 2, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      print('crear base');
      await db.execute('''

        CREATE TABLE Cultivos(
          idCultivo INTEGER PRIMARY KEY AUTOINCREMENT,
          fkidUbicacion STRING NOT NULL,
          fkidEstado STRING NOT NULL,
          fkidModeloReferencia STRING NOT NULL,
          fkidProductoAgricola STRING NOT NULL,
          nombreDistintivo STRING NOT NULL,
          areaSembrada REAL NOT NULL,
          fechaInicio STRING NOT NULL,
          fechaFinal STRING ,
          presupuesto INTEGER NOT NULL,
          precioVentaIdeal REAL ,
	        FOREIGN KEY (fkidUbicacion) REFERENCES Ubicaciones (idUbicacion),
	        FOREIGN KEY (fkidEstado) REFERENCES EstadosCultivo (idEstado),
	        FOREIGN KEY (fkidModeloReferencia) REFERENCES ModelosReferencia (idModeloReferencia),
	        FOREIGN KEY (fkidProductoAgricola) REFERENCES ProductosAgricolas (idProductoAgricola)
        )
        ''');
      await db.execute('''

        CREATE TABLE ModelosReferencia(
          idModeloReferencia INTEGER PRIMARY KEY,
          suma REAL
        )
        ''');
      db.execute('''
        CREATE TABLE Ubicaciones(
          idUbicacion INTEGER PRIMARY KEY,
          nombreUbicacion STRING,
          descripcion STRING,
          estado INTEGER
        )
        ''');
      db.execute('''
          CREATE TABLE EstadosCultivo(
          idEstado INTEGER PRIMARY KEY,
          nombreEstado STRING
        )
      ''');
      db.execute('''

        CREATE TABLE ProductosAgricolas(
          idProductoAgricola INTEGER PRIMARY KEY,
          nombreProducto STRING
        )
      ''');
      print('base creada');
    });
  }
}
