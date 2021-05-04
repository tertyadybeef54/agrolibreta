import 'package:flutter/material.dart';

import 'package:agrolibreta_v2/src/data/modelos_referencia_operations.dart';

ModelosReferenciaOperations _modOper = new ModelosReferenciaOperations();

//provider que para manejar datos de los modelosReferencia
class ModeloReferenciaData with ChangeNotifier {
  List<ModeloReferenciaModel> modelosReferencia = [];
  int id;

  ModeloReferenciaData() {
    this.getModelosReferencia();
  }
  getModelosReferencia() async {
    final _resp = await _modOper.consultarModelosReferencia();
    this.modelosReferencia = [..._resp];
    notifyListeners();
  }

  anadirModeloReferencia(ModeloReferenciaModel modeloReferencia) async {
    final _resp = await _modOper.nuevoModeloReferencia(modeloReferencia);
    modeloReferencia.idModeloReferencia = _resp;
    this.modelosReferencia.add(modeloReferencia);
    this.id = _resp;
    notifyListeners();
  }
}
