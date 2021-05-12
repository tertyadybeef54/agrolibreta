import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
    final path = join(documentsDirectory.path, 'Agrolibreta.db');
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
          fechaFinal STRING NOT NULL,
          presupuesto INTEGER NOT NULL,
          precioVentaIdeal REAL NOT NULL,
	        FOREIGN KEY (fkidUbicacion) REFERENCES Ubicaciones (idUbicacion),
	        FOREIGN KEY (fkidEstado) REFERENCES EstadosCultivo (idEstado),
	        FOREIGN KEY (fkidModeloReferencia) REFERENCES ModelosReferencia (idModeloReferencia),
	        FOREIGN KEY (fkidProductoAgricola) REFERENCES ProductosAgricolas (idProductoAgricola)
        )
        ''');
      await db.execute('''
        CREATE TABLE ModelosReferencia(
          idModeloReferencia INTEGER PRIMARY KEY,
          suma REAL NOT NULL
        )
        ''');
      db.execute('''
        CREATE TABLE Ubicaciones(
          idUbicacion INTEGER PRIMARY KEY,
          nombreUbicacion STRING NOT NULL,
          descripcion STRING NOT NULL,
          estado INTEGER NOT NULL
        )
        ''');
      db.execute('''
          CREATE TABLE EstadosCultivo(
          idEstado INTEGER PRIMARY KEY,
          nombreEstado STRING NOT NULL
        )
      ''');
      db.execute('''
        CREATE TABLE ProductosAgricolas(
          idProductoAgricola INTEGER PRIMARY KEY,
          nombreProducto STRING NOT NULL
        )
      ''');
      db.execute('''
        CREATE TABLE Conceptos(
          idConcepto INTEGER PRIMARY KEY,
          nombreConcepto STRING NOT NULL
        )
      ''');
      db.execute('''
        CREATE TABLE UnidadesMedida(
          idUnidadMedida INTEGER PRIMARY KEY,
          nombreUnidadMedida STRING NOT NULL,
          descripcion STRING NOT NULL
        )
      ''');
      db.execute('''
        CREATE TABLE ProductosActividades(
          idProductoActividad INTEGER PRIMARY KEY,
          fkidConcepto STRING NOT NULL,
          fkidUnidadMedida STRING NOT NULL,
          nombreProductoActividad STRING NOT NULL,
          FOREIGN KEY (fkidConcepto) REFERENCES Conceptos (idConcepto),
          FOREIGN KEY (fkidUnidadMedida) REFERENCES UnidadesMedida (idUnidadMedida)
        )
      ''');
      db.execute('''
        CREATE TABLE RegistrosFotograficos(
          idRegistroFotografico INTEGER PRIMARY KEY,
          pathFoto TEXT
        )
      ''');
      db.execute('''
        CREATE TABLE Costos(
          idCosto INTEGER PRIMARY KEY,
          fkidProductoActividad STRING NOT NULL,
          fkidCultivo STRING NOT NULL,
          fkidRegistroFotografico STRING NOT NULL,
          cantidad REAL NOT NULL,
          valorUnidad REAL NOT NULL,
          fecha STRING NOT NULL,
          FOREIGN KEY (fkidProductoActividad) REFERENCES ProductosActividades (idProductoActividad),
          FOREIGN KEY (fkidCultivo) REFERENCES Cultivos (idCultivo),
          FOREIGN KEY (fkidRegistroFotografico) REFERENCES RegistrosFotograficos (idRegistroFotografico)
        )
      ''');
      db.execute('''
        CREATE TABLE Porcentajes(
          idPorcentaje INTEGER PRIMARY KEY,
          fk2idModeloReferencia STRING NOT NULL,
          fk2idConcepto STRING NOT NULL,
          porcentaje REAL NOT NULL,
          FOREIGN KEY (fk2idModeloReferencia) REFERENCES ModelosReferencia (idModeloReferencia),
          FOREIGN KEY (fk2idConcepto) REFERENCES Conceptos (idConcepto)
        )
      ''');
      db.execute('''
        CREATE TABLE Usuario(
        	idUsuario INTEGER PRIMARY KEY,
        	documento INTEGER NOT NULL,
        	password STRING NOT NULL,
        	nombres STRING NOT NULL,
        	apellidos STRING NOT NULL,
        	correo STRING NOT NULL,
        	fechaNacimiento STRING NOT NULL
        ) 
      ''');

      print('base creada');
    });
  }
}
