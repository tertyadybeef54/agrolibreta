/*
 * Copyright (C) 2017, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */



import 'dart:math';
import 'dart:typed_data';

//import 'package:flutter/services.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/cupertino.dart';
import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


/// This method takes a page format and generates the Pdf file data
  
  Future<Uint8List> buildPdf(PdfPageFormat format) async {
    // Create the Pdf document
    final pw.Document doc = pw.Document();

    const tableHeaders = ['Nombre','Fecha','Cant.','Und.','V.Und','V.Total'];

    final baseColor = PdfColors.green200;

   CultivoModel _cultivo = CultivoModel();

    final _nombre = _cultivo.nombreDistintivo;
    //final _producto = cultivo.fkidProductoAgricola; //para futura version
    final _fecha = _cultivo.fechaInicio;
    final _ubicacion = _cultivo.fkidUbicacion;
    final _estado = _cultivo.fkidEstado;
    final _area = _cultivo.areaSembrada.toString();
    final _presupuesto = _cultivo.presupuesto.toString();
    final _precio = _cultivo.precioVentaIdeal.toString();
    //final _mR = _cultivo.fkidModeloReferencia;

    // final theme = pw.ThemeData.withFont(
    // base: pw.Font.ttf(await rootBundle.load('assets/open-sans.ttf')),
    // bold: pw.Font.ttf(await rootBundle.load('assets/open-sans-bold.ttf')),
    // );

    const dataTable = [
    ['Semilla', 80, 95],
    ['Maquinaria', 250, 230],
    ['Abo-fert', 300, 375],
    ['Mano-obra', 85, 80],
    ['Plag-herb', 300, 350],
    ['Transporte', 650, 550],
    ['Mat-emp', 250, 310],
    ['Otros', 250, 310],
  ];
  // final imageSvg = await rootBundle.loadString('assets/no-image.png');
  // final imagePng = (await rootBundle.load('assets/no-image.png')).buffer.asUint8List();
   // Some summary maths
  final expense = dataTable
      .map((e) => e[2] as num)
      .reduce((value, element) => value + element);

  // Top bar chart
  final chart1 = pw.Chart(
    left: pw.Container(
      alignment: pw.Alignment.topCenter,
      margin: const pw.EdgeInsets.only(right: 5, top: 10),
      child: pw.Transform.rotateBox(
        angle: pi / 2,
        child: pw.Text('')
      ),
    ),
    overlay: pw.ChartLegend(
      position: const pw.Alignment(-.7, 1),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(
          color: PdfColors.black,
          width: .5,
        ),
      ),
    ),
    grid: pw.CartesianGrid(
      xAxis: pw.FixedAxis.fromStrings(
        List<String>.generate(
            dataTable.length, (index) => dataTable[index][0] as String),
        marginStart: 30,
        marginEnd: 30,
        ticks: true,
      ),
      yAxis: pw.FixedAxis(
        [0, 100, 200, 300, 400, 500, 600, 700],
        format: (v) => '\$$v',
        divisions: true,
      ),
    ),
    datasets: [
      pw.BarDataSet(
        color: PdfColors.blue100,
        legend: tableHeaders[2],
        width: 15,
        offset: -10,
        borderColor: baseColor,
        data: List<pw.LineChartValue>.generate(
          dataTable.length,
          (i) {
            final v = dataTable[i][2] as num;
            return pw.LineChartValue(i.toDouble(), v.toDouble());
          },
        ),
      ),
      pw.BarDataSet(
        color: PdfColors.amber100,
        legend: tableHeaders[1],
        width: 15,
        offset: 10,
        borderColor: PdfColors.amber,
        data: List<pw.LineChartValue>.generate(
          dataTable.length,
          (i) {
            final v = dataTable[i][1] as num;
            return pw.LineChartValue(i.toDouble(), v.toDouble());
          },
        ),
      ),
    ],
  );
  
   // Data table
  final table = pw.Table.fromTextArray(
    border: null,
    headers: tableHeaders,
    data: List<List<dynamic>>.generate(
      dataTable.length,
      (index) => <dynamic>[
        dataTable[index][0],
        dataTable[index][1],
        dataTable[index][2],
        (dataTable[index][1] as num) - (dataTable[index][2] as num),
      ],
    ),
    headerStyle: pw.TextStyle(
      color: PdfColors.white,
      fontWeight: pw.FontWeight.bold,
    ),
    headerDecoration: pw.BoxDecoration(
      color: baseColor,
    ),
    rowDecoration: pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          color: baseColor,
          width: .5,
        ),
      ),
    ),
    cellAlignment: pw.Alignment.centerRight,
    cellAlignments: {0: pw.Alignment.centerLeft},
  );
  
  // Add one page with centered text "Hello World"
    doc.addPage(
      pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return pw.ConstrainedBox(
            constraints: pw.BoxConstraints.expand(),
            child:pw.Padding(
              padding: pw.EdgeInsets.all(50.0),
              child:pw.Column(
                children:[
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children:[
                  pw.Text('AgroLibreta', style: pw.TextStyle(fontSize: 15.0)),
                  pw.Text('Escuela de Ingenieria de Sistemas', style: pw.TextStyle(fontSize: 15.0)),
                  pw.Text('Universidad Industrial de Santander', style: pw.TextStyle(fontSize: 15.0)),
                ]),
                pw.SizedBox(height: 20.0),
                pw.Center(child:pw.Text('Informe General', style: pw.TextStyle(fontSize: 18.0, fontWeight: pw.FontWeight.bold))),
                pw.SizedBox(height: 20.0),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(children: [pw.Text('Nombre:', style:pw.TextStyle(fontWeight: pw.FontWeight.bold)), pw.Text('$_nombre')]),
                    pw.Row(children: [pw.Text('Ubicación:', style:pw.TextStyle(fontWeight: pw.FontWeight.bold)), pw.Text('$_ubicacion')])
                  ]
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(children:[pw.Text('Cultivo:', style:pw.TextStyle(fontWeight: pw.FontWeight.bold)), pw.Text('Arveja')]),
                    pw.Row(children:[pw.Text('Estado:', style:pw.TextStyle(fontWeight: pw.FontWeight.bold)), pw.Text('$_estado')])
                  ]
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(children:[pw.Text('Fecha:', style:pw.TextStyle(fontWeight: pw.FontWeight.bold)), pw.Text('$_fecha')]),
                    pw.Row(children:[pw.Text('Area sembrada:', style:pw.TextStyle(fontWeight: pw.FontWeight.bold)), pw.Text('$_area')])
                  ]
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                  pw.Row(children:[pw.Text('')]),
                  pw.Row(children:[pw.Text('Presupuesto:', style:pw.TextStyle(fontWeight: pw.FontWeight.bold)), pw.Text('$_presupuesto')]),
                  ]
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                  pw.Row(children:[pw.Text('')]),
                  pw.Row(children:[pw.Text('Precio de Venta:', style:pw.TextStyle(fontWeight: pw.FontWeight.bold)), pw.Text('$_precio')]),
                  ]
                ),
                
                pw.SizedBox(height: 20.0),
                pw.Center(child:pw.Text('Grafico1. Modelo de referencia y costos del cultivo', style: pw.TextStyle(fontSize: 18.0, fontWeight: pw.FontWeight.bold))),
                pw.SizedBox(height: 40.0),
                pw.Expanded(flex: 3, child: chart1),
                //pw.SizedBox(height: 40.0),
                // pw.Divider(),
                //  pw.SizedBox(height: 20.0),
                
                ],
              )
            )
          );
          
        },
      ),
    );

  

    // Second page with a pie chart
    doc.addPage(
      pw.Page(
        pageFormat: format,
        //theme: theme,
        build: (pw.Context context) {
          const chartColors = [
            PdfColors.blue300,
            PdfColors.green300,
            PdfColors.amber300,
            PdfColors.pink300,
            PdfColors.cyan300,
            PdfColors.purple300,
            PdfColors.lime300,
            PdfColors.deepOrange300,
          ];
          return pw.Padding(
            padding: pw.EdgeInsets.all(50.0),
            child:pw.Column(
              children:[
                pw.Chart(
                  title: pw.Text('Grafico 2. Porcentaje de costos por conceptos del cultivo', style: pw.TextStyle(fontSize: 18.0, fontWeight: pw.FontWeight.bold)),
                  grid: pw.PieGrid(),
                  datasets: List<pw.Dataset>.generate(dataTable.length, (index) {
                    final data = dataTable[index];
                    final color = chartColors[index % chartColors.length];
                    final value = (data[2] as num).toDouble();
                    final pct = (value / expense * 100).round();
                    return pw.PieDataSet(
                      legend: '${data[0]}\n$pct%',
                      value: value,
                      color: color,
                      legendStyle: pw.TextStyle(fontSize: 10),
                    );
                  }),
                ),
                //pw.SizedBox(height: 20.0),
                pw.Center(child:pw.Text('Tabla 1. Costos del cultivo', style: pw.TextStyle(fontSize: 18.0, fontWeight: pw.FontWeight.bold))),
                pw.SizedBox(height: 20.0),
                pw.Expanded(child: table),
              ],
            ),
          );
        },
      ),
    
    );

    // Build and return the final Pdf file data
    return await doc.save();
  }


