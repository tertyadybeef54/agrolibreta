import 'dart:io';

import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';
import 'package:agrolibreta_v2/src/modelos/ubicacion_model.dart';
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
    final path = join(documentsDirectory.path, 'AgrolibretaDB.db');
    // Crear base de datos
    return await openDatabase(path, version: 3, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
              CREATE TABLE Ubicaciones(
                idUbicacion INTEGER PRIMARY KEY,
                nombreUbicacion TEXT,
                descripcion TEXT
              );
              CREATE TABLE Cultivos(
                idCultivo INTEGER PRIMARY KEY,
                idUbicacion INTEGER,
                nombreCultivo TEXT,
                areaSembrada REAL,
                fechaInicioActividades TEXT, 
                activo INTEGER
        ''');
    });
  }

  // insertar datos en la base de datos: tabla Ubicaciones
  Future<int> nuevaUbicacion(UbicacionModel nuevaUbicacion) async {
    final db = await database;
    final res = await db.insert('Ubicaciones', nuevaUbicacion.toJson());
    // Es el ID del último registro insertado;
    return res;
  }

  Future<int> nuevoCultivo(CultivoModel nuevoCultivo) async {
    final db = await database;
    final res = await db.insert('Cultivos', nuevoCultivo.toJson());

    // Es el ID del último registro insertado;
    return res;
  }

// query para consultar todas las ubicacaiones de la base de datos
  Future<List<UbicacionModel>> consultarUbicaciones() async {
    final db = await database;
    final res = await db.query('Ubicaciones');

    return res.isNotEmpty
        ? res.map((s) => UbicacionModel.fromJson(s)).toList()
        : [];
  }

// actualizar un registro
  Future<int> updateUbicaciones(CultivoModel nuevaUbicacaion) async {
    final db = await database;
    final res = await db.update('Scans', nuevaUbicacaion.toJson(),
        where: 'id = ?', whereArgs: [nuevaUbicacaion.idUbicacion]);
    return res;
  }

//borrar un registro
  Future<int> deleteUbicacion(int id) async {
    final db = await database;
    final res = await db
        .delete('Ubicaciones', where: 'idUbicacion = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAllUbicacaiones() async {
    final db = await database;
    final res = await db.delete('Ubicacaiones');
    return res;
  }

//############################################################

  Future<CultivoModel> getScanById(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? CultivoModel.fromJson(res.first) : null;
  }

  Future<List<CultivoModel>> getScansPorTipo(String tipo) async {
    final db = await database;
    final res = await db.rawQuery('''
      SELECT * FROM Scans WHERE tipo = '$tipo'    
    ''');

    return res.isNotEmpty
        ? res.map((s) => CultivoModel.fromJson(s)).toList()
        : [];
  }

  Future<int> deleteAllScans() async {
    final db = await database;
    final res = await db.rawDelete('''
      DELETE FROM Scans    
    ''');
    return res;
  }
}
