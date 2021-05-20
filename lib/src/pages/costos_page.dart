import 'package:agrolibreta_v2/src/data/concepto_operations.dart';
import 'package:agrolibreta_v2/src/data/cultivo_operations.dart';
import 'package:agrolibreta_v2/src/data/producto_actividad_operations.dart';
import 'package:agrolibreta_v2/src/dataproviders/filtros_costos_data_provider.dart';
import 'package:agrolibreta_v2/src/modelos/concepto_model.dart';
import 'package:agrolibreta_v2/src/modelos/costo_model.dart';
import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';
import 'package:agrolibreta_v2/src/modelos/producto_actividad_model.dart';
import 'package:agrolibreta_v2/src/modelos/unidad_medida_model.dart';
import 'package:agrolibreta_v2/src/widgets/concepto_dropdown.dart';
import 'package:agrolibreta_v2/src/widgets/cultivo_dropdown.dart';
import 'package:agrolibreta_v2/src/widgets/producto_actividad_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

//vista de los costos, donde se muestra una lista de todos los costos la cual se le puede aplicar filtros:
//por cultivo, fechas, producto o actividad y concepto.
//las fehcas se manejan como enteros por tanto se le dabe dar formato de yyyyMMdd,
//esto debido a que sqflite no soporta los tipo DATE, y es necesario para hacer las
//consultas por fechas manejarlas como int.
class CostosPage extends StatefulWidget {
  @override
  _CostosPageState createState() => _CostosPageState();
}

class _CostosPageState extends State<CostosPage> {
  final controlDesde = new TextEditingController();
  final controlHasta = new TextEditingController();
  //operaciones para consultas de los dropdown
  ProductoActividadOperations _proActOper = new ProductoActividadOperations();

  CultivoOperations culOper = new CultivoOperations();
  ConceptoOperations conOper = new ConceptoOperations();

  CultivoModel _selectedCultivo;
  callback2(selectedCultivo) {
    setState(() {
      _selectedCultivo = selectedCultivo;
    });
  }

  ProductoActividadModel _selectedProductoActividad;
  callback(ProductoActividadModel selectedProductoActividad) {
    setState(() {
      _selectedProductoActividad = selectedProductoActividad;
    });
  }

  ConceptoModel _selectedConcepto;
  callback1(selectedConcepto) {
    setState(() {
      _selectedConcepto = selectedConcepto;
    });
  }

//listado de los costos filtrados
  //List<CostoModel> costos = [];
  List<UnidadMedidaModel> unidades = [];
  List<ProductoActividadModel> proActs = [];
//variables de los filtros
  String _fechaDesde = '20210101';
  String _fechaHasta =
      '20210601'; //DateFormat('yyyyMMdd').format(DateTime.now());

//para meter todos los widget que se mostraran en la pantalla por medio del listview builder
  List<Widget> listado = [];

  @override
  Widget build(BuildContext context) {
    final filData = Provider.of<FiltrosCostosData>(context);
    final costos = filData.costos;
    costos.forEach((e) {
      print(
          '${e.idCosto}, ${e.fecha}, can: ${e.cantidad}, idpro: ${e.fkidProductoActividad}, ${e.valorUnidad}, ${e.fkidCultivo}');
    });

    return Scaffold(
      appBar: _appBar(),
      body: //Stack(
          //children: <Widget>[
          //titulos(context),
          ListView.builder(
        padding:
            EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0, bottom: 20.0),
        itemCount: costos.length + 2,
        itemBuilder: (context, index) {
          _armarWidgets(context, costos);
          return listado[index]; // _costo(costos[index], context);
        },
      ),
      //filtros(),
      //],
      //),
      floatingActionButton: _botonFiltrar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  void _armarWidgets(BuildContext context, List<CostoModel> costos) {
    listado = [];
    listado.add(filtros());
    listado.add(titulos(context));
    costos.forEach((costo) {
      listado.add(_costo(costo, context));
    });
  }

  Widget _appBar() {
    return AppBar(
      title: Center(
        child: Text('Buscar costos por:'),
      ),
    );
  }

  Widget _botonFiltrar(BuildContext context) {
    final filData = Provider.of<FiltrosCostosData>(context, listen: false);
    final String idCul = _selectedCultivo != null
        ? _selectedCultivo.idCultivo.toString()
        : 'todos';
    final String idPro = _selectedProductoActividad != null
        ? _selectedProductoActividad.idProductoActividad.toString()
        : 'todos';
    final String idCon = _selectedConcepto != null
        ? _selectedConcepto.idConcepto.toString()
        : 'todos';

    return FloatingActionButton(
      child: Icon(Icons.filter_list),
      onPressed: () {
        filData.filtrar(idCul, _fechaDesde, _fechaHasta, idPro, idCon);
        setState(() {});
      },
    );
  }

  Widget filtros() {
    return Column(
      children: [
        SizedBox(
          height: 3.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 8.0),
            Text('Cultivo: '),
            _seleccioneCultivo(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 8.0),
            Text('Desde:'),
            _fFechaDesde(context),
            Text(' hasta:'),
            _fFechaHasta(context),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 8.0),
            Text('Producto o actividadad: '),
            _seleccioneProductoActividad(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
          _fechaDesde = DateFormat('yyyyMMdd').format(picked);
          controlDesde.text = _fechaDesde;
        }
        if (n == 2) {
          _fechaHasta = DateFormat('yyyyMMdd').format(picked);
          controlHasta.text = DateFormat('dd-MM-yyyy').format(picked);
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
          future: _proActOper.consultarProductosActividades(),
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
        criterioUnidad(costo.fkidProductoActividad, ancho*0.15),
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

  Widget criterioFuture(String fk, double ancho){
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
            child: CircularProgressIndicator(strokeWidth: 2.0,),
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
            child: CircularProgressIndicator(strokeWidth: 2.0,),
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
}
