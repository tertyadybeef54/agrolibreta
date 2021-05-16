import 'package:agrolibreta_v2/src/data/concepto_operations.dart';
import 'package:agrolibreta_v2/src/data/cultivo_operations.dart';
import 'package:agrolibreta_v2/src/data/producto_actividad_operations.dart';
import 'package:agrolibreta_v2/src/dataproviders/filtros_costos_data_provider.dart';
import 'package:agrolibreta_v2/src/modelos/concepto_model.dart';
import 'package:agrolibreta_v2/src/modelos/costo_model.dart';
import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';
import 'package:agrolibreta_v2/src/modelos/producto_actividad_model.dart';
import 'package:agrolibreta_v2/src/widgets/concepto_dropdown.dart';
import 'package:agrolibreta_v2/src/widgets/cultivo_dropdown.dart';
import 'package:agrolibreta_v2/src/widgets/producto_actividad_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CostosPage extends StatefulWidget {
  @override
  _CostosPageState createState() => _CostosPageState();
}

class _CostosPageState extends State<CostosPage> {
  final controlDesde = new TextEditingController();
  final controlHasta = new TextEditingController();
  //operaciones para consultas de los dropdown
  ProductoActividadOperations proActOper = new ProductoActividadOperations();
  CultivoOperations culOper = new CultivoOperations();
  ConceptoOperations conOper = new ConceptoOperations();
  String _fechaDesde = '';
  String _fechaHasta = '';

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
  ProductoActividadModel _selectedProductoActividad;
  callback(selectedProductoActividad) {
    setState(() {
      _selectedProductoActividad = selectedProductoActividad;
    });
  }

  // ignore: unused_field
  ConceptoModel _selectedConcepto;
  callback1(selectedConcepto) {
    setState(() {
      _selectedConcepto = selectedConcepto;
    });
  }

  // ignore: unused_field
  CultivoModel _selectedCultivo;
  callback2(selectedCultivo) {
    setState(() {
      _selectedCultivo = selectedCultivo;
    });
  }

  List<CostoModel> costos = [];

  @override
  Widget build(BuildContext context) {
    final filData = Provider.of<FiltrosCostosData>(context);
    filData.filtrar('1', '', '', '2', '1');
    costos = filData.costos;
    costos.forEach((e) {
      print(
          '${e.idCosto}, ${e.fecha}, can: ${e.cantidad}, idpro: ${e.fkidProductoActividad}, ${e.valorUnidad}, ${e.fkidCultivo}');
    });
    //filData.prueba();

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyyMMdd');
    final String formatted = formatter.format(now);
    final int format = int.parse(formatted);
    print('fecha en int');
    print(format.toString());
    
    return Scaffold(
      appBar: _appBar(),
      body: Stack(
        children: <Widget>[
          titulos(context),
          ListView.builder(
            padding: EdgeInsets.only(
                left: 0.0, right: 0.0, top: 200.0, bottom: 20.0),
            itemCount: _costos.length,
            itemBuilder: (context, index) {
              return _costo(_costos[index], context);
            },
          ),
          filtros(),
        ],
      ),
      // floatingActionButton: _botonNuevoGasto(context),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Center(
        child: Text('Buscar costos por:'),
      ),
    );
  }

  Widget filtros() {
    return Column(
      children: [
        SizedBox(
          height: 3.0,
        ),
        Row(
          children: [
            SizedBox(width: 8.0),
            Text('Cultivo: '),
            _seleccioneCultivo(),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 8.0),
            Text('Desde:'),
            _fFechaDesde(context),
            Text(' hasta:'),
            _fFechaHasta(context),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 8.0),
            Text('Producto o actividadad: '),
            _seleccioneProductoActividad(),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 8.0),
            Text('Concepto: '),
            _seleccioneConcepto(),
          ],
        ),
      ],
    );
  }

//Filtrar por fecha Desde y Hasta
  Widget _fFechaDesde(BuildContext context) {
    return Container(
      height: 30.0,
      width: 148.0,
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        enableInteractiveSelection: false,
        controller: controlDesde,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          icon: Icon(Icons.calendar_today),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDate(context, 1);
        },
      ),
    );
  }

  _selectDate(BuildContext context, int n) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2021),
      lastDate: new DateTime(2030),
      locale: Locale('es', 'ES'),
    );
    if (picked != null) {
      setState(() {
        if (n == 1) {
          //para identificar cual date esta seleccionado
          _fechaDesde = DateFormat('dd-MM-yyyy').format(picked);
          controlDesde.text = _fechaDesde;
        }
        if (n == 2) {
          _fechaHasta = DateFormat('dd-MM-yyyy').format(picked);
          controlHasta.text = _fechaHasta;
        }
      });
    }
  }

  Widget _fFechaHasta(BuildContext context) {
    return Container(
      height: 30.0,
      width: 118,
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        enableInteractiveSelection: false,
        controller: controlHasta,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDate(context, 2);
        },
      ),
    );
  }

  //dropdown seleccionar producto actividad
  Widget _seleccioneProductoActividad() {
    return Row(
      children: [
        SizedBox(width: 5.0),
        FutureBuilder<List<ProductoActividadModel>>(
          future: proActOper.consultarProductosActividades(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ProductosActividadesDropdowun(snapshot.data, callback)
                : Text('');
          },
        ),
      ],
    );
  }

  //Dropdown seleccionar concepto
  Widget _seleccioneConcepto() {
    return Row(
      children: [
        SizedBox(width: 5.0),
        FutureBuilder<List<ConceptoModel>>(
          future: conOper.consultarConceptos(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ConceptoDropdown(snapshot.data, callback1) //selected concepto
                : Text('sin conceptos');
          },
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
                ? CultivoDropdown(snapshot.data, callback2) //selected concepto
                : Text('sin conceptos');
          },
        ),
      ],
    );
  }

  Widget titulos(BuildContext context) {
    //estas variables permiten obtener el ancho para ser asignado a cada criterio
    final double ancho = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(top: 168.0),
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

  Widget _costo(Map costo, BuildContext context) {
    final double ancho = MediaQuery.of(context).size.width;
    return Row(
      children: <Widget>[
        SizedBox(
          width: 5.0,
        ),
        criterio(costo['fecha'], ancho * 0.15),
        criterio(costo['cant'].toString(), ancho * 0.07),
        criterio(costo['und.'].toString(), ancho * 0.15),
        criterio(costo['nombre'], ancho * 0.30),
        criterio(costo['v.und'].toString(), ancho * 0.12),
        criterio(costo['v.total'].toString(), ancho * 0.14),
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
}
