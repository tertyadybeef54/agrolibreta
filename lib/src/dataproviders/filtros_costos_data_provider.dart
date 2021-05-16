import 'package:agrolibreta_v2/src/data/costo_operations.dart';
import 'package:agrolibreta_v2/src/modelos/costo_model.dart';
import 'package:flutter/material.dart';

final CostoOperations _cosOper = new CostoOperations();

class FiltrosCostosData with ChangeNotifier {
  List<CostoModel> costos = [];

  FiltrosCostosData() {
    this.getCostosAll();
  }
  getCostosAll() async {
    final _resp = await _cosOper.consultarCostos();
    this.costos = [..._resp];
    print('provider filtros costos');
    notifyListeners();
  }

  filtrar(String fkidCultivo, String fechaDesde, String fechaHasta,
      String fkidproAct, String fkidConcepto) async {
    final _resp = await _cosOper.costosFiltrados(
        fkidCultivo, fechaDesde, fechaHasta, fkidproAct, fkidConcepto);

    _resp.forEach((e) {
      print(e.idCosto);
    });
  }

  prueba() async {
    final _resp = await _cosOper.costosFecha('01-01-2021', '30-12-2021');

    _resp.forEach((e) {
      print(e.idCosto);
    });
  }
}
