import 'package:flutter/material.dart';

import 'package:agrolibreta_v2/src/data/ubicaciones_operations.dart';
import 'package:agrolibreta_v2/src/modelos/ubicacion_model.dart';

UbicacionesOperations _ubiOper = new UbicacionesOperations();

//provider que cambia el valor del index del botton navigator bar
class UbicacionesData with ChangeNotifier {
  List<UbicacionModel> _ubicaciones = [];

  UbicacionesData() {
    this.getUbicaciones();
  }
  getUbicaciones() async {
    final resp = await _ubiOper.consultarUbicaciones();
    this._ubicaciones.addAll(resp);
    notifyListeners();
  }
}
