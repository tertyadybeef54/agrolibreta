import 'package:agrolibreta_v2/src/data/modelos_referencia_operations.dart';
import 'package:agrolibreta_v2/src/data/porcentaje_operations.dart';
import 'package:agrolibreta_v2/src/modelos/modelo_referencia_model.dart';
import 'package:flutter/material.dart';

import 'package:agrolibreta_v2/src/modelos/concepto_model.dart';
import 'package:agrolibreta_v2/src/modelos/porcentaje_model.dart';

PorcentajeOperations _porOper = new PorcentajeOperations();
ModelosReferenciaOperations _modOper = new ModelosReferenciaOperations();
 
//provider que para manejar datos de los porcentajes de un MR
class PorcentajeData with ChangeNotifier {
  double suma;
  List<ConceptoModel> conceptos = [];
  List<PorcentajeModel> porcentajes = [];

  PorcentajeData() {
    this.suma = 0;
  }

  //anade a la lista para mostrar el porcentaje, el concepto y ademas
  //actualiza el valor de la suma del modelo de referencia
  //ya que será valido solo si su campo suma es de 100
  anadirPorcentaje(
    int fkMR,
    double valor,
    ConceptoModel concepto,
  ) async {
    final nuevoPor = new PorcentajeModel(
        fk2idConcepto: concepto.idConcepto.toString(),
        fk2idModeloReferencia: fkMR.toString(),
        porcentaje: valor);
    final _resp = await _porOper.nuevoPorcentaje(nuevoPor);
    //poner el id de la base de datos al porcentaje que ira a la lista
    nuevoPor.idPorcentaje = _resp;
    //se añaden a la lista correspondiente
    this.porcentajes.add(nuevoPor);
    this.conceptos.add(concepto);
    this.suma = this.suma + valor;
    ModeloReferenciaModel tempModel =
        new ModeloReferenciaModel(idModeloReferencia: fkMR, suma: this.suma);
    //se actualiza el modelo de referencia
    _modOper.updateModelosReferencia(tempModel);
    notifyListeners();
  }

  reset() {
    this.suma = 0;
    this.conceptos = [];
    this.porcentajes = [];
  }

  eliminarPorcentaje(int id, double valor, int idcon) async {
    this.porcentajes.removeWhere((e) => e.idPorcentaje == id);
    this.conceptos.removeWhere((e) => e.idConcepto == idcon); 
    await _porOper.deletePorcentaje(id);
    this.suma = this.suma - valor;
    /* notifyListeners(); */
  }
}
