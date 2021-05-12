import 'package:agrolibreta_v2/src/data/cultivo_operations.dart';
import 'package:flutter/material.dart';

import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';

final CultivoOperations _culOper = new CultivoOperations();

//provider que para manejar datos de los cultivos
class CultivoData with ChangeNotifier {
  CultivoModel cultivo;

  getCultivo(int idCul) async {
    final CultivoModel resp = await _culOper.getCultivoById(idCul);
    this.cultivo = resp;
  }
  actualizarData(int idCul) async {
    
  }
}
