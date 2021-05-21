import 'package:agrolibreta_v2/src/data/costo_operations.dart';
import 'package:agrolibreta_v2/src/data/cultivo_operations.dart';
import 'package:agrolibreta_v2/src/modelos/costo_model.dart';
import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';
import 'package:flutter/material.dart';

final CostoOperations _cosOper = new CostoOperations();
final CultivoOperations _culOper = new CultivoOperations();

class FiltrosCostosData with ChangeNotifier {
  List<CostoModel> costos = [];
  CultivoModel cultivo;

  FiltrosCostosData() {
    this.getCostosAll();
  }
  getCostosAll() async {
    final _resp = await _cosOper.consultarCostos();
    this.costos = [..._resp];
    final _cultivo = await _culOper.getCultivoById(1);
    this.cultivo = _cultivo;
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
    this.costos = _resp;
  }
}
