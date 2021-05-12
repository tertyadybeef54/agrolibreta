import 'package:agrolibreta_v2/src/data/costo_operations.dart';
import 'package:agrolibreta_v2/src/data/cultivo_operations.dart';
import 'package:flutter/material.dart';

import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';

final CultivoOperations _culOper = new CultivoOperations();
final CostoOperations _cosOper = new CostoOperations();

//provider que para manejar datos de los cultivos
class CultivoData with ChangeNotifier {
  CultivoModel cultivo;
  double costosTotales;

  getCultivo(int idCul) async {
    final CultivoModel resp = await _culOper.getCultivoById(idCul);
    this.cultivo = resp;
  }

  actualizarData(CultivoModel nuevoCultivo) async {
    final res = await _culOper.updateCultivos(nuevoCultivo);
    this.cultivo = nuevoCultivo;
    print('valor del res');
    print(res.toString());
  }

  calcularCostosTotales(int idCultivo) async {
    final res = await _cosOper.getCostoTotalByCultivo(idCultivo.toString());
    print(res);
    costosTotales = res;
  }
}
