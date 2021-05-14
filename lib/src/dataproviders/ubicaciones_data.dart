import 'package:flutter/material.dart';

import 'package:agrolibreta_v2/src/data/ubicaciones_operations.dart';
import 'package:agrolibreta_v2/src/modelos/ubicacion_model.dart';

UbicacionesOperations _ubiOper = new UbicacionesOperations();

//provider que maneja los datos de las ubicaciones
class UbicacionesData with ChangeNotifier {
  List<UbicacionModel> ubicaciones = [];

  UbicacionesData() {
    this.getUbicaciones();
  }
  getUbicaciones() async {
    final resp = await _ubiOper.consultarUbicaciones();
    this.ubicaciones = [...resp];
    notifyListeners();
  }

  anadirUbicacion(String nombre, String descripcion) async {
    final nuevaUbi = new UbicacionModel(nombreUbicacion: nombre, descripcion: descripcion, estado: 1); //por defecto estado 1 : activo
    final _id = await _ubiOper.nuevaUbicacion(nuevaUbi);
    //asignar el id de la base de datos al local
    nuevaUbi.idUbicacion = _id;
    this.ubicaciones.add(nuevaUbi);
    notifyListeners();
  }

}
