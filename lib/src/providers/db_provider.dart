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
      await db.execute('''
        CREATE TABLE Ubicaciones(
          idUbicacion INTEGER PRIMARY KEY,
          nombreUbicacion STRING,
          descripcion STRING,
          estado INTEGER
        )
        ''');
      await db.execute('''
          CREATE TABLE EstadosCultivo(
          idEstado INTEGER PRIMARY KEY,
          nombreEstado STRING
        )
      ''');
      await db.execute('''
        CREATE TABLE ProductosAgricolas(
          idProductoAgricola INTEGER PRIMARY KEY,
          nombreProducto STRING
        )
      ''');
      await db.execute('''
        CREATE TABLE Conceptos(
          idConcepto INTEGER PRIMARY KEY,
          nombreConcepto STRING
        )
      ''');
      await db.execute('''
        CREATE TABLE UnidadesMedida(
          idUnidadMedida INTEGER PRIMARY KEY,
          nombreUnidadMedida STRING,
          descripcion STRING
        )
      ''');
      await db.execute('''
        CREATE TABLE ProductosActividades(
          idProductoActividad INTEGER PRIMARY KEY,
          fkidConcepto STRING,
          fkidUnidadMedida STRING,
          nombreProductoActividad STRING,
          FOREIGN KEY (fkidConcepto) REFERENCES Conceptos (idConcepto),
          FOREIGN KEY (fkidUnidadMedida) REFERENCES UnidadesMedida (idUnidadMedida)
        )
      ''');
      await db.execute('''
        CREATE TABLE RegistrosFotograficos(
          idRegistroFotografico INTEGER PRIMARY KEY,
          pathFoto TEXT
        )
      ''');
      await db.execute('''
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
      await db.execute('''
        CREATE TABLE Porcentajes(
          idPorcentaje INTEGER PRIMARY KEY,
          fk2idModeloReferencia STRING,
          fk2idConcepto STRING,
          porcentaje REAL,
          FOREIGN KEY (fk2idModeloReferencia) REFERENCES ModelosReferencia (idModeloReferencia),
          FOREIGN KEY (fk2idConcepto) REFERENCES Conceptos (idConcepto)
        )
      ''');
      await db.execute('''
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
//#################
      await db.rawInsert('''
        INSERT INTO ModelosReferencia(suma) VALUES(0)
      ''');
//#################
      await db.rawInsert('''
        INSERT INTO Conceptos(nombreConcepto) VALUES("semilla")
      ''');
      await db.rawInsert('''
        INSERT INTO Conceptos(nombreConcepto) VALUES("abono y fertilizantes")
      ''');
      await db.rawInsert('''
        INSERT INTO Conceptos(nombreConcepto) VALUES("plaguicidas y herbicidas")
      ''');
      await db.rawInsert('''
        INSERT INTO Conceptos(nombreConcepto) VALUES("empaques")
      ''');
      await db.rawInsert('''
        INSERT INTO Conceptos(nombreConcepto) VALUES("maquinaria")
      ''');
      await db.rawInsert('''
        INSERT INTO Conceptos(nombreConcepto) VALUES("mano de obra")
      ''');
      await db.rawInsert('''
        INSERT INTO Conceptos(nombreConcepto) VALUES("transporte")
      ''');
      await db.rawInsert('''
        INSERT INTO Conceptos(nombreConcepto) VALUES("otros")
      ''');
//#################
      await db.rawInsert('''
        INSERT INTO EstadosCultivo(nombreEstado) VALUES("activo")
      ''');
      await db.rawInsert('''
        INSERT INTO EstadosCultivo(nombreEstado) VALUES("inactivo")
      ''');
      await db.rawInsert('''
        INSERT INTO EstadosCultivo(nombreEstado) VALUES("perdido")
      ''');
//#################
      await db.rawInsert('''
        INSERT INTO UnidadesMedida(nombreUnidadMedida, descripcion) VALUES("kg", "kilogramo")
      ''');
      await db.rawInsert('''
        INSERT INTO UnidadesMedida(nombreUnidadMedida, descripcion) VALUES("bultos", "bultos")
      ''');
      await db.rawInsert('''
        INSERT INTO UnidadesMedida(nombreUnidadMedida, descripcion) VALUES("125 gr", "pepeleta de 125 gr")
      ''');
      await db.rawInsert('''
        INSERT INTO UnidadesMedida(nombreUnidadMedida, descripcion) VALUES("jornal", "8 horas")
      ''');
      await db.rawInsert('''
        INSERT INTO UnidadesMedida(nombreUnidadMedida, descripcion) VALUES("rollo", "rollo de 30 m")
      ''');
//#################
      await db.rawInsert('''
        INSERT INTO Porcentajes(fk2idModeloReferencia, fk2idConcepto, porcentaje) VALUES("1", "1", 3.9)
      ''');
      await db.rawInsert('''
        INSERT INTO Porcentajes(fk2idModeloReferencia, fk2idConcepto, porcentaje) VALUES("1", "2", 17.7)
      ''');
      await db.rawInsert('''
        INSERT INTO Porcentajes(fk2idModeloReferencia, fk2idConcepto, porcentaje) VALUES("1", "3", 12.1)
      ''');
      await db.rawInsert('''
        INSERT INTO Porcentajes(fk2idModeloReferencia, fk2idConcepto, porcentaje) VALUES("1", "4", 6.7)
      ''');
      await db.rawInsert('''
        INSERT INTO Porcentajes(fk2idModeloReferencia, fk2idConcepto, porcentaje) VALUES("1", "5", 6.5)
      ''');
      await db.rawInsert('''
        INSERT INTO Porcentajes(fk2idModeloReferencia, fk2idConcepto, porcentaje) VALUES("1", "6", 46.1)
      ''');
      await db.rawInsert('''
        INSERT INTO Porcentajes(fk2idModeloReferencia, fk2idConcepto, porcentaje) VALUES("1", "7", 1.5)
      ''');
      await db.rawInsert('''
        INSERT INTO Porcentajes(fk2idModeloReferencia, fk2idConcepto, porcentaje) VALUES("1", "8", 5.5)
      ''');
//#################
      await db.rawInsert('''
        INSERT INTO ProductosAgricolas(nombreProducto) VALUES("Arveja")
      ''');
//################
      await db.rawInsert('''
        INSERT INTO ProductosActividades(fkidConcepto, fkidUnidadMedida, nombreProductoActividad) VALUES("2", "2", "gallinaza")
      ''');

      print('base creada');
    });
  }
}
