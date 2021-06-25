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

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

String informeNombreCultivo;
String informeFechaCultivo;
String informeFechaFinalCultivo;
String informeUbicacionCultivo;
String informeEstadoCultivo;
int informeAreaCultivo;
int informePresupuestoCultivo;
int informePrecioIdealCultivo;

List<int> sumasCultivo = [];
List<int> sumasMr = [];

List<dynamic> informeFecha = [];
List<dynamic> informeCant = [];
List<dynamic> informeUnidad = [];
List<dynamic> informeNombre = [];
List<dynamic> informeValUni = [];
List<dynamic> informeVtotal = [];

/// This method takes a page format and generates the Pdf file data

Future<Uint8List> buildPdf(PdfPageFormat format) async {
  // Create the Pdf document
  final pw.Document doc = pw.Document();

  const tableHeaders = ['Concepto', 'Costo ideal', 'Costo real', 'Diferencia'];
  const tableHeaders2 = [
    'Fecha',
    'Cant.',
    'Und.',
    'Nombre',
    'V. Und.',
    'V. Total'
  ];

  final baseColor = PdfColors.green200;

  final _nombre = informeNombreCultivo;
  final _fecha = informeFechaCultivo;
  final _fechaFinal = informeFechaFinalCultivo;
  final _ubicacion = informeUbicacionCultivo;
  final _estado = informeEstadoCultivo;
  final _area = informeAreaCultivo;
  final _presupuesto = informePresupuestoCultivo;
  final _precio = informePrecioIdealCultivo;
  //final _mR = _cultivo.fkidModeloReferencia;

  // );
final totalReal = 
sumasCultivo[0]+
sumasCultivo[1]+
sumasCultivo[2]+
sumasCultivo[3]+
sumasCultivo[4]+
sumasCultivo[5]+
sumasCultivo[6]+
sumasCultivo[7];
final totalideal = 
sumasMr[0]+
sumasMr[1]+
sumasMr[2]+
sumasMr[3]+
sumasMr[4]+
sumasMr[5]+
sumasMr[6]+
sumasMr[7];
  List dataTable = [
    ['Semi', sumasCultivo[0], sumasMr[0]],
    ['Abo-fert', sumasCultivo[1], sumasMr[1]],
    ['Plag-herb', sumasCultivo[2], sumasMr[2]],
    ['Mat-emp', sumasCultivo[3], sumasMr[3]],
    ['Maqui', sumasCultivo[4], sumasMr[4]],
    ['Mano-obra', sumasCultivo[5], sumasMr[5]],
    ['Transp', sumasCultivo[6], sumasMr[6]],
    ['Otros', sumasCultivo[7], sumasMr[7]],
    ['total', totalReal, totalideal],
  ];

  // Some summary maths
  //convertir el valor umerico en un porcentaje
  final expense = dataTable
      .map((e) => e[1] as num)
      .reduce((value, element) => value + element);

  // Top bar chart
  final chart1 = pw.Chart(
    left: pw.Container(
      alignment: pw.Alignment.topCenter,
      margin: const pw.EdgeInsets.only(right: 5, top: 10),
      child: pw.Transform.rotateBox(angle: pi / 2, child: pw.Text('')),
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
        [
          0,
          sumasMr[5] * 0.2,
          sumasMr[5] * 0.4,
          sumasMr[5] * 0.6,
          sumasMr[5] * 0.8,
          sumasMr[5]
        ],
        format: (v) => '\$$v',
        divisions: true,
      ),
    ),
    datasets: [
      pw.BarDataSet(
        color: PdfColors.blue,
        legend: 'Cultivo',
        width: 15,
        offset: -10,
        borderColor: PdfColors.blue,
        data: List<pw.LineChartValue>.generate(
          dataTable.length,
          (i) {
            final v = dataTable[i][1] as num;
            return pw.LineChartValue(i.toDouble(), v.toDouble());
          },
        ),
      ),
      pw.BarDataSet(
        color: PdfColors.green,
        legend: 'Modelo',
        width: 15,
        offset: 10,
        borderColor: PdfColors.green,
        data: List<pw.LineChartValue>.generate(
          dataTable.length,
          (i) {
            final v = dataTable[i][2] as num;
            return pw.LineChartValue(i.toDouble(), v.toDouble());
          },
        ),
      ),
    ],
  );

  // Data table
  final table = pw.Table.fromTextArray(
    border: pw.TableBorder(
        left: pw.BorderSide(),
        right: pw.BorderSide(),
        top: pw.BorderSide(),
        bottom: pw.BorderSide(),
        verticalInside: pw.BorderSide()),
    headers: tableHeaders,
    data: List<List<dynamic>>.generate(
      9,
      (index) => <dynamic>[
        dataTable[index][0],
        dataTable[index][2],
        dataTable[index][1],
        (dataTable[index][2] as num) - (dataTable[index][1] as num),
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

//date table 2 datos de los costos
  final table2 = pw.Table.fromTextArray(
    border: null,
    headers: tableHeaders2,
    data: List<List<dynamic>>.generate(
      informeFecha.length,
      (index) => <dynamic>[
        informeFecha[index], //fechas
        informeCant[index], //cantidades
        informeUnidad[index], //undades
        informeNombre[index], //nombres
        informeValUni[index], //valores unidades
        informeVtotal[index], //valores totales
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
  // primera pagina con los datos del cultivo y la grafica de barras
  doc.addPage(
    pw.Page(
      pageFormat: format,
      build: (pw.Context context) {
        return pw.ConstrainedBox(
          constraints: pw.BoxConstraints.expand(),
          child: pw.Padding(
            padding: pw.EdgeInsets.all(50.0),
            child: pw.Column(
              children: [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      pw.Text('AgroLibreta',
                          style: pw.TextStyle(fontSize: 15.0)),
                      pw.Text('Escuela de Ingenieria de Sistemas',
                          style: pw.TextStyle(fontSize: 15.0)),
                      pw.Text('Universidad Industrial de Santander',
                          style: pw.TextStyle(fontSize: 15.0)),
                      pw.Text(
                          'Autores: Deisy Rangel Florez y Andres Javier Cuadros Sanabria',
                          style: pw.TextStyle(fontSize: 15.0)),
                    ]),
                pw.SizedBox(height: 20.0),
                pw.Center(
                    child: pw.Text('Informe General',
                        style: pw.TextStyle(
                            fontSize: 18.0, fontWeight: pw.FontWeight.bold))),
                pw.SizedBox(height: 20.0),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Row(
                          children: [pw.Text('Nombre: '), pw.Text('$_nombre')]),
                      pw.Row(children: [
                        pw.Text('Ubicación: '),
                        pw.Text('$_ubicacion')
                      ])
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Row(children: [
                        pw.Text('Cultivo de: '),
                        pw.Text('Arveja')
                      ]),
                      pw.Row(
                          children: [pw.Text('Estado: '), pw.Text('$_estado')])
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Row(children: [
                        pw.Text('Fecha inicial: '),
                        pw.Text('$_fecha')
                      ]),
                      pw.Row(children: [
                        pw.Text('Area sembrada: '),
                        pw.Text('$_area')
                      ])
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Row(children: [
                        pw.Text('Fecha final: '),
                        pw.Text('$_fechaFinal')
                      ]),
                      pw.Row(children: [
                        pw.Text('Presupuesto: '),
                        pw.Text('$_presupuesto')
                      ]),
                    ]),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(children: [pw.Text('')]),
                    pw.Row(
                      children: [
                        pw.Text('Precio de Venta:'),
                        pw.Text('$_precio')
                      ],
                    ),
                  ],
                ),

                pw.SizedBox(height: 20.0),
                pw.Center(
                  child: pw.Text(
                      'Grafico1. Modelo de referencia y costos del cultivo',
                      style: pw.TextStyle(
                          fontSize: 18.0, fontWeight: pw.FontWeight.bold)),
                ),
                pw.SizedBox(height: 40.0),
                pw.Expanded(flex: 3, child: chart1),
                //pw.SizedBox(height: 40.0),
                // pw.Divider(),
                //  pw.SizedBox(height: 20.0),
              ],
            ),
          ),
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
          child: pw.Column(
            children: [
              pw.Chart(
                title: pw.Column(
                  children: [
                    pw.Text(
                    'Grafico 2. Porcentaje de costos por conceptos del cultivo',
                    style: pw.TextStyle(
                        fontSize: 18.0, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 30.0),
                    pw.Text('Para entender mejor el siguiente grafico piense en el siguiente ejemplo: si para el concepto mano de obra aparece un valor del 50 porciento en la grafica quiere decir que de la suma del valor total de todos los costos la mitad se destinó para dicho concepto'),
                  ]
                ),
                grid: pw.PieGrid(),
                datasets: List<pw.Dataset>.generate(dataTable.length, (index) {
                  final data = dataTable[index];
                  final color = chartColors[index % chartColors.length];
                  final value = (data[1] as num).toDouble();
                  final pct = (value / expense * 100).round();
                  return pw.PieDataSet(
                    legend: '${data[0]}\n$pct%',
                    value: value,
                    color: color,
                    legendStyle: pw.TextStyle(fontSize: 10),
                  );
                }),
              ),
            ],
          ),
        );
      },
    ),
  );
  //tabla 1
  doc.addPage(
    pw.Page(
      pageFormat: format,
      build: (pw.Context context) {

        return pw.Padding(
          padding: pw.EdgeInsets.all(50.0),
          child: pw.Column(
            children: [
              pw.Center(
                  child: pw.Text('Tabla 1. Costos ideales menos costos reales',
                      style: pw.TextStyle(
                          fontSize: 18.0, fontWeight: pw.FontWeight.bold))),
              pw.SizedBox(height: 25.0),
              pw.Text('Tenga en cuenta que si el valor de la diferencia es positivo significa algo favorable, en caso de que la diferencia presente un valor negativo significa algo desfavorable ya que los costos superan el presupuesto inicial'),
              pw.SizedBox(height: 30.0),
              pw.Expanded(child: table),
            ],
          ),
        );
      },
    ),
  );

//tabla de gastos

  doc.addPage(
    pw.Page(
      pageFormat: format,
      //theme: theme,
      build: (pw.Context context) {
        return pw.Padding(
          padding: pw.EdgeInsets.all(30.0),
          child: pw.Column(
            children: [
              pw.Center(
                  child: pw.Text('Tabla 2. Costos del cultivo',
                      style: pw.TextStyle(
                          fontSize: 18.0, fontWeight: pw.FontWeight.bold))),
              pw.SizedBox(height: 20.0),
              pw.Expanded(child: table2),
            ],
          ),
        );
      },
    ),
  );

  // Build and return the final Pdf file data
  return await doc.save();
}
