import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:agrolibreta_v2/src/data/cultivo_operations.dart';
import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';
import 'package:agrolibreta_v2/src/widgets/cultivo_dropdown.dart';

class InformeCultivoPage extends StatefulWidget {
  @override
  _InformeCultivoPageState createState() => _InformeCultivoPageState();
}

class _InformeCultivoPageState extends State<InformeCultivoPage> {
  CultivoOperations culOper = new CultivoOperations();
  List<charts.Series<Pollution, String>> _seriesData;
  List<charts.Series<Task, String>> _seriesPieData;

  _generateData() {
    var data1 = [
      new Pollution(1, 'semilla', 30000),
      new Pollution(1, 'mano de obra', 1500000),
      new Pollution(1, 'fertilizantes', 200000),
    ];
    var data2 = [
      new Pollution(2, 'semilla', 25000),
      new Pollution(2, 'mano de obra', 1600000),
      new Pollution(2, 'fertilizantes', 220000),
    ];
    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '1',
        data: data1,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff990099)),
      ),
    );

    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '2',
        data: data2,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff109618)),
      ),
    );
    var piedata = [
      new Task('Semilla', 6.5, Color(0xff3366cc)),
      new Task('Fertilizantes', 12.1, Color(0xff990099)),
      new Task('Plaguicidas', 17.7, Color(0xff109618)),
      new Task('Empaques', 6.7, Color(0xfffdbe19)),
      new Task('Mano de obra', 41.8, Color(0xffff9900)),
      new Task('Other', 11.3, Color(0xffdc3912)),
    ];

    _seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Air Pollution',
        data: piedata,
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ),
    );
  }

  final Map _costos = {
    0: {
      'fecha': '21-07-2020',
      'cant': 2,
      'und.': 'lt',
      'nombre': 'fungicida',
      'v.und': 50000,
      'v.total': 100000
    },
    1: {
      'fecha': '24-07-2020',
      'cant': 3,
      'und.': 'bultos',
      'nombre': 'triple 15',
      'v.und': 80000,
      'v.total': 240000
    },
    2: {
      'fecha': '28-07-2020',
      'cant': 2,
      'und.': 'bultos',
      'nombre': 'triple 15',
      'v.und': 80000,
      'v.total': 160000
    }
  };
  // ignore: unused_field
  CultivoModel _selectedCultivo;
  callback(selectedCultivo) {
    setState(() {
      _selectedCultivo = selectedCultivo;
    });
  }

  @override
  void initState() {
    super.initState();
    _seriesData = <charts.Series<Pollution, String>>[];
    _seriesPieData = <charts.Series<Task, String>>[];
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff1976d2),
            bottom: TabBar(
              indicatorColor: Color(0xff9962D0),
              tabs: [
                Tab(icon: Icon(Icons.assignment)),
                Tab(icon: Icon(Icons.donut_small)),
                Tab(icon: Icon(Icons.equalizer)),
              ],
            ),
            title: Text('Flutter Charts'),
          ),
          body: TabBarView(
            children: [
              _tapUno(),
              _graficarDona(),
              _graficarBarras(),
            ],
          ),
        ),
      ),
    );
  }

  //primera vista del TapBar
  Widget _tapUno() {
    return Stack(
      children: <Widget>[
        titulos(context),
        ListView.builder(
          padding:
              EdgeInsets.only(left: 0.0, right: 0.0, top: 130.0, bottom: 20.0),
          itemCount: _costos.length,
          itemBuilder: (context, index) {
            return _costo(_costos[index], context);
          },
        ),
        _resumen(),
      ],
    );
  }

  Widget _resumen() {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 10.0),
            Text('Cultivo: '),
            _seleccioneCultivo(),
            SizedBox(width: 10.0),
            SizedBox(
              child: Column(
                children: [
                  Text(
                    'Pesupuestado: 300000000',
                    overflow: TextOverflow.fade,
                  ),
                  Text('Venta ideal: 50000 x und'),
                ],
              ),
            )
          ],
        ),
        Row(
          children: [
            SizedBox(width: 10.0),
            Text('Ubicación: El llanito.'),
            SizedBox(width: 10.0),
            Text('Estado: activo.'),
            SizedBox(width: 10.0),
            Text('MR: 1'),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 10.0),
            Text('Cultivo de: Arveja.'),
            SizedBox(width: 8.0),
            Text('Area sembrada: 5000 m2'),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 10.0),
            Text('Fecha Inicial: 01-01-2021'),
            SizedBox(width: 10.0),
            Text('Final 15-04-2021'),
            SizedBox(width: 8.0),
            //
          ],
        ),
      ],
    );
  }

  //dropdown seleccionar cultivo
  Widget _seleccioneCultivo() {
    return Row(
      children: [
        SizedBox(width: 5.0),
        FutureBuilder<List<CultivoModel>>(
          future: culOper.consultarCultivos(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? CultivoDropdown(snapshot.data, callback) //selected concepto
                : Text('sin conceptos');
          },
        ),
      ],
    );
  }

  //grafica de la dona
  Widget _graficarDona() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Proporciones de los costos',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.PieChart(_seriesPieData,
                    animate: true,
                    animationDuration: Duration(seconds: 2),
                    behaviors: [
                      new charts.DatumLegend(
                        outsideJustification:
                            charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: 2,
                        cellPadding:
                            new EdgeInsets.only(right: 4.0, bottom: 4.0),
                        entryTextStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.purple.shadeDefault,
                            fontFamily: 'Georgia',
                            fontSize: 11),
                      )
                    ],
                    defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 100,
                        arcRendererDecorators: [
                          new charts.ArcLabelDecorator(
                              labelPosition: charts.ArcLabelPosition.inside)
                        ])),
              ),
            ],
          ),
        ),
      ),
    );
  }
  //crea la fila de los titulos
  Widget titulos(BuildContext context) {
    //estas variables permiten obtener el ancho para ser asignado a cada criterio
    final double ancho = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(top: 100.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 5.0,
          ),
          criterio('Fecha', ancho * 0.15),
          criterio('Cant', ancho * 0.07),
          criterio('Und.', ancho * 0.13),
          criterio('Nombre', ancho * 0.30),
          criterio('V.und', ancho * 0.12),
          criterio('V.total', ancho * 0.15),
          SizedBox(
            width: 5.0,
          )
        ],
      ),
    );
  }
  //crea las filas de los costos
  Widget _costo(Map costo, BuildContext context) {
    final double ancho = MediaQuery.of(context).size.width;
    return Row(
      children: <Widget>[
        SizedBox(
          width: 5.0,
        ),
        criterio(costo['fecha'], ancho * 0.15),
        criterio(costo['cant'].toString(), ancho * 0.07),
        criterio(costo['und.'].toString(), ancho * 0.13),
        criterio(costo['nombre'], ancho * 0.30),
        criterio(costo['v.und'].toString(), ancho * 0.12),
        criterio(costo['v.total'].toString(), ancho * 0.15),
        SizedBox(
          width: 5.0,
        )
      ],
    );
  }
  //funcion que crea cada uno de los bloques del listado
  Widget criterio(String valor, double ancho) {
    return Container(
      height: 25.0,
      width: ancho,
      margin: EdgeInsets.all(1.0),
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(3.0)),
      child: Center(child: Text(valor)),
    );
  }

  Widget _botonPDF(BuildContext context) {
    return FloatingActionButton(
      child: Text('PDF'),
      onPressed: () {},
    );
  }

//brafico de barras camparar cultivo con MR
  Widget _graficarBarras() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Esperado y obtenido en los conceptos',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: charts.BarChart(
                  _seriesData,
                  animate: true,
                  barGroupingType: charts.BarGroupingType.grouped,
                  behaviors: [new charts.SeriesLegend()],
                  animationDuration: Duration(seconds: 2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}

class Pollution {
  String place;
  int year;
  int quantity;

  Pollution(this.year, this.place, this.quantity);
}
