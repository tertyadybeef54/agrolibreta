import 'package:agrolibreta_v2/src/widgets/modelo_referencia_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//import 'package:agrolibreta_v2/src/modelos/estado_model.dart';
import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';
import 'package:agrolibreta_v2/src/modelos/ubicacion_model.dart';
import 'package:agrolibreta_v2/src/modelos/modelo_referencia_model.dart';
//import 'package:agrolibreta_v2/src/modelos/producto_agricola_model.dart';

import 'package:agrolibreta_v2/src/data/cultivo_operations.dart';
import 'package:agrolibreta_v2/src/data/estados_operations.dart';
import 'package:agrolibreta_v2/src/data/ubicaciones_operations.dart';
import 'package:agrolibreta_v2/src/data/producto_agricola_operations.dart';
import 'package:agrolibreta_v2/src/data/modelos_referencia_operations.dart';

import 'package:agrolibreta_v2/src/widgets/ubicaciones_dropdown.dart';
import 'package:provider/provider.dart';

import 'package:agrolibreta_v2/src/dataproviders/cultivos_data.dart';

class CrearCultivoPage extends StatefulWidget {
  @override
  _CrearCultivoPageState createState() => _CrearCultivoPageState();
}

class _CrearCultivoPageState extends State<CrearCultivoPage> {
  ModelosReferenciaOperations modRefOper = new ModelosReferenciaOperations();
  CultivoOperations operacionCultivo = new CultivoOperations();
  UbicacionesOperations ubicacionesOperations = new UbicacionesOperations();
  EstadosOperations estadosOperations = new EstadosOperations();
  ModelosReferenciaOperations modelosReferenciaOperations =
      new ModelosReferenciaOperations();
  ProductoAgricolaOperations productoAgricolaOperations =
      new ProductoAgricolaOperations();

  UbicacionModel _selectedUbicacion;
  callback(selectedUbicacion) {
    setState(() {
      _selectedUbicacion = selectedUbicacion;
    });
  }

  ModeloReferenciaModel
      _selectedModeloReferencia; //modeloreferencia seleccionado en el dropdown
  callback2(selectedModeloReferencia) {
    setState(() {
      _selectedModeloReferencia = selectedModeloReferencia;
    });
  }

  //estilo de texto letra tamaño 20
  final _style = new TextStyle(
    fontSize: 20.0,
  );
  TextEditingController controlFecha = new TextEditingController();

  //variables por defecto al crear un registro de cultivo
  int _idEstado = 1; // activo por defecto.
  int _idModeloReferencia = 1; // modelo por defecto.
  int _idProductoAgricola = 1; // arveja por defecto
  //valores para crear el cultivo, el id es automatico
  String _nombreDistintivo = 'nn'; //nn sin especificar
  double _areaSembrada = 1;
  String _fechaInicio = 'nn';
  // ignore: unused_field
  String _fechaFinal = 'nn';
  int _presupuesto = 1;
  double _precioVentaIdeal = 1;
  //variables para crear la ubicacion
  String _nombreUbicacion = 'nn';
  String _desUbicacion = 'nn';
  int _estadoUbi = 1; //estado ubi activa, por defecto
  // cuando crea una nueva ubicacion el estado es 1=activo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Registrar cultivo',
            style: _style,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
        children: [
          SizedBox(height: 20.0),
          Text(
            'Seleccione el modelo de referencia: ',
            style: _style,
          ),
          _seleccioneMR(),
          Divider(),
          Text(
            'Seleccione la ubicacion para el cultivo: ',
            style: _style,
          ),
          _seleccionarUbicacionCultivo(),
          Divider(),
          _input('Nombre distintivo para el cultivo', '',
              'Ejemplo: Arveja con Luis', TextInputType.name, 1),
          Divider(),
          _input('Area a sembrar en metros cuadrados', '10000',
              'Ejemplo: 10000', TextInputType.number, 2),
          Divider(),
          _fecha(context),
          Divider(),
          _input('Presupuesto estimado', '5000000', 'Ejemplo: 5000000',
              TextInputType.number, 3),
          Divider(),
          _guardar(context),
        ],
      ),
    );
  }

  //seleccionar modelo de referencia
  Widget _seleccioneMR() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: [
      Icon(Icons.article, color: Colors.black45),
      SizedBox(width: 30.0),
      FutureBuilder<List<ModeloReferenciaModel>>(
        future: modRefOper.consultarModelosReferencia(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ModeloReferenciaDropdowun(snapshot.data, callback2)
              : Text('Usar por defecto');
        },
      ),
    ],);
  }

  //##############################################################
  //Seleccionar la ubicacion para el cultivo
  Widget _seleccionarUbicacionCultivo() {
    return Row(
      children: [
        Icon(Icons.add_location),
        SizedBox(width: 30.0),
        FutureBuilder<List<UbicacionModel>>(
          future: ubicacionesOperations.consultarUbicaciones(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? UbicacionesDropdowun(snapshot.data, callback)
                : Text('sin ubicaciones');
          },
        ),
        Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 9.0, vertical: 8.8),
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.lightBlue),
            ),
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: () => _registrarUbicacion(context),
            ),
          ],
        ),
      ],
    );
  }

  // dialogo para registrar una nueva ubicacion
  void _registrarUbicacion(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Registrar ubicacion'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _inputI('', 'llanito', 'Nombre de la ubicacion',
                    TextInputType.name, 4),
                Divider(),
                _inputI('', 'llanito del norte', 'Descripcion',
                    TextInputType.text, 5),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      final ubicacion = new UbicacionModel(
                        nombreUbicacion: _nombreUbicacion,
                        descripcion: _desUbicacion,
                        estado: _estadoUbi,
                      );
                      ubicacionesOperations.nuevaUbicacion(ubicacion);
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Guardar')),
            ],
          );
        });
  }

  // ingresar 4. nombre ubicacion 5. descripcion ubicacion
  Widget _inputI(String descripcion, String hilabel, String labeltext,
      TextInputType tipotext, int n) {
    var inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      hintText: hilabel,
      labelText: labeltext,
    );
    return Container(
      padding: EdgeInsets.only(bottom: 5.0),
      height: 60.0,
      width: double.infinity,
      child: TextField(
        textAlignVertical: TextAlignVertical.bottom,
        keyboardType: tipotext,
        textCapitalization: TextCapitalization.sentences,
        decoration: inputDecoration,
        onChanged: (valor) {
          setState(() {
            if (n == 4) {
              _nombreUbicacion = valor;
            }
            if (n == 5) {
              _desUbicacion = valor;
            }
          });
        },
      ),
    );
  }

  // ingresar el 1.nombre distintivo, 2.area sembrada 3.presupuesto. descripcion ubicacion
  // Se debe agregar condicion de solo enteros para 2 y 3
  Widget _input(String descripcion, String hilabel, String labeltext,
      TextInputType tipotext, int n) {
    var inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      hintText: hilabel,
      labelText: labeltext,
      helperText: descripcion,
      icon: Icon(Icons.drive_file_rename_outline),
    );
    return Container(
      width: double.infinity,
      child: TextField(
        textAlignVertical: TextAlignVertical.bottom,
        keyboardType: tipotext,
        textCapitalization: TextCapitalization.sentences,
        decoration: inputDecoration,
        onChanged: (valor) {
          setState(() {
            if (n == 1) {
              _nombreDistintivo = valor;
            }
            if (n == 2) {
              _areaSembrada = double.parse(valor);
            }
            if (n == 3) {
              _presupuesto = int.parse(valor);
            }
          });
        },
      ),
    );
  }

  // fecha
  Widget _fecha(BuildContext context) {
    return Container(
      height: 60.0,
      child: TextField(
        textAlignVertical: TextAlignVertical.bottom,
        enableInteractiveSelection: false,
        controller: controlFecha,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          hintText: 'fecha',
          labelText: 'fecha',
          helperText: 'Seleccione fecha de inicio del cultivo',
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
    //------------------------ para pruebas
    // final ModeloReferenciaModel modeloReferencia = new ModeloReferenciaModel(
    //   suma: 0,
    // );
    // final EstadoModel estado = new EstadoModel(
    //   nombreEstado: 'activo',
    // );
    // final productoagricola = new ProductoAgricolaModel(
    //   nombreProducto: 'arveja',
    // );
    // modelosReferenciaOperations.nuevoModeloReferencia(modeloReferencia);
    // estadosOperations.nuevoEstado(estado);
    // productoAgricolaOperations.nuevoProductoAgricola(productoagricola);

    //---------------------------

    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2021),
      lastDate: new DateTime(2031),
      locale: Locale('es', 'ES'),
    );
    if (picked != null) {
      setState(() {
        _fechaInicio = DateFormat('dd-MM-yyyy').format(picked);
        controlFecha.text = _fechaInicio;
      });
    }
  }

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

  void _save(BuildContext context) {
    final cultivosData = Provider.of<CultivosData>(context, listen: false);
    final cultivoTemp = new CultivoModel(
      fkidUbicacion: _selectedUbicacion.idUbicacion,
      fkidEstado: _idEstado,
      fkidModeloReferencia: _idModeloReferencia,
      fkidProductoAgricola: _idProductoAgricola,
      nombreDistintivo: _nombreDistintivo,
      areaSembrada: _areaSembrada,
      fechaInicio: _fechaInicio,
      fechaFinal: _fechaFinal,
      presupuesto: _presupuesto,
      precioVentaIdeal: _precioVentaIdeal,
    );
    cultivosData.anadirCultivo(cultivoTemp);
  }
}
