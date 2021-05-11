//import 'package:agrolibreta_v2/src/data/cultivo_operations.dart';
import 'package:flutter/material.dart';

import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';

//CultivoOperations _culOper = new CultivoOperations();

//provider que para manejar datos de los cultivos
class CultivosData with ChangeNotifier {
  List<CultivoModel> cultivos = [];

  CultivosData() {
    this.getCultivos();
  }
  getCultivos() async {
  }

  anadirCultivo(CultivoModel cultivo) async {

  }
}
