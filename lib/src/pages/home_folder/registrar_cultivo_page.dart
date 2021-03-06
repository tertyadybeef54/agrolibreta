import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrolibreta_v2/src/widgets/ubicaciones_dropdown.dart';
import 'package:agrolibreta_v2/src/dataproviders/ubicaciones_data.dart';
import 'package:agrolibreta_v2/src/dataproviders/costos_data_provider.dart';
import 'package:agrolibreta_v2/src/widgets/modelo_referencia_dropdown.dart';

import 'package:agrolibreta_v2/src/modelos/ubicacion_model.dart';
import 'package:agrolibreta_v2/src/modelos/modelo_referencia_model.dart';

import 'package:agrolibreta_v2/src/data/ubicaciones_operations.dart';
import 'package:agrolibreta_v2/src/data/modelos_referencia_operations.dart';


class RegistrarCultivoPage extends StatefulWidget {
  @override
  _RegistrarCultivoPageState createState() => _RegistrarCultivoPageState();
}

class _RegistrarCultivoPageState extends State<RegistrarCultivoPage> {
  //Se requiere presentar en esta pantalla datos de 2 modelos
  //ubicacion_model y modelo_referencia_model, los cuales listan los dropdown
  UbicacionesOperations ubicacionesOperations = new UbicacionesOperations();
  ModelosReferenciaOperations _modRefOper = new ModelosReferenciaOperations();

 //Estas funciones son usadas para recibir la opción seleccionada en el dropdown de las ubicaciones
 //y se almacena en la variable declaradaen esta clase.
  UbicacionModel _selectedUbicacion;
  callback(selectedUbicacion) {
    setState(() {
      _selectedUbicacion = selectedUbicacion;
    });
  }
  ModeloReferenciaModel _selectedModeloReferencia;
  callback2(selectedModeloReferencia) {
    setState(() {
      _selectedModeloReferencia = selectedModeloReferencia;
    });
  }
  //letra tamaño 20
  final _style = new TextStyle(
    fontSize: 18.0,
  );
  //esta variable permite mostrar la fecha al momento que es seleccionada
  TextEditingController controlFecha = new TextEditingController();

  //variables inicializadas para crear el cultivo, el id es automatico
  String _nombreDistintivo = 'Nn'; //nn sin especificar
  double _areaSembrada = 1;
  String _fechaInicio = 'Nf';
  double _presupuesto = 1;
  //variables inicializadas para crear la ubicacion
  String _nombreUbicacion = 'Nn';
  String _desUbicacion = 'No existe';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:Text('Registrar cultivo'),
        centerTitle: true,
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
            'Seleccione la ubicación para el cultivo: ',
            style: _style,
          ),
          _seleccionarUbicacionCultivo(),
          Divider(),
          _input('Nombre distintivo para el cultivo', '',
              'Ejemplo: Arveja con Luis', TextInputType.name, 1),
          Divider(),
          _input('Área a sembrar en metros cuadrados', '10000',
              'Ejemplo: 10000 (sin punto)', TextInputType.numberWithOptions(decimal: false), 2),
          Divider(),
          _fecha(context),
          Divider(),
          _input('Presupuesto estimado', '5000000', 'Ejemplo: 5000000 (sin punto)',
              TextInputType.numberWithOptions(decimal: false), 3),
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
          future: _modRefOper.consultarModelosReferencia(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ModeloReferenciaDropdowun(snapshot.data, callback2)
                : Text('Usar por defecto');
          },
        ),
      ],
    );
  }

  //##############################################################
  //Seleccionar la ubicacion para el cultivo
  Widget _seleccionarUbicacionCultivo() {
    return Row(
      children: [
        Icon(Icons.add_location, color: Colors.black45,),
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
                  shape: BoxShape.circle, color: Color(0xff8c6d62)),
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
          //provider de las ubicaciones para cuando se crea una
          final ubiData = Provider.of<UbicacionesData>(context, listen: false);
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Registrar ubicación'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _inputI('', 'llanito', 'Nombre de la ubicación',
                    TextInputType.name, 4),
                Divider(),
                _inputI('', 'llanito del norte', 'Descripción',
                    TextInputType.text, 5),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    ubiData.anadirUbicacion(_nombreUbicacion, _desUbicacion);
                    setState(() {});
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
              _presupuesto = double.parse(valor);
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
          hintText: 'fecha día-mes-año',
          labelText: 'fecha día-mes-año',
          helperText: 'Fecha de inicio de actividades del cultivo',
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
      lastDate: new DateTime(2031),
      locale: Locale('es', 'ES'),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xff6b9b37),// header background color
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
    final cosData = Provider.of<CostosData>(context, listen: false);
    cosData.conceptosList = [];
    cosData.sumasList = [];
    cosData.sugeridosList = [];
    cosData.anadirCultivo(
      _selectedUbicacion.idUbicacion.toString(),
      _selectedModeloReferencia.idModeloReferencia.toString(),
      _nombreDistintivo,
      _areaSembrada.round(),
      _fechaInicio,
      _presupuesto.round()
    );
  }
}
