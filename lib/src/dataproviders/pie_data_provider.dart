import 'dart:ui';

import 'package:agrolibreta_v2/src/data/porcentaje_operations.dart';
import 'package:agrolibreta_v2/src/pages/informe_folder/crear_pdf_informe_page.dart';
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

//inicializa con el cultivo 1 por defecto
  PieData() {
    this.getCultivo();
    this.seriesPieData = [];
    this.seriesData = [];
  }
  //se asigna el cultivo 1 al parametro cultivo del provider
  getCultivo() async {
    final _cultivo = await _culOper.getCultivoById(1);
    this.cultivo = _cultivo;
    print('provider pie data');
    notifyListeners();
  }

//se consultan y almacenan los datos para graficar la torta
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
        double porcentaje = 1;
        if (total != 0) {
          porcentaje = resp * 100 / total;
        }
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

//se consulta y extraen los datos para graficar el grafico de barras
  generarDataMRCul() async {
    this.seriesData = [];
    if (this.cultivo != null) {
      List<Concepto> barraData1 = [];
      List<Concepto> barraData2 = [];

      //datos para el pdf.
      //###############################################################
      sumasCultivo = []; //#############################################
      sumasMr = []; //##################################################
      //###############################################################

      final _conceptos = await _conOper.consultarConceptos();
      _conceptos.forEach((concepto) async {
        final suma = await _cosOper.sumaCostosByConcepto(
            this.cultivo.idCultivo, concepto.idConcepto.toString());
        final gastoIdeal = await _porOper.getPorcenByMRyConcep(
            this.cultivo.fkidModeloReferencia,
            concepto.idConcepto.toString(),
            this.cultivo.presupuesto);
        //datos para el pdf.
        //###############################################################
        sumasCultivo
            .add(suma.round()); //########################################
        sumasMr
            .add(gastoIdeal.round()); //#######################################
        //###############################################################
        print(suma);
        print(gastoIdeal);
        print("#### provider pie data datos de las barras");
        final nombre = concepto.nombreConcepto.substring(0, 5);
        final conTempR = new Concepto(nombre, suma);
        final conTempI = new Concepto(nombre, gastoIdeal);

        barraData1.add(conTempR);
        barraData2.add(conTempI);
      });

      seriesData.add(
        charts.Series(
          domainFn: (Concepto concepto, _) => concepto.concepto, //eje x+
          measureFn: (Concepto concepto, _) => concepto.total, // eje y+
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
          id: 'MR',
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
  String concepto;
  int total;

  Concepto(this.concepto, this.total);
}
