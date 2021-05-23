import 'package:agrolibreta_v2/src/data/estados_operations.dart';
import 'package:agrolibreta_v2/src/data/producto_actividad_operations.dart';
import 'package:agrolibreta_v2/src/data/ubicaciones_operations.dart';
import 'package:agrolibreta_v2/src/dataproviders/filtros_costos_data_provider.dart';
import 'package:agrolibreta_v2/src/dataproviders/pie_data_provider.dart';
import 'package:agrolibreta_v2/src/modelos/costo_model.dart';
import 'package:agrolibreta_v2/src/modelos/estado_model.dart';
import 'package:agrolibreta_v2/src/modelos/ubicacion_model.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:agrolibreta_v2/src/data/cultivo_operations.dart';
import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';
import 'package:agrolibreta_v2/src/widgets/cultivo_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InformeCultivoPage extends StatefulWidget {
  @override
  _InformeCultivoPageState createState() => _InformeCultivoPageState();
}

class _InformeCultivoPageState extends State<InformeCultivoPage> {
  ProductoActividadOperations _proActOper = new ProductoActividadOperations();
  UbicacionesOperations _ubiOper = new UbicacionesOperations();
  EstadosOperations _estOper = new EstadosOperations();
  List<Widget> listado = [];
  CultivoOperations _culOper = new CultivoOperations();
  //List<charts.Series<Pollution, String>> _seriesData;
  //List<charts.Series<Task, String>> _seriesPieData;

  //_generateData() {
/*     var data1 = [
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
    ); */
/*     var piedata = [
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
    ); */
  //}

  CultivoModel _selectedCultivo;
  callback(selectedCultivo) {
    setState(() {
      _selectedCultivo = selectedCultivo;
    });
  }

  @override
  void initState() {
    super.initState();
    //_seriesData = <charts.Series<Pollution, String>>[];
    //_seriesPieData = <charts.Series<Task, String>>[];
    //_generateData();
    _selectedCultivo = new CultivoModel(
        idCultivo: 1,
        fkidUbicacion: '1',
        fkidEstado: '1',
        fkidModeloReferencia: '1',
        fkidProductoAgricola: '1',
        nombreDistintivo: '',
        areaSembrada: 0.0,
        fechaInicio: '',
        fechaFinal: '',
        presupuesto: 0,
        precioVentaIdeal: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final filData = Provider.of<FiltrosCostosData>(context);
    final costos = filData.costos;
    final pieData = Provider.of<PieData>(context, listen: false);
    pieData.generarData();
    pieData.generarDataMRCul();
    final tabs = [
      Tab(icon: Icon(Icons.assignment)),
      Tab(icon: Icon(Icons.donut_small)),
      Tab(icon: Icon(Icons.equalizer)),
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff1976d2),
            bottom: TabBar(
              indicatorColor: Color(0xff9962D0),
              tabs: tabs,
            ),
            title: Text('Flutter Charts'),
          ),
          body: TabBarView(
            children: [
              _tapUno(context, costos),
              _graficarDona(),
              _graficarBarras(),
            ],
          ),
        ),
      ),
    );
  }

  //primera vista del TapBar
  Widget _tapUno(BuildContext context, List<CostoModel> costos) {
    return ListView.builder(
      padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
      itemCount: costos.length + 2,
      itemBuilder: (context, index) {
        _armarWidgets(context, costos);
        return listado[index];
      },
    );
  }

  void _armarWidgets(BuildContext context, List<CostoModel> costos) {
    listado = [];
    listado.add(cultivow(_selectedCultivo));
    listado.add(titulos(context));
    costos.forEach((costo) {
      listado.add(_costo(costo, context));
    });
  }

//cultivo widget que da la informacion del cultivo
  Widget cultivow(CultivoModel cultivo) {
    return Column(children: [
      SizedBox(
        height: 3.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 8.0),
          Text('Cultivo: '),
          _seleccioneCultivo(),
          _botonFiltrar(context),
          SizedBox(width: 10.0),
          SizedBox(
            child: Column(
              children: [
                Text(
                  'Pesupuestado: ${cultivo.presupuesto.toString()}',
                ),
                Text('Venta ideal: ${cultivo.precioVentaIdeal.toString()}'),
              ],
            ),
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 10.0),
          ubicacion(cultivo.fkidUbicacion),
          SizedBox(width: 10.0),
          estado(cultivo.fkidEstado),
          SizedBox(width: 10.0),
          Text('MR: ${cultivo.fkidModeloReferencia}'),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 10.0),
          Text('Cultivo de: Arveja.'),
          SizedBox(width: 8.0),
          Text('Area sembrada: ${cultivo.areaSembrada.toString()} m2'),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 10.0),
          Text('Fecha Inicial: ${cultivo.fechaInicio}'),
          SizedBox(width: 10.0),
          Text('Final ${cultivo.fechaFinal}'),
          SizedBox(width: 8.0),
          //
        ],
      ),
    ]);
  }

  //dropdown seleccionar cultivo
  Widget _seleccioneCultivo() {
    return Row(
      children: [
        SizedBox(width: 5.0),
        FutureBuilder<List<CultivoModel>>(
          future: _culOper.consultarCultivos(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? CultivoDropdown(snapshot.data, callback) //selected concepto
                : Text('sin conceptos');
          },
        ),
      ],
    );
  }

//ubicacion del cultivo
  Widget ubicacion(String idUbicacion) {
    return FutureBuilder<UbicacionModel>(
        future: _ubiOper.getUbicacionById(idUbicacion),
        builder:
            (BuildContext context, AsyncSnapshot<UbicacionModel> snapshot) {
          String _ubicacion = '';
          if (snapshot.hasData) {
            _ubicacion = snapshot.data.nombreUbicacion;
          } else if (snapshot.hasError) {
            _ubicacion = 'nn';
          } else {
            _ubicacion = '';
          }
          return Text('Ubicacion: $_ubicacion.');
        });
  }

//estado actual del cultivo
  Widget estado(String idEstado) {
    return FutureBuilder<EstadoModel>(
        future: _estOper.getEstadoById(idEstado),
        builder: (BuildContext context, AsyncSnapshot<EstadoModel> snapshot) {
          String _estado = '';
          if (snapshot.hasData) {
            _estado = snapshot.data.nombreEstado;
          } else if (snapshot.hasError) {
            _estado = 'nn';
          } else {
            _estado = '';
          }
          return Text('Estado: $_estado.');
        });
  }

  Widget titulos(BuildContext context) {
    //estas variables permiten obtener el ancho para ser asignado a cada criterio
    final double ancho = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 5.0,
          ),
          criterio('Fecha', ancho * 0.15),
          criterio('Cant', ancho * 0.07),
          criterio('Und.', ancho * 0.15),
          criterio('Nombre', ancho * 0.30),
          criterio('V.und', ancho * 0.12),
          criterio('V.total', ancho * 0.14),
          SizedBox(
            width: 5.0,
          )
        ],
      ),
    );
  }

  Widget _costo(CostoModel costo, BuildContext context) {
    final double ancho = MediaQuery.of(context).size.width;
    final fecha = costo.fecha.toString();
    final fechaDate = DateTime.tryParse(fecha);
    final fechaFormatted = DateFormat('dd-MM-yy').format(fechaDate);
    return Row(
      children: <Widget>[
        SizedBox(
          width: 5.0,
        ),
        criterio(fechaFormatted, ancho * 0.15),
        criterio(costo.cantidad.toString(), ancho * 0.07),
        criterioUnidad(costo.fkidProductoActividad, ancho * 0.15),
        //criterio(costo.fkidProductoActividad.toString(), ancho * 0.15),
        criterioFuture(costo.fkidProductoActividad, ancho * 0.30),
        //criterio(costo.fkidProductoActividad, ancho * 0.30),
        criterio(costo.valorUnidad.toString(), ancho * 0.12),
        criterio((costo.cantidad * costo.valorUnidad).toString(), ancho * 0.14),
        SizedBox(
          width: 5.0,
        )
      ],
    );
  }

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

  Widget criterioFuture(String fk, double ancho) {
    return FutureBuilder<String>(
        future: _proActOper.consultarNombre(fk),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            child = Text(snapshot.data);
          } else if (snapshot.hasError) {
            child = Text('nn');
          } else {
            child = SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
              width: 10,
              height: 10, //
            );
          }
          return Container(
              height: 25.0,
              width: ancho,
              margin: EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(3.0)),
              child: Center(child: child));
        });
  }

  Widget criterioUnidad(String fk, double ancho) {
    return FutureBuilder<String>(
        future: _proActOper.consultarNombreUnidad(fk),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            child = Text(snapshot.data);
          } else if (snapshot.hasError) {
            child = Text('nn');
          } else {
            child = SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
              width: 10,
              height: 10, //
            );
          }
          return Container(
              height: 25.0,
              width: ancho,
              margin: EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(3.0)),
              child: Center(child: child));
        });
  }

  // ignore: unused_element
  Widget _botonPDF(BuildContext context) {
    return FloatingActionButton(
      child: Text('PDF'),
      onPressed: () {},
    );
  }

  Widget _botonFiltrar(BuildContext context) {
    final pieData = Provider.of<PieData>(context, listen: false);
    final filData = Provider.of<FiltrosCostosData>(context, listen: false);
    if (_selectedCultivo != null) {
      pieData.cultivo = _selectedCultivo;
    }
    final String idCul =
        _selectedCultivo != null ? _selectedCultivo.idCultivo.toString() : '1';
    return FloatingActionButton(
      child: Icon(Icons.filter_list),
      onPressed: () {
        filData.filtrar(idCul, '20210000', '21999999', 'todos', 'todos');
        setState(() {});
      },
    );
  }

//############################################
  //grafica de la dona
  Widget _graficarDona() {
    final pieData = Provider.of<PieData>(context, listen: false);
    final _seriesPieData = pieData.seriesPieData;
    if (_seriesPieData == null) {
      return Container();
    }
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
                child: charts.PieChart(
                  _seriesPieData,
                  animate: true,
                  animationDuration: Duration(seconds: 2),
                  behaviors: [
                    new charts.DatumLegend(
                      outsideJustification:
                          charts.OutsideJustification.endDrawArea,
                      horizontalFirst: false,
                      desiredMaxRows: 3,
                      //cellPadding: new EdgeInsets.only(),
                      entryTextStyle: charts.TextStyleSpec(
                        color: charts.MaterialPalette.purple.shadeDefault,
                        fontFamily: 'Georgia',
                        fontSize: 11,
                      ),
                    )
                  ],
                  defaultRenderer: new charts.ArcRendererConfig(
                    arcWidth: 100,
                    arcRendererDecorators: [
                      new charts.ArcLabelDecorator(
                        labelPosition: charts.ArcLabelPosition.inside,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//#############################################
//brafico de barras camparar cultivo con MR
  Widget _graficarBarras() {
    final pieData = Provider.of<PieData>(context, listen:false);
    final _seriesData = pieData.seriesData;
    if (_seriesData == null) {
      return Container();
    }
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Esperado y obtenido por conceptos',
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

/* class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
} */
