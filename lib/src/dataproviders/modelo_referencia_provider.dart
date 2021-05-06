import 'package:agrolibreta_v2/src/data/concepto_operations.dart';
import 'package:flutter/material.dart';

import 'package:agrolibreta_v2/src/modelos/concepto_model.dart';
import 'package:agrolibreta_v2/src/modelos/porcentaje_model.dart';

import 'package:agrolibreta_v2/src/data/porcentaje_operations.dart';
import 'package:agrolibreta_v2/src/data/modelos_referencia_operations.dart';

ConceptoOperations _conOper = new ConceptoOperations();
PorcentajeOperations _porOper = new PorcentajeOperations();
ModelosReferenciaOperations _modOper = new ModelosReferenciaOperations();

//provider que para manejar datos de los modelosReferencia
class ModeloReferenciaData with ChangeNotifier {
  List<ModeloReferenciaModel> modelosReferencia = []; //se almacenan MRs
  //List<ConceptoModel> conceptos = [];  // almacena conceptos
  List<List<ConceptoModel>> conceptosList = []; //almacena listas de conceptos
  List<List<PorcentajeModel>> porcentajesList =
      []; //almacena listas de porcentajes
  int id; //para controlar el ultimo modelo de referencia creado

  ModeloReferenciaData() {
    this.getModelosReferencia();
  }
  getModelosReferencia() async {
    final _resp = await _modOper.consultarModelosReferencia();
    this.modelosReferencia = [..._resp];
    notifyListeners();
  }

  anadirModeloReferencia(double sum) async {
    final nuevoMR = new ModeloReferenciaModel(suma: sum);
    final _id = await _modOper.nuevoModeloReferencia(nuevoMR);
    //asignar el id de la base de datos al modelo
    nuevoMR.idModeloReferencia = _id;
    this.modelosReferencia.add(nuevoMR);
    this.id = _id;
    notifyListeners();
  }

  obtenerByID() {
    this.modelosReferencia.forEach(
      (modelo) async {
        final _resp = await _porOper.consultarPorcentajesbyModeloReferencia(
            modelo.idModeloReferencia.toString());

        List<ConceptoModel> conceptos = []; //lista temporal de conceptos
        _resp.forEach((porcentaje) async {
          final _resp2 = await _conOper
              .getConceptoById(int.parse(porcentaje.fk2idConcepto));
          conceptos.add(_resp2);
        });
        this.conceptosList.add(conceptos); //se añade la lista de conceptos
        this.porcentajesList.add(_resp); //añade la lista de porcentajes
      },
    );
  }

  nuevoConPorList(
      List<ConceptoModel> conceptos, List<PorcentajeModel> porcentajes) {
    this.conceptosList.add(conceptos); //se añade la lista de conceptos
    this.porcentajesList.add(porcentajes); //añade la lista de porcentajes
    notifyListeners();
  }

  refrescar() {
    notifyListeners();
  }
}
