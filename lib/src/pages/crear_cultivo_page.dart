import 'dart:convert';
import 'package:agrolibreta_v2/src/modelos/ubicacion_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:intl/intl.dart';

class CrearCultivoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Registrar cultivo'),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        children: [
          Text('Seleccione la ubicacion para el cultivo: '),
          _seleccionarUbicacionCultivo(),
          SizedBox(height: 30.0),
          _input('Nombre del cultivo', 'Arveja 1', 'Ejemplo: Arveja 1',
              TextInputType.name),
          SizedBox(height: 30.0),
          _input('Area a sembrar en metros cuadrados', '10000',
              'por ejemplo 10000', TextInputType.number),
          SizedBox(height: 30.0),
          //_fechaCultivo(context),
          // crearFecha(context, _inputFieldController2, 'Fecha',
          //     'Fecha de inicio de actividades', 'fecha del cultivo'),
          SizedBox(height: 30.0),

          ElevatedButton(
              onPressed: () => _sincro(context), child: Text('sincro'))
          //FloatingActionButton(onPressed: _sincro())
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
            Navigator.pushReplacementNamed(context, 'crearUbicacion'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  _sincro(BuildContext context) async {
    //final sincronizar = new UbicacionesProvider();
    print('entra al boton sincro');
    //await sincronizar.cargarUbicaciones();
    await _subirUbicaciones(context);
  }

  Future<bool> _subirUbicaciones(BuildContext context) async {
    print('entra al subir ubicaciones');
    final _url = 'https://flutter-varios-41df3-default-rtdb.firebaseio.com';
    final url = '$_url/Ubicaciones.json';
    final ubicaciones = [];

    final resp = await http.get(Uri.parse(url));
    final Map<String, dynamic> decodedData2 = json.decode(resp.body);
    final ids = []; //lista de los ids de las ubicaciones
    //añadir cada uno de los ids a la lista
    decodedData2.forEach((id, value) {
      final idTemp = decodedData2[id]["idUbicacion"];
      ids.add(idTemp);
      print(idTemp);
    });

    ubicaciones.forEach((ubicacion) async {
      if (!ids.contains(ubicacion.idUbicacion)) {
        final resp = await http.post(Uri.parse(url),
            body: ubicacionModelToJson(ubicacion));

        final decodedData = json.decode(resp.body);

        print(decodedData);
      }
    });

    return true;
  }

  Widget _seleccionarUbicacionCultivo() {
    return Row(
      children: <Widget>[
        Icon(Icons.add_location),
        SizedBox(width: 30.0),
        Expanded(
          child: DropdownButton(
            value: '',
            items: getOpcionesDropdown(),
            onChanged: (opt) {},
          ),
        ),
      ],
    );
  }

  //metodo para añadir las ubicaciones al dropdown
  List<DropdownMenuItem<String>> getOpcionesDropdown() {
    List<DropdownMenuItem<String>> lista = [];
    final _ubicaciones = [];
    _ubicaciones.forEach((valor) {
      lista.add(DropdownMenuItem(
        child: Text(valor),
        value: valor,
      ));
    });
    return lista;
  }

  Widget _input(String descripcion, String hilabel, String labeltext,
      TextInputType tipotext) {
    var inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      hintText: hilabel,
      labelText: labeltext,
      helperText: descripcion,
      icon: Icon(Icons.drive_file_rename_outline),
      suffixIcon: Icon(Icons.touch_app),
    );
    return TextField(
      keyboardType: tipotext,
      textCapitalization: TextCapitalization.sentences,
      decoration: inputDecoration,
      onChanged: (valor) {
        // setState(() {
        //   //_nombreCultivo = valor;
        // });
      },
    );
  }
}
