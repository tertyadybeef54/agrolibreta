import 'package:agrolibreta_v2/src/data/concepto_operations.dart';
import 'package:flutter/material.dart';

import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';
import 'package:agrolibreta_v2/src/modelos/concepto_model.dart';
import 'package:agrolibreta_v2/src/modelos/porcentaje_model.dart';

import 'package:agrolibreta_v2/src/data/costo_operations.dart';
import 'package:agrolibreta_v2/src/data/cultivo_operations.dart';
import 'package:agrolibreta_v2/src/data/porcentaje_operations.dart';

final CostoOperations _cosOper = new CostoOperations();
final ConceptoOperations _conOper = new ConceptoOperations();
final CultivoOperations _culOper = new CultivoOperations();
final PorcentajeOperations _porOper = new PorcentajeOperations();

//provider que para manejar datos de los cultivos
class CultivoData with ChangeNotifier {
  CultivoModel cultivo;
  String idMr = '1';
  List<ConceptoModel> conceptos = [];
  List<PorcentajeModel> porcentajes = [];
  double costosTotales;

  getCultivo(int idCul) async {
    final CultivoModel resp = await _culOper.getCultivoById(idCul);
    this.cultivo = resp;
  }

  actualizarData(CultivoModel nuevoCultivo) async {
    final res = await _culOper.updateCultivos(nuevoCultivo);
    this.cultivo = nuevoCultivo;
    print(res.toString());
  }

  calcularCostosTotales(int idCultivo) async {
    final res = await _cosOper.getCostoTotalByCultivo(idCultivo.toString());
    costosTotales = res;
  }

  consultarMR(String idMR) async {
    
    this.idMr = idMR;
    final _resp = await _porOper.consultarPorcentajesbyModeloReferencia(idMR);

    _resp.forEach((porcentaje) async {
      final _resp2 =
          await _conOper.getConceptoById(int.parse(porcentaje.fk2idConcepto));
      this.conceptos.add(_resp2);
      this.porcentajes.add(porcentaje);
    });
  }

  actualizarEstadoCul(int idCul, int idEst) async {
    final CultivoModel culTemp = await _culOper.getCultivoById(idCul);
    culTemp.fkidEstado = idEst.toString();
    final res = await _culOper.updateCultivos(culTemp);
    this.cultivo = culTemp;
    print(res.toString());
  }
}
