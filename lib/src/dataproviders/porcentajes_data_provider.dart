import 'package:agrolibreta_v2/src/data/modelos_referencia_operations.dart';
import 'package:agrolibreta_v2/src/data/porcentaje_operations.dart';
import 'package:flutter/material.dart';

import 'package:agrolibreta_v2/src/modelos/concepto_model.dart';
import 'package:agrolibreta_v2/src/modelos/porcentaje_model.dart';

PorcentajeOperations _porOper = new PorcentajeOperations();
ModelosReferenciaOperations _modOper = new ModelosReferenciaOperations();

//provider que para manejar datos de los porcentajes de un MR
class PorcentajeData with ChangeNotifier {
  double suma;
  String idModeloReferencia;
  List<ConceptoModel> conceptos = [];
  List<PorcentajeModel> porcentajes = [];

  PorcentajeData() {
    this.suma = 0;
  }

  //anade a la lista para mostrar el porcentaje, el concepto y ademas
  //actualiza el valor de la suma del modelo de referencia
  //ya que será valido solo si su campo suma es de 100
  anadirPorcentaje(PorcentajeModel porcentaje, ConceptoModel concepto) async {
    final _resp = await _porOper.nuevoPorcentaje(porcentaje);
    porcentaje.idPorcentaje = _resp;
    this.porcentajes.add(porcentaje);
    this.conceptos.add(concepto);
    this.suma = this.suma + porcentaje.porcentaje;
    ModeloReferenciaModel tempModel =
        new ModeloReferenciaModel(suma: this.suma);
    _modOper.updateModelosReferencia(tempModel);
    notifyListeners();
  }
  reset(){
    this.suma = 0;
    this.conceptos = [];
    this.porcentajes = [];
  }
 
  @override
  void dispose() {
    super.dispose();
  }
}
