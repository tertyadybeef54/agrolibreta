import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrolibreta_v2/src/dataproviders/costos_data_provider.dart';
import 'package:agrolibreta_v2/src/widgets/producto_actividad_dropdown.dart';

import 'package:agrolibreta_v2/src/data/costo_operations.dart';
import 'package:agrolibreta_v2/src/data/concepto_operations.dart';
import 'package:agrolibreta_v2/src/data/unidad_medida_operations.dart';
import 'package:agrolibreta_v2/src/data/producto_actividad_operations.dart';
import 'package:agrolibreta_v2/src/data/registro_fotografico_operations.dart';

import 'package:agrolibreta_v2/src/modelos/costo_model.dart';

import 'package:agrolibreta_v2/src/modelos/producto_actividad_model.dart';

class EditarCostoPage extends StatefulWidget {
  @override
  EditarCostoPageState createState() => EditarCostoPageState();
}

class EditarCostoPageState extends State<EditarCostoPage> {
  //las operaciones de las 5 tablas que se usan
  //Conceptos, UnidadesMedida, ProductosActividades, RegistroFotografico, Costos
  ConceptoOperations conOper = new ConceptoOperations();
  UnidadMedidaOperations uniMedOper = new UnidadMedidaOperations();
  ProductoActividadOperations proActOper = new ProductoActividadOperations();
  RegistroFotograficoOperations regFotOper =
      new RegistroFotograficoOperations();
  CostoOperations cosOper = new CostoOperations();

  ProductoActividadModel _selectedProductoActividad;
  callback(selectedProductoActividad) {
    setState(() {
      _selectedProductoActividad = selectedProductoActividad;
    });
  }

  //estilo de texto letra tamaño 20
  final _style = new TextStyle(
    fontSize: 20.0,
  );
  TextEditingController controlFecha = new TextEditingController();
  TextEditingController _controlCantidad = new TextEditingController();
  TextEditingController _controlValor = new TextEditingController();

  String _fechaC;
  CostoModel _costoTemp;
  double _cantidad = 1;
  double _valorTotal = 0;
  bool check = false;
  @override
  Widget build(BuildContext context) {
    if (!check) {
      final CostoModel costo = ModalRoute.of(context).settings.arguments;

      final fecha = costo.fecha.toString();
      final fechaDate = DateTime.tryParse(fecha);
      final fechaFormatted = DateFormat('dd-MM-yyyy').format(fechaDate);
      controlFecha.text = fechaFormatted;
      _controlValor.text = costo.valorUnidad.round().toString();
      _controlCantidad.text = costo.cantidad.toString();
      _costoTemp = costo;
      _cantidad = costo.cantidad;
      _valorTotal = (costo.cantidad * costo.valorUnidad);
    }
    check = true;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Editar Costo',
            style: _style,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
        children: [
          SizedBox(height: 20.0),
          Text(
            'Nombre del producto o actividad: ',
            style: _style,
          ),
          _seleccioneProductoActividad(),
          Divider(),
          Row(
            children: [
              Icon(
                Icons.square_foot,
                color: Colors.black54,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text('Unidad de medida: '),
              _unidad()
            ],
          ),
          Divider(),
          _input('Cantidad de unidades o jornales', 'Ejemplo: 5',
              TextInputType.number, 1),
          Divider(),
          _input('Valor Total en pesos', 'Ejemplo: \$100000',
              TextInputType.number, 2),
          _valorUnitario(),
          Divider(),
          _fecha(context),
          Divider(),
          _guardar(context),
        ],
      ),
    );
  }

  //1. primer dropdown - productos actividades
  //##############################################################
  //Seleccionar el producto actividad para el costo
  Widget _seleccioneProductoActividad() {
    return Row(
      children: [
        Icon(Icons.label_important, color: Colors.black45),
        SizedBox(width: 30.0),
        FutureBuilder<List<ProductoActividadModel>>(
          future: proActOper.consultarProductosActividades(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ProductosActividadesDropdowun(snapshot.data, callback)
                : Text('debe crearlos');
          },
        ),
      ],
    );
  }

  Widget _unidad() {
    if (_selectedProductoActividad == null) {
      return Text('und');
    }
    print(_selectedProductoActividad.fkidUnidadMedida);
    ProductoActividadOperations _proActOper = new ProductoActividadOperations();
    return FutureBuilder<String>(
        future: _proActOper.consultarNombreUnidad(
            _selectedProductoActividad.idProductoActividad.toString()),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            child = Text(snapshot.data);
          } else if (snapshot.hasError) {
            child = Text('und');
          } else {
            child = Text('und'); //
          }
          return child;
        });
  }

  //inputs
  //###############################################
  // ingresar el nombre 1.distintivo, 2.area sembrada 3.presupuesto y 4. nombre ubicacion 5. descripcion ubicacion
  // Se debe agrgar condicion de solo enteros para 2 y 3
  Widget _input(
      String descripcion, String labeltext, TextInputType tipotext, int n) {
    var inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      labelText: labeltext,
      helperText: descripcion,
      icon: Icon(Icons.drive_file_rename_outline),
      //suffixIcon: Icon(Icons.touch_app),
    );
    return Container(
      padding: EdgeInsets.only(bottom: 5.0),
      height: 80.0,
      width: double.infinity,
      child: TextField(
        controller: n == 1 ? _controlCantidad : _controlValor,
        textAlignVertical: TextAlignVertical.bottom,
        keyboardType: tipotext,
        textCapitalization: TextCapitalization.sentences,
        decoration: inputDecoration,
        onChanged: (valor) {
          setState(() {
            if (n == 1) {
              _cantidad = double.parse(valor);
              _costoTemp.cantidad = double.parse(valor);
            }
            if (n == 2) {
              _valorTotal = double.parse(valor);
              _costoTemp.valorUnidad = (_valorTotal / _cantidad).round();
            }
          });
        },
      ),
    );
  }

  //calcular valor unidad
  Widget _valorUnitario() {
    setState(() {});
    int _valorUnidad = 1;
    if (_cantidad > 0) {
      _valorUnidad = (_valorTotal / _cantidad).round();
    } else {
      _valorUnidad = 0;
    }

    return Text(
      'Valor unitario: \$ ${_valorUnidad.toString()}',
      textAlign: TextAlign.right,
    );
  }

  //fecha
  //###############################################
  Widget _fecha(BuildContext context) {
    return Container(
      height: 60.0,
      child: TextField(
        textAlignVertical: TextAlignVertical.bottom,
        enableInteractiveSelection: false,
        controller: controlFecha,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          hintText: '',
          labelText: 'fecha: día-mes-año',
          helperText: 'Seleccione fecha de compra',
          icon: Icon(Icons.calendar_today),
          suffixIcon: Icon(Icons.touch_app),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDate(context);
        },
      ),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2021),
      lastDate: new DateTime.now(),
      locale: Locale('es', 'ES'),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xff6b9b37), // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black,
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _fechaC = DateFormat('yyyyMMdd').format(picked);
        _costoTemp.fecha = int.parse(_fechaC);
        final _fechaControler = DateFormat('dd-MM-yyyy').format(picked);
        controlFecha.text = _fechaControler;
      });
    }
  }

  //guardar
  //###############################################
  //boton _guardar y guardar en la base de datos el registro del cultivo
  Widget _guardar(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
              child: Text('Guardar'),
              onPressed: () {
                _save(context);
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }

  void _save(
    BuildContext context,
  ) {
    if (_selectedProductoActividad != null) {
      _costoTemp.fkidProductoActividad =
          _selectedProductoActividad.idProductoActividad.toString();
    }
    cosOper.updateCosto(_costoTemp);
    final cosData = Provider.of<CostosData>(context, listen: false);
    cosData.conceptosList = [];
    cosData.sumasList = [];
    cosData.sugeridosList = [];
    cosData.obtenerCostosByConceptos();
  }
}
