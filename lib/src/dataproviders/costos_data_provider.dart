import 'package:flutter/material.dart';

import 'package:agrolibreta_v2/src/data/cultivo_operations.dart';
import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';

import 'package:agrolibreta_v2/src/modelos/costo_model.dart';
import 'package:agrolibreta_v2/src/data/costo_operations.dart';
import 'package:agrolibreta_v2/src/modelos/concepto_model.dart';
import 'package:agrolibreta_v2/src/data/concepto_operations.dart';
import 'package:agrolibreta_v2/src/data/porcentaje_operations.dart';

final CostoOperations _cosOper = new CostoOperations();
final ConceptoOperations _conOper = new ConceptoOperations();
final CultivoOperations _culOper = new CultivoOperations();
final PorcentajeOperations _porOper = new PorcentajeOperations();

//provider para manejar los datos relacionados a los costos
class CostosData with ChangeNotifier {
  
  List<List<int>> sumasList = [];
  List<List<ConceptoModel>> conceptosList = [];
  List<List<int>> sugeridosList = [];

  List<CultivoModel> cultivos = [];
  List<CostoModel> costos = [];
  List<ConceptoModel> conceptos = [];

  CostosData() {
    this.getCostos();
  }
  getCostos() async {
    final resp = await _cosOper.consultarCostos();
    this.costos = [...resp];
    final res = await _conOper.consultarConceptos();
    this.conceptos = [...res];
    final cul = await _culOper.consultarCultivos();
    this.cultivos = [...cul];

    notifyListeners();
  }

  anadirCultivo(
      String fkidUbicacion,
      String fkidModeloReferencia,
      String nombreDistintivo,
      int areaSembrada,
      String fechaInicio,
      int presupuesto) async {
    final CultivoModel cultivo = new CultivoModel(
        fkidUbicacion: fkidUbicacion,
        fkidEstado: '1',
        fkidModeloReferencia: fkidModeloReferencia,
        fkidProductoAgricola: '1',
        nombreDistintivo: nombreDistintivo,
        areaSembrada: areaSembrada,
        fechaInicio: fechaInicio,
        fechaFinal: 'Sin especificar',
        presupuesto: presupuesto,
        precioVentaIdeal: 0);
    final resp = await _culOper.nuevoCultivo(cultivo);
    cultivo.idCultivo = resp;
    cultivos.add(cultivo);
    notifyListeners();
  }

//se obtiene una lista con todos los concepto, se consultan todos los costos para cada concepto
//en aquel concepto donde no tenga costos se asigna un "-1 " a su suma para diferenciarlo
//y removerlo.

  obtenerCostosByConceptos() {
    if (conceptosList.length == 0) {
      if (cultivos.length > 0) {
        this.cultivos.forEach((e) {

          final List<int> sumTemp = [];
          final List<ConceptoModel> conTemp = [];
          final List<int> sugTemp = [];

          this.conceptos.forEach((e2) async {
            final int resp = await _cosOper.sumaCostosByConcepto(
                e.idCultivo, e2.idConcepto.toString());
            final int sug = await _porOper.getPorcenByMRyConcep(
                e.fkidModeloReferencia,
                e2.idConcepto.toString(),
                e.presupuesto);

            sumTemp.add(resp);
            conTemp.add(e2);
            
            sugTemp.add(sug);
          });

          this.conceptosList.add(conTemp);
          
          this.sumasList.add(sumTemp);
          this.sugeridosList.add(sugTemp);
        });
      }
    }
    print('provider costos data, carga data');
  }

  actualizarCultivos() async {
    print('provider costos actualizar cultivo');
    this.cultivos = [];
    final cul = await _culOper.consultarCultivos();
    this.cultivos = [...cul];
    notifyListeners();
  }
}
