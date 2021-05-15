//import 'dart:convert';

import 'package:agrolibreta_v2/src/dataproviders/registro_fotograficos_data.dart';
import 'package:flutter/material.dart';
import 'dart:io';
//import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class NuevoRegistroFotograficoPage extends StatefulWidget {
  @override
  _NuevoRegistroFotograficoPageState createState() =>
      _NuevoRegistroFotograficoPageState();
}

class _NuevoRegistroFotograficoPageState
    extends State<NuevoRegistroFotograficoPage> {
  File imagenFile;
  final _picker = ImagePicker();
  String imagenRuta = '';
  final _lista = [
    'cultivo_1',
    'cultivo_2',
    'cultivo_3',
  ];
  var _vista = 'Seleccione un cultivo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
              child: Column(
            children: [
              Text('Nuevo'),
              Text('Registro Fotografico'),
            ],
          )),
          actions: <Widget>[
            // IconButton(
            // iconSize: 30.0,
            // icon: new Icon(Icons.image),
            // onPressed:_selectImage,
            // ),
            IconButton(
              iconSize: 30.0,
              icon: new Icon(Icons.photo_camera),
              onPressed: _getImagen,
            )
          ],
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 274.0,
                  color: Colors.white,
                  child: imagenFile == null
                      ? Image.asset('assets/no-image.png', height: 300.0)
                      : Image.file(imagenFile),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Cultivo: '),
                    DropdownButton(
                      items: _lista.map((String a) {
                        return DropdownMenuItem(value: a, child: Text(a));
                      }).toList(),
                      onChanged: (_value) => {
                        setState(() {
                          _vista = _value;
                        })
                      },
                      hint: Text(_vista),
                    ),
                  ],
                ),
                _crearBoton(),
              ],
            )));
  }

  void _getImagen() async {
    final imagen = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      if (imagen != null) {
        imagenFile = File(imagen.path);

        //_imagen = localImage;
        // final bytes = _imagen.readAsBytesSync();
        // final imagenNow = base64Encode(bytes);
        //imagenRuta = pathRuta;
        //print('String Imagen $imagenRuta');
      } else {
        print('No Image Selected');
      }
    });
  }

  Widget _crearBoton() {
    return ElevatedButton(
      child: Text(
        'Guardar',
        style: TextStyle(fontSize: 20.0),
      ),
      onPressed: _guardarImagen,
    );
  }

  void _guardarImagen() async {
    if (imagenFile == null) {return;}

    final String pathRuta =
        (await getTemporaryDirectory()).path + '${DateTime.now()}.png';
    final File localImage = await imagenFile.copy('$pathRuta');
    imagenFile = localImage;
    imagenRuta = pathRuta;
    final regFotData =
        Provider.of<RegistrosFotograficosData>(context, listen: false);
    regFotData.nuevoRegFotografico(imagenRuta);
    print(imagenRuta);
    //mostrarSnackbar('Imagen guardada');
    Navigator.pop(context);
  }
  // metodo para crear el aviso de 'imagen guardada'
  // void mostrarSnackbar(String mensaje){
  //   final snackbar = SnackBar(
  //     content: Text(mensaje),
  //     duration: Duration(milliseconds:2500),
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackbar);
  // }
}
