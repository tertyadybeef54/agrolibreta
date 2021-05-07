import 'package:flutter/material.dart';

import 'package:agrolibreta_v2/src/data/unidad_medida_operations.dart';
import 'package:agrolibreta_v2/src/modelos/unidad_medida_model.dart';

UnidadMedidaOperations _uniMedOper = new UnidadMedidaOperations();

//provider que cambia el valor del index del botton navigator bar
class UnidadesMedidaData with ChangeNotifier {
  List<UnidadMedidaModel> unidadesMedida = [];

  UnidadesMedidaData() {
    this.getUnidadesMedida();
  }
  getUnidadesMedida() async {
    final resp = await _uniMedOper.consultarUnidadesMedida();
    this.unidadesMedida = [...resp];
    notifyListeners();
  }

  anadirUnidadMedida(String nombre, String descripcion) async {
    final nuevaUniMed = new UnidadMedidaModel(nombreUnidadMedida: nombre, descripcion: descripcion); 
    final _id = await _uniMedOper.nuevoUnidadMedida(nuevaUniMed);
    //asignar el id de la base de datos al local
    nuevaUniMed.idUnidadMedida = _id;
    this.unidadesMedida.add(nuevaUniMed);
    notifyListeners();
  }

}
