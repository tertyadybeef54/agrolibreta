import 'package:agrolibreta_v2/src/data/cultivo_operations.dart';
import 'package:flutter/material.dart';

import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';

CultivoOperations _culOper = new CultivoOperations();

//provider que cambia el valor del index del botton navigator bar
class CultivosData with ChangeNotifier {
  List<CultivoModel> cultivos = [];

  CultivosData() {
    this.getCultivos();
  }
  getCultivos() async {
    final _resp = await _culOper.consultarCultivos();
    this.cultivos = [..._resp];
    notifyListeners();
  }

  anadirCultivo(CultivoModel cultivo) async {
    final _resp = await _culOper.nuevoCultivo(cultivo);
    cultivo.idCultivo = _resp;
    this.cultivos.add(cultivo);
    notifyListeners();
  }
}
