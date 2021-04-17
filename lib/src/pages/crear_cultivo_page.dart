import 'package:agrolibreta_v2/src/providers/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CrearCultivoPage extends StatefulWidget {
  @override
  _CrearCultivoPageState createState() => _CrearCultivoPageState();
}

class _CrearCultivoPageState extends State<CrearCultivoPage> {
  TextEditingController controlFecha = new TextEditingController();
  List<String> ubicaciones = ['ubi1', 'ubi2', 'ubi3', 'ubi4', 'ubi5'];
  String _ubicacionSeleccionada = 'ubi1';
  String idUbicacion = '1';
  String idEstado = '1';
  String idModeloReferencia = '1';
  String idProductoAgricola = '1';
  // ignore: unused_field
  String _nombreDistintivo = '';
  // ignore: unused_field
  String _areaSembrada = '';
  String _fechaInicio = '';
  String fechaFinal = '';
  // ignore: unused_field
  String _presupuesto = '';
  String precioVentaIdeal = '';

  String _ubicacion = '';
  String _desUbicacion = '';
  String _estado = '1'; // cuando crea una nueva ubicacion el estado es 1=activo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Registrar cultivo'),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 5.0),
        children: [
          SizedBox(height: 20.0),
          Text('  Seleccione la ubicacion para el cultivo: '),
          SizedBox(height: 10.0),
          _seleccionarUbicacionCultivo(),
          Divider(),
          _input('Nombre distintivo para el cultivo', '',
              'Ejemplo: Arveja con Luis', TextInputType.text, 1),
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

//##############################################################
//
//Seleccionar la ubicacion para el cultivo
  List<DropdownMenuItem<String>> getOpcionesDropdown() {
    //DBProvider.db.database;
    List<DropdownMenuItem<String>> lista = [];
    ubicaciones.forEach((ubicacion) {
      lista.add(DropdownMenuItem(
        child: Text(ubicacion),
        value: ubicacion,
      ));
    });
    return lista;
  }

  Widget _seleccionarUbicacionCultivo() {
    return Row(
      children: [
        Icon(Icons.add_location),
        SizedBox(width: 30.0),
        DropdownButton(
          value: _ubicacionSeleccionada,
          icon: Icon(Icons.keyboard_arrow_down),
          underline: Container(height: 2, color: Colors.black),
          items: getOpcionesDropdown(),
          onChanged: (opt) {
            setState(() {
              _ubicacionSeleccionada = opt;
            });
          },
        ),
        SizedBox(width: 15.0),
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

// ingresar el nombre 1.distintivo, 2.area sembrada y 3.presupuesto
  Widget _input(String descripcion, String hilabel, String labeltext,
      TextInputType tipotext, int n) {
    var inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      hintText: hilabel,
      labelText: labeltext,
      helperText: descripcion,
      icon: Icon(Icons.drive_file_rename_outline),
      //suffixIcon: Icon(Icons.touch_app),
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
            if (n == 1) {
              _nombreDistintivo = valor;
            }
            if (n == 2) {
              _areaSembrada = valor;
            }
            if (n == 3) {
              _presupuesto = valor;
            }
            if (n == 4) {
              _ubicacion = valor;
            }
            if (n == 5) {
              _desUbicacion = valor;
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
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2021),
      lastDate: new DateTime(2030),
      locale: Locale('es', 'ES'),
    );
    if (picked != null) {
      setState(() {
        _fechaInicio = DateFormat('yyyy-MM-dd').format(picked);
        controlFecha.text = _fechaInicio;
      });
    }
  }

  //boton _guardar y guardar en la base de datos el registro del cultivo
  Widget _guardar(BuildContext context) {
    return ElevatedButton(
        onPressed: () => _save(context), child: Text('Guardar'));
  }

  _save(BuildContext context) {}

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
                _input('Nombre de la ubicacion', '', '', TextInputType.name, 4),
                Divider(),
                _input('Descripcion', '', '', TextInputType.text, 5),
              ],
            ),
            actions: [
              TextButton(onPressed: () {}, child: Text('Guardar')),
            ],
          );
        });
  }
}
