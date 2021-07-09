import 'package:agrolibreta_v2/src/data/concepto_operations.dart';
import 'package:agrolibreta_v2/src/modelos/modelo_referencia_model.dart';
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
  List<List<ConceptoModel>> conceptosList = []; //almacena listas de conceptos
  //almacena listas de porcentajes
  List<List<PorcentajeModel>> porcentajesList = [];

  ModeloReferenciaData() {
    this.getModelosReferencia();
    this.obtenerByID();
  }
  getModelosReferencia() async {
    final _resp = await _modOper.consultarModelosReferencia();
    this.modelosReferencia = [..._resp];
    
  }

  anadirModeloReferencia(
      double _semilla,
      double _fertilizantes,
      double _plaguicidas,
      double _materiales,
      double _maquinaria,
      double _manoObra,
      double _transporte,
      double _otros) async {
    final nuevoMR = new ModeloReferenciaModel(suma: 100);
    final _id = await _modOper.nuevoModeloReferencia(nuevoMR);
    //asignar el id de la base de datos al modelo
    nuevoMR.idModeloReferencia = _id;
    this.modelosReferencia.add(nuevoMR);
    final nuevoPor = new PorcentajeModel(
        fk2idModeloReferencia: _id.toString(),
        fk2idConcepto: '1',
        porcentaje: _semilla);
    await _porOper.nuevoPorcentaje(nuevoPor);

    final nuevoPor2 = new PorcentajeModel(
        fk2idModeloReferencia: _id.toString(),
        fk2idConcepto: '2',
        porcentaje: _fertilizantes);
    await _porOper.nuevoPorcentaje(nuevoPor2);

    final nuevoPor3 = new PorcentajeModel(
        fk2idModeloReferencia: _id.toString(),
        fk2idConcepto: '3',
        porcentaje: _plaguicidas);
    await _porOper.nuevoPorcentaje(nuevoPor3);

    final nuevoPor4 = new PorcentajeModel(
        fk2idModeloReferencia: _id.toString(),
        fk2idConcepto: '4',
        porcentaje: _materiales);
    await _porOper.nuevoPorcentaje(nuevoPor4);

    final nuevoPor5 = new PorcentajeModel(
        fk2idModeloReferencia: _id.toString(),
        fk2idConcepto: '5',
        porcentaje: _maquinaria);
    await _porOper.nuevoPorcentaje(nuevoPor5);

    final nuevoPor6 = new PorcentajeModel(
        fk2idModeloReferencia: _id.toString(),
        fk2idConcepto: '6',
        porcentaje: _manoObra);
    await _porOper.nuevoPorcentaje(nuevoPor6);

    final nuevoPor7 = new PorcentajeModel(
        fk2idModeloReferencia: _id.toString(),
        fk2idConcepto: '7',
        porcentaje: _transporte);
    await _porOper.nuevoPorcentaje(nuevoPor7);

    final nuevoPor8 = new PorcentajeModel(
        fk2idModeloReferencia: _id.toString(),
        fk2idConcepto: '8',
        porcentaje: _otros);
    await _porOper.nuevoPorcentaje(nuevoPor8);
    final _resp =
        await _porOper.consultarPorcentajesbyModeloReferencia(_id.toString());

    final _resp2 =
        await _conOper.consultarConceptos(); //lista temporal de conceptos
    this.conceptosList.add(_resp2); //se añade la lista de conceptos
    this.porcentajesList.add(_resp); //añade la lista de porcentajes
    notifyListeners();
  }

  obtenerByID() async {
    final _resp = await _modOper.consultarModelosReferencia();
    _resp.forEach(
      (modelo) async {
        final _resp = await _porOper.consultarPorcentajesbyModeloReferencia(
            modelo.idModeloReferencia.toString());

        final _resp2 = await _conOper.consultarConceptos();
        this.conceptosList.add(_resp2); //se añade la lista de conceptos
        this.porcentajesList.add(_resp); //añade la lista de porcentajes
      },
    );
  }

  eliminarModelo(int idMr, List<PorcentajeModel> porcentajes,
      List<ConceptoModel> conceptos) async {
    await _modOper.deleteModeloReferencia(idMr);
    this.getModelosReferencia();
    await _porOper.deletePorcentajesByMR(idMr);
    this.conceptosList.remove(conceptos);
    this.porcentajesList.remove(porcentajes);
    notifyListeners();
  }
}
