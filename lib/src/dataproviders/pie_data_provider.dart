import 'dart:ui';

import 'package:agrolibreta_v2/src/data/porcentaje_operations.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'Dart:math' as math;

import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';

import 'package:agrolibreta_v2/src/data/costo_operations.dart';
import 'package:agrolibreta_v2/src/data/cultivo_operations.dart';
import 'package:agrolibreta_v2/src/data/concepto_operations.dart';

final CostoOperations _cosOper = new CostoOperations();
final CultivoOperations _culOper = new CultivoOperations();
final ConceptoOperations _conOper = new ConceptoOperations();
final PorcentajeOperations _porOper = new PorcentajeOperations();

class PieData with ChangeNotifier {
  List<charts.Series<PorcConcepto, String>> seriesPieData;
  List<charts.Series<Concepto, String>> seriesData;

  CultivoModel cultivo;

  PieData() {
    this.getCultivo();
    this.seriesPieData = [];
    this.seriesData = [];
  }
  getCultivo() async {
    final _cultivo = await _culOper.getCultivoById(1);
    this.cultivo = _cultivo;
    print('provider pie data');
    notifyListeners();
  }

  generarData() async {
    this.seriesPieData = [];
    if (this.cultivo != null) {
      List<PorcConcepto> piedataa = [];
      final _conceptos = await _conOper.consultarConceptos();
      final total = await _cosOper
          .getCostoTotalByCultivo(this.cultivo.idCultivo.toString());
      _conceptos.forEach((concepto) async {
        final resp = await _cosOper.sumaCostosByConcepto(
            this.cultivo.idCultivo, concepto.idConcepto.toString());
        print(resp);
        final porcentaje = resp * 100 / total;
        final n = num.parse(porcentaje.toStringAsFixed(2));

        PorcConcepto nuevoPorcConcepto = new PorcConcepto(
            concepto.nombreConcepto,
            n,
            Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
                .withOpacity(1.0));
        piedataa.add(nuevoPorcConcepto);
      });

      this.seriesPieData.add(
            charts.Series(
              domainFn: (PorcConcepto concepto, _) => concepto.concepto,
              measureFn: (PorcConcepto concepto, _) => concepto.porcentaje,
              colorFn: (PorcConcepto concepto, _) =>
                  charts.ColorUtil.fromDartColor(concepto.colorval),
              id: 'porcentajes',
              data: piedataa,
              labelAccessorFn: (PorcConcepto row, _) => '${row.porcentaje}',
            ),
          );
    }
  }

  generarDataMRCul() async {
    this.seriesData = [];
    if (this.cultivo != null) {
      List<Concepto> barraData1 = [];
      List<Concepto> barraData2 = [];
      final _conceptos = await _conOper.consultarConceptos();
      _conceptos.forEach((concepto) async {
        final suma = await _cosOper.sumaCostosByConcepto(
            this.cultivo.idCultivo, concepto.idConcepto.toString());
        final gastoIdeal = await _porOper.getPorcenByMRyConcep(
            this.cultivo.fkidModeloReferencia,
            concepto.idConcepto.toString(),
            this.cultivo.presupuesto);
        print(suma);
        print(gastoIdeal);
        print("####");
        final nombre = concepto.nombreConcepto.substring(0, 5);
        final conTempR = new Concepto(1, nombre, suma);
        final conTempI = new Concepto(2, nombre, gastoIdeal);

        barraData1.add(conTempR);
        barraData2.add(conTempI);
      });

      seriesData.add(
        charts.Series(
          domainFn: (Concepto concepto, _) => concepto.concepto,
          measureFn: (Concepto concepto, _) => concepto.total,
          id: 'cultivo',
          data: barraData1,
          fillPatternFn: (_, __) => charts.FillPatternType.solid,
          fillColorFn: (Concepto concepto, _) =>
              charts.ColorUtil.fromDartColor(Colors.blue),
          
        ),
      );

      seriesData.add(
        charts.Series(
          domainFn: (Concepto concepto, _) => concepto.concepto,
          measureFn: (Concepto concepto, _) => concepto.total,
          id: 'modelo',
          data: barraData2,
          fillPatternFn: (_, __) => charts.FillPatternType.solid,
          fillColorFn: (Concepto concepto, _) =>
              charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
        ),
      );
    }
  }
}

class PorcConcepto {
  String concepto;
  double porcentaje;
  Color colorval;

  PorcConcepto(this.concepto, this.porcentaje, this.colorval);
}

class Concepto {
  int id;
  String concepto;
  double total;

  Concepto(this.id, this.concepto, this.total);
}
