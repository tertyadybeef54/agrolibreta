import 'package:agrolibreta_v2/src/modelos/ubicacion_model.dart';
import 'package:flutter/material.dart';

class VarProvider extends ChangeNotifier {
  //int _selectedMenuOpt = 0;
  List<String> _ubicaciones = ['sin especificar'];
  String _ubicacion = 'sin especificar';
  List<UbicacionModel> _ubicacionesm;

//get de la ubicacion
  String get selectedUbicacion {
    return this._ubicacion;
  }

//set de la ubicacaion
  set selectedUbicacion(String ubicacion) {
    this._ubicacion = ubicacion;
    notifyListeners();
  }

//getde las ubicaciones
  List<String> get ubicaciones {
    return this._ubicaciones;
  }

//set de las ubicacaiones
  set ubicaciones(List<String> ubicacion) {
    this._ubicaciones = ubicacion;
    notifyListeners();
  }

//get de la lista de modelos de ubicacaiones
  List<UbicacionModel> get ubicacionesm {
    return this._ubicacionesm;
  }

//set de la lista de modelos de ubicaciones
  set ubicacionesm(List<UbicacionModel> ubicacionesm) {
    ubicacionesm.forEach((ubicacion) {
      this._ubicaciones.add(ubicacion.nombreUbicacion);
    });
    notifyListeners();
  }
}
