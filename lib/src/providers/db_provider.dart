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
    final path = join(documentsDirectory.path, 'Agrolibreta1.db');
    print(path);
    // Crear base de datos
    return await openDatabase(path, version: 1, onOpen: (db) {},
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
      db.execute('''
        CREATE TABLE Conceptos(
          idConcepto INTEGER PRIMARY KEY,
          nombreConcepto STRING
        )
      ''');
      db.execute('''
        CREATE TABLE UnidadesMedida(
          idUnidadMedida INTEGER PRIMARY KEY,
          nombreUnidadMedida STRING,
          descripcion STRING
        )
      ''');
      db.execute('''
        CREATE TABLE ProductosActividades(
          idProductoActividad INTEGER PRIMARY KEY,
          fkidConcepto STRING,
          fkidUnidadMedida STRING,
          nombreProductoActividad STRING,
          FOREIGN KEY (fkidConcepto) REFERENCES Conceptos (idConcepto),
          FOREIGN KEY (fkidUnidadMedida) REFERENCES UnidadesMedida (idUnidadMedida)
        )
      ''');
      db.execute('''
        CREATE TABLE RegistrosFotograficos(
          idRegistroFotografico INTEGER PRIMARY KEY,
          pathFoto STRING
        )
      ''');
      db.execute('''
        CREATE TABLE Costos(
          idCosto INTEGER PRIMARY KEY,
          fkidProductoActividad STRING,
          fkidCultivo STRING,
          fkidRegistroFotografico STRING,
          cantidad REAL,
          valorUnidad REAL,
          fecha STRING,
          FOREIGN KEY (fkidProductoActividad) REFERENCES ProductosActividades (idProductoActividad),
          FOREIGN KEY (fkidCultivo) REFERENCES Cultivos (idCultivo),
          FOREIGN KEY (fkidRegistroFotografico) REFERENCES RegistrosFotograficos (idRegistroFotografico)
        )
      ''');
      db.execute('''
        CREATE TABLE Porcentajes(
          idPorcentaje INTEGER PRIMARY KEY,
          fk2idModeloReferencia STRING,
          fk2idConcepto STRING,
          porcentaje REAL,
          FOREIGN KEY (fk2idModeloReferencia) REFERENCES ModelosReferencia (idModeloReferencia),
          FOREIGN KEY (fk2idConcepto) REFERENCES Conceptos (idConcepto)
        )
      ''');
      db.execute('''
        CREATE TABLE Usuario(
        	idUsuario INTEGER PRIMARY KEY,
        	documento INTEGER,
        	password STRING,
        	nombres STRING,
        	apellidos STRING,
        	correo STRING,
        	fechaNacimiento STRING
        ) 
      ''');

      print('base creada');
    });
  }
}
