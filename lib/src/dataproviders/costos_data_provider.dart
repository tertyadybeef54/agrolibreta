import 'package:agrolibreta_v2/src/data/costo_operations.dart';
import 'package:agrolibreta_v2/src/modelos/costo_model.dart';
import 'package:flutter/material.dart';


CostoOperations _culOper = new CostoOperations();

//provider para manejar los datos relacionados a los costos
class CultivosData with ChangeNotifier {
  List<CostoModel> cultivos = [];

  CultivosData() {
    this.getCultivos();
  }
  getCultivos() async {
    final _resp = await _culOper.consultarCostos();
    this.cultivos = [..._resp];
    notifyListeners();
  }

  anadirCultivo(CostoModel costo) async {
    final _resp = await _culOper.nuevoCosto(costo);
    costo.idCosto = _resp;
    this.cultivos.add(costo);
    notifyListeners();
  }
}
