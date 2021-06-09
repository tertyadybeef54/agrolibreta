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
          suma REAL NOT NULL
        )
        ''');
      await db.execute('''
        CREATE TABLE Ubicaciones(
          idUbicacion INTEGER PRIMARY KEY,
          nombreUbicacion STRING NOT NULL,
          descripcion STRING NOT NULL,
          estado INTEGER NOT NULL
        )
        ''');
      await db.execute('''
          CREATE TABLE EstadosCultivo(
          idEstado INTEGER PRIMARY KEY,
          nombreEstado STRING NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE ProductosAgricolas(
          idProductoAgricola INTEGER PRIMARY KEY,
          nombreProducto STRING NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE Conceptos(
          idConcepto INTEGER PRIMARY KEY,
          nombreConcepto STRING NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE UnidadesMedida(
          idUnidadMedida INTEGER PRIMARY KEY,
          nombreUnidadMedida STRING NOT NULL,
          descripcion STRING NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE ProductosActividades(
          idProductoActividad INTEGER PRIMARY KEY,
          fkidConcepto STRING NOT NULL,
          fkidUnidadMedida STRING NOT NULL,
          nombreProductoActividad STRING NOT NULL,
          FOREIGN KEY (fkidConcepto) REFERENCES Conceptos (idConcepto),
          FOREIGN KEY (fkidUnidadMedida) REFERENCES UnidadesMedida (idUnidadMedida)
        )
      ''');
      await db.execute('''
        CREATE TABLE RegistrosFotograficos(
          idRegistroFotografico INTEGER PRIMARY KEY,
          pathFoto TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE Costos(
          idCosto INTEGER PRIMARY KEY,
          fkidProductoActividad STRING NOT NULL,
          fkidCultivo STRING NOT NULL,
          fkidRegistroFotografico STRING NOT NULL,
          cantidad REAL NOT NULL,
          valorUnidad REAL NOT NULL,
          fecha INTEGER NOT NULL,
          FOREIGN KEY (fkidProductoActividad) REFERENCES ProductosActividades (idProductoActividad),
          FOREIGN KEY (fkidCultivo) REFERENCES Cultivos (idCultivo),
          FOREIGN KEY (fkidRegistroFotografico) REFERENCES RegistrosFotograficos (idRegistroFotografico)
        )
      ''');
      await db.execute('''
        CREATE TABLE Porcentajes(
          idPorcentaje INTEGER PRIMARY KEY,
          fk2idModeloReferencia STRING NOT NULL,
          fk2idConcepto STRING NOT NULL,
          porcentaje REAL NOT NULL,
          FOREIGN KEY (fk2idModeloReferencia) REFERENCES ModelosReferencia (idModeloReferencia),
          FOREIGN KEY (fk2idConcepto) REFERENCES Conceptos (idConcepto)
        )
      ''');
      await db.execute('''
        CREATE TABLE Usuario(
        	idUsuario INTEGER PRIMARY KEY,
        	documento INTEGER NOT NULL,
        	password STRING NOT NULL,
        	nombres STRING NOT NULL,
        	apellidos STRING NOT NULL,
        	email STRING NOT NULL,
        	fechaNacimiento STRING NOT NULL,
          fechaUltimaSincro STRING NOT NULL
        ) 
      ''');
//#################  modelo de referencia
      await db.rawInsert('''
        INSERT INTO ModelosReferencia(suma) VALUES(0)
      ''');
//################# conceptos
      await db.rawInsert('''

        INSERT INTO Conceptos(nombreConcepto) VALUES("Semilla")
      ''');
      await db.rawInsert('''
        INSERT INTO Conceptos(nombreConcepto) VALUES("Abono y fertilizantes")
      ''');
      await db.rawInsert('''
        INSERT INTO Conceptos(nombreConcepto) VALUES("Plaguicidas y herbicidas")

      ''');
      await db.rawInsert('''
        INSERT INTO Conceptos(nombreConcepto) VALUES("Materiales y Empaques")
      ''');
      await db.rawInsert('''
        INSERT INTO Conceptos(nombreConcepto) VALUES("Maquinaria")
      ''');
      await db.rawInsert('''

        INSERT INTO Conceptos(nombreConcepto) VALUES("Mano de obra")

      ''');
      await db.rawInsert('''
        INSERT INTO Conceptos(nombreConcepto) VALUES("Transporte")
      ''');
      await db.rawInsert('''
        INSERT INTO Conceptos(nombreConcepto) VALUES("Otros")
      ''');
//#################  estados del cultivo
      await db.rawInsert('''
        INSERT INTO EstadosCultivo(nombreEstado) VALUES("Activo")
      ''');
      await db.rawInsert('''
        INSERT INTO EstadosCultivo(nombreEstado) VALUES("Inactivo")
      ''');
      await db.rawInsert('''
        INSERT INTO EstadosCultivo(nombreEstado) VALUES("Perdido")
      ''');
//#################  unidades de medida
      await db.rawInsert('''
        INSERT INTO UnidadesMedida(nombreUnidadMedida, descripcion) VALUES("kg", "Kilogramo")
      ''');
      await db.rawInsert('''
        INSERT INTO UnidadesMedida(nombreUnidadMedida, descripcion) VALUES("Bultos", "Bultos")
      ''');
      await db.rawInsert('''
        INSERT INTO UnidadesMedida(nombreUnidadMedida, descripcion) VALUES("125 gr", "Papeleta de 125 gr")
      ''');
      await db.rawInsert('''
        INSERT INTO UnidadesMedida(nombreUnidadMedida, descripcion) VALUES("Jornal", "8 horas")
      ''');
      await db.rawInsert('''
        INSERT INTO UnidadesMedida(nombreUnidadMedida, descripcion) VALUES("Rollo", "Rollo n metros")
      ''');
//#################  porcentajes del MR modelo de referencia
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
//################# productos agricolas
      await db.rawInsert('''
        INSERT INTO ProductosAgricolas(nombreProducto) VALUES("Arveja")
      ''');
//################ productos actividades
      await db.rawInsert('''
        INSERT INTO ProductosActividades(fkidConcepto, fkidUnidadMedida, nombreProductoActividad) VALUES("2", "2", "Gallinaza")
      ''');
      await db.rawInsert('''
        INSERT INTO ProductosActividades(fkidConcepto, fkidUnidadMedida, nombreProductoActividad) VALUES("4", "5", "Alambre")
      ''');
      await db.rawInsert('''
        INSERT INTO ProductosActividades(fkidConcepto, fkidUnidadMedida, nombreProductoActividad) VALUES("4", "5", "Cabuya")
      ''');
      await db.rawInsert('''
        INSERT INTO ProductosActividades(fkidConcepto, fkidUnidadMedida, nombreProductoActividad) VALUES("2", "2", "Triple 15")
      ''');
      await db.rawInsert('''
        INSERT INTO ProductosActividades(fkidConcepto, fkidUnidadMedida, nombreProductoActividad) VALUES("1", "1", "Rabo de gallo")
      ''');
      await db.rawInsert('''
        INSERT INTO ProductosActividades(fkidConcepto, fkidUnidadMedida, nombreProductoActividad) VALUES("3", "3", "Metarex")
      ''');
      await db.rawInsert('''
        INSERT INTO ProductosActividades(fkidConcepto, fkidUnidadMedida, nombreProductoActividad) VALUES("3", "1", "Dinate")
      ''');
      await db.rawInsert('''
        INSERT INTO ProductosActividades(fkidConcepto, fkidUnidadMedida, nombreProductoActividad) VALUES("6", "4", "Tutorar")
      ''');
      await db.rawInsert('''
        INSERT INTO ProductosActividades(fkidConcepto, fkidUnidadMedida, nombreProductoActividad) VALUES("6", "4", "Arar")
      ''');
      await db.rawInsert('''
        INSERT INTO ProductosActividades(fkidConcepto, fkidUnidadMedida, nombreProductoActividad) VALUES("6", "4", "Fumigar")
      ''');
      await db.rawInsert('''
        INSERT INTO ProductosActividades(fkidConcepto, fkidUnidadMedida, nombreProductoActividad) VALUES("6", "4", "Recoleccion")
      ''');

      print('base creada');
    });
  }
}