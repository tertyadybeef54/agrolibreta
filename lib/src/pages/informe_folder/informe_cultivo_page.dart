import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:agrolibreta_v2/src/modelos/costo_model.dart';
import 'package:agrolibreta_v2/src/modelos/estado_model.dart';
import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';
import 'package:agrolibreta_v2/src/modelos/ubicacion_model.dart';
import 'package:agrolibreta_v2/src/data/cultivo_operations.dart';
import 'package:agrolibreta_v2/src/data/estados_operations.dart';
import 'package:agrolibreta_v2/src/data/ubicaciones_operations.dart';
import 'package:agrolibreta_v2/src/data/producto_actividad_operations.dart';

import 'crear_pdf_informe_page.dart';
import 'package:agrolibreta_v2/src/widgets/cultivo_dropdown.dart';
import 'package:agrolibreta_v2/src/dataproviders/pie_data_provider.dart';
import 'package:agrolibreta_v2/src/dataproviders/filtros_costos_data_provider.dart';

//Se muestran los datos importantes del cultivo, los costos, un grafico de torta con el porcentaje que tienen los costos agrupados por conceptos con respecto al 100 porcento del costo total de la produccion, y un grafico de barras que compara el costo total de costos asociados por concepto del cultivo con el modelo de referencia. es decir costo esperado segun el presupuesto y el MR con costo obtenido.
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
  CultivoModel _selectedCultivo;
  callback(selectedCultivo) {
    setState(() {
      _selectedCultivo = selectedCultivo;
    });
  }
  CultivoModel _check = new CultivoModel();
  int total = 0;
  @override
  void initState() {
    super.initState();
    _selectedCultivo = new CultivoModel(
        idCultivo: 1,
        fkidUbicacion: '1',
        fkidEstado: '1',
        fkidModeloReferencia: '1',
        fkidProductoAgricola: '1',
        nombreDistintivo: '',
        areaSembrada: 0,
        fechaInicio: '',
        fechaFinal: '',
        presupuesto: 0,
        precioVentaIdeal: 0.0);
  }
  @override
  Widget build(BuildContext context) {
    final filData = Provider.of<FiltrosCostosData>(context, listen: false);
    final costos = filData.costosbyCul;
    if (_selectedCultivo != _check) {
      final pieData = Provider.of<PieData>(context, listen: false);
      pieData.generarData();
      pieData.generarDataMRCul();
      total = 0;
      costos.forEach((element) {
        total += (element.cantidad * element.valorUnidad).round();
      });
      _check = _selectedCultivo;
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff9ccc65),
            bottom: TabBar(
              indicatorColor: Color(0xff1b5e20),
              tabs:[
                Tab(icon: Icon(Icons.assignment)),
                Tab(icon: Icon(Icons.equalizer)),
              ],
            ),
            title: Text('Informe del cultivo'),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                iconSize: 40.0,
                icon: Icon(Icons.picture_as_pdf),
                tooltip: 'Ver documento',
                onPressed: () {
                  Printing.layoutPdf(
                    onLayout: (PdfPageFormat pageFormat) {
                      return (buildPdf(pageFormat));
                      },
                    );
                  }),
            ],
          ),
          body: TabBarView(
            children: [
              _tapUno(context, costos),
              _graficarBarras(),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ),
      ),
    );
  }

  //primera vista del TapBar
  Widget _tapUno(BuildContext context, List<CostoModel> costos) {
    _armarWidgets(context, costos);
    return ListView.builder(
      padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
      itemCount: costos.length + 2,
      itemBuilder: (context, index) {
        //_armarWidgets(context, costos);
        return listado[index];
      },
    );
  }

  void _armarWidgets(BuildContext context, List<CostoModel> costos) {
    listado = [];
    listado.add(cultivow(_selectedCultivo));
    listado.add(titulos(context));

    //###############################################
    informeFecha = []; //############################
    informeCant = []; //#############################
    informeUnidad = []; //###########################
    informeNombre = []; //###########################
    informeValUni = []; //###########################
    informeVtotal = []; //###########################
    //###############################################

    costos.forEach((costo) {
      listado.add(_costo(costo, context));
    });
  }

//cultivo widget que da la informacion del cultivo
  Widget cultivow(CultivoModel cultivo) {
    //#########################################################
    informeNombreCultivo = cultivo.nombreDistintivo; //########
    informeFechaCultivo = cultivo.fechaInicio; //##############
    informeAreaCultivo = cultivo.areaSembrada; //##############
    informePresupuestoCultivo = cultivo.presupuesto; //########
    informePrecioIdealCultivo = cultivo.precioVentaIdeal.round(); //###
    //#########################################################

    return Column(children: [
      SizedBox(height: 10.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 8.0),
          Text('Cultivo: '),
          _seleccioneCultivo(),
          SizedBox(width: 10.0),
          _botonFiltrar(context),
        ],
      ),
      SizedBox(height: 20.0),
      Center(
          child: Text('Tabla 1. Costos del cultivo',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold))),
      SizedBox(height: 20.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 10.0),
          ubicacion(cultivo.fkidUbicacion),
          SizedBox(width: 10.0),
          estado(cultivo.fkidEstado),
          SizedBox(width: 10.0),
          Text('MR:'),
          Text('${cultivo.fkidModeloReferencia}',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 10.0),
          Text('Total : \$'),
          Text('$total ', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 8.0),
          Text('Area sembrada:'),
          Text('${cultivo.areaSembrada.toString()} m2',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 10.0),
          Text('Fecha Inicial:'),
          Text('${cultivo.fechaInicio}',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 10.0),
          Text('Final:'),
          Text('${cultivo.fechaFinal}',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 8.0),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 10.0),
          Text('Presupuesto: \$'),
          Text('${cultivo.presupuesto.toString()}',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 10.0),
          Text('Venta ideal: \$'),
          Text('${cultivo.precioVentaIdeal.round().toString()}',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      )
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
                : Text('sin cultivos');
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
            //###########################################
            informeUbicacionCultivo = _ubicacion; //######
            //###########################################
          } else if (snapshot.hasError) {
            _ubicacion = 'nn';
          } else {
            _ubicacion = '';
          }
          return Row(children: [
            Text('Ubicacion:'),
            Text(' $_ubicacion.',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ]);
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
            //#######################################
            informeEstadoCultivo = _estado; //########
            //#######################################
          } else if (snapshot.hasError) {
            _estado = 'nn';
          } else {
            _estado = '';
          }
          return Row(children: [
            Text('Estado:'),
            Text('$_estado.', style: TextStyle(fontWeight: FontWeight.bold)),
          ]);
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
          criterioTitulos('Fecha', ancho * 0.15),
          criterioTitulos('Cnt', ancho * 0.07),
          criterioTitulos('Und.', ancho * 0.15),
          criterioTitulos('Nombre', ancho * 0.30),
          criterioTitulos('V.und', ancho * 0.12),
          criterioTitulos('V.total', ancho * 0.14),
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
    //#############################################################
    informeFecha.add(fechaFormatted); //0############################
    informeCant.add(costo.cantidad); //1############################
    informeValUni.add(costo.valorUnidad); //2#########################
    informeVtotal.add(costo.cantidad * costo.valorUnidad); //3########

    //#############################################################
    return Row(
      children: <Widget>[
        SizedBox(
          width: 5.0,
        ),
        criterio(fechaFormatted, ancho * 0.15),
        criterio(costo.cantidad.toString(), ancho * 0.07),
        criterioUnidad(costo.fkidProductoActividad, ancho * 0.15),
        criterioFuture(costo.fkidProductoActividad, ancho * 0.30),
        criterio(costo.valorUnidad.toString(), ancho * 0.12),
        criterio((costo.cantidad * costo.valorUnidad).round().toString(),
            ancho * 0.14),
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

  Widget criterioTitulos(String valor, double ancho) {
    return Container(
      height: 25.0,
      width: ancho,
      margin: EdgeInsets.all(1.0),
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(3.0)),
      child: Center(
          child: Text(valor, style: TextStyle(fontWeight: FontWeight.bold))),
    );
  }

  Widget criterioFuture(String fk, double ancho) {
    return FutureBuilder<String>(
        future: _proActOper.consultarNombre(fk),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            child = Text(snapshot.data);
            //#####################################################
            informeNombre.add(snapshot.data); //5#####################
            //######################
            //#####################################################
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
            //#####################################################
            informeUnidad.add(snapshot.data); //4#####################
            //#####################################################
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


  Widget _botonFiltrar(BuildContext context) {
    final pieData = Provider.of<PieData>(context, listen: false);
    final filData = Provider.of<FiltrosCostosData>(context, listen: false);
    if (_selectedCultivo != null) {
      pieData.cultivo = _selectedCultivo;
      final String idCul = _selectedCultivo != null
          ? _selectedCultivo.idCultivo.toString()
          : '1';
      filData.costosByCultivo(idCul);
    }

    return FloatingActionButton(
      child: Icon(Icons.search, size: 28.0),
      backgroundColor: Color(0xff8c6d62),
      onPressed: () {
        setState(() {});
      },
    );
  }


//#############################################
//brafico de barras camparar cultivo con MR
  Widget _graficarBarras() {
    final pieData = Provider.of<PieData>(context, listen: false);
    final _seriesData = pieData.seriesData;
    if (_seriesData == null) {
      return Container();
    }
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Center(
                  child: Text(
                'Grafico1. Costos presupuestados de MR y costos del cultivo',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              )),
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
