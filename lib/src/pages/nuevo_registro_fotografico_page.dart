
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:agrolibreta_v2/src/widgets/cultivo_dropdown.dart';
import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';
import 'package:agrolibreta_v2/src/dataproviders/registro_fotograficos_data.dart';
import 'package:agrolibreta_v2/src/data/cultivo_operations.dart';

class NuevoRegistroFotograficoPage extends StatefulWidget {

  @override
  _NuevoRegistroFotograficoPageState createState() => _NuevoRegistroFotograficoPageState();
}

class _NuevoRegistroFotograficoPageState extends State<NuevoRegistroFotograficoPage> {

  File imagenFile;
  final _picker = ImagePicker();
  String imagenRuta = '';
  CultivoOperations culOper = new CultivoOperations();
  bool _bloquearCheck = false;

  final Map _costos = {
    0: {
      'fecha': '21-07-2020',
      'cant': 2,
      'und.': 'lt',
      'nombre': 'fungicida',
      'v.und': 50000,
      'v.total': 100000,
      'regFot':false,
    },
    1: {
      'fecha': '24-07-2020',
      'cant': 3,
      'und.': 'bultos',
      'nombre': 'triple 15',
      'v.und': 80000,
      'v.total': 240000,
      'regFot':true,
    },
    2: {
      'fecha': '28-07-2020',
      'cant': 2,
      'und.': 'bultos',
      'nombre': 'triple 15',
      'v.und': 80000,
      'v.total': 160000,
      'regFot':false,
    }
  };
  
  // ignore: unused_field
  CultivoModel _selectedCultivo;
  callback2(selectedCultivo) {
    setState(() {
      _selectedCultivo = selectedCultivo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:Center(
          child:Column(
            children: [
              Text('Nuevo'),
              Text('Registro Fotografico'),
            ],
          )
        ),
        actions: <Widget>[
           IconButton(
          iconSize: 30.0,
          icon: new Icon(Icons.photo_camera),
          onPressed:_getImagen,
          )
        
        ],
      ),
      body:Stack(//SingleChildScrollView(
        //padding:EdgeInsets.all(15.0),
        children:<Widget> [
          Column(
            children:[
              Container(
                width: double.infinity,
                height: 274.0,
                color: Colors.white,
                child: imagenFile == null 
                    ? Image.asset('assets/no-image.png', height: 300.0)
                    : Image.file(imagenFile),
              ),
              SizedBox(height: 20),
              Text('Seleccione los costos asociados a esta imagen'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Cultivo: '),
                  _seleccioneCultivo(),
                ],
              ),
            ]
          ),  
          //titulos(context),
          ListView.builder(
            padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 390.0, bottom: 20.0),
            itemCount: _costos.length,
            itemBuilder: (context, index) {
              return _costo(_costos[index], context, index);
            },
          ),
          _crearBoton(),
        ]
          
      )
    );
  }

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

  // Widget titulos(BuildContext context) {
  //   //estas variables permiten obtener el ancho para ser asignado a cada criterio
  //   final double ancho = MediaQuery.of(context).size.width;
  //   return Container(
  //     padding: EdgeInsets.only(top: 360.0),
  //     child: Row(
  //       children: <Widget>[
  //         SizedBox(
  //           width: 5.0,
  //         ),
  //         criterio('Fecha', ancho * 0.20),
  //         criterio('Cant', ancho * 0.10),
  //         criterio('Nombre', ancho * 0.30),
  //         criterio('V.und', ancho * 0.14),
  //         criterio('Seleccione', ancho*0.20),
  //         SizedBox( width: 5.0)
  //       ],
  //     ),
  //   );
  // }

   Widget _costo(Map costo, BuildContext context, index) {
    //final double ancho = MediaQuery.of(context).size.width;
    // return Row(
    //   children: <Widget>[
    //     SizedBox( width: 5.0),
    //     criterio(costo['fecha'], ancho * 0.20),
    //     criterio(costo['cant'].toString(), ancho * 0.10),
    //     criterio(costo['nombre'], ancho * 0.30),
    //     criterio(costo['v.und'].toString(), ancho * 0.14),
    //     //criterio(costo['regFot'].checkBox(), ancho*0.20),
    //     criterioCheck(costo['regFot'], ancho * 0.20),
    //     SizedBox(width: 5.0)
    //   ],
    // );
      final _fecha = costo['fecha'];
      final _cantidad = costo['cant'];
      final _vUnidad = costo['v.und'];
      //final Map _selectedData = {};
    return CheckboxListTile(
          value:_bloquearCheck,//_selectedData.indexOf(costo[index])< 0 ? false : true,
          title: Text(costo['nombre']),
          subtitle: Text('''Fecha: $_fecha - Cantidad: $_cantidad -
          V.unidad: $_vUnidad'''),
          onChanged:(valor){
            //if(_bloquearCheck == true){//_selectedData.indexOf(costo[index])< 0){
              setState(() {
                _bloquearCheck = valor;//_selectedData.addEntries(costo[index]);
              });
            //}else{
              // setState(() {
              //   _selectedData.removeWhere((key, value) => costo[index]);
              // });
            //}
            print(_bloquearCheck);
          }
        );
      
    
  }

  // Widget criterio(String valor, double ancho) {
  //   return Container(
  //     height: 25.0,
  //     width: ancho,
  //     margin: EdgeInsets.all(1.0),
  //     decoration: BoxDecoration(
  //         color: Colors.black12, borderRadius: BorderRadius.circular(3.0)),
  //     child: Center(child: Text(valor)),
  //   );
  // }
  // Widget criterioCheck(bool valor, double ancho){
  //   return Container(
  //     height: 25.0,
  //     width: ancho,
  //     margin: EdgeInsets.all(1.0),
  //     decoration: BoxDecoration(
  //         color: Colors.black12, borderRadius: BorderRadius.circular(3.0)),
  //     child: Center(child:checkBox()),
  //   );
  // }
  // Widget checkBox(){
  //   return Checkbox(
  //     value: _bloquearCheck, 
  //     onChanged:(valor){
  //       setState(() {
  //         _bloquearCheck = valor;
  //       });
  //     }
  //   );
    
  // }

  void _getImagen() async{
    final imagen = await _picker.getImage(source:ImageSource.camera);
    setState(() {
      if(imagen != null){
      imagenFile = File(imagen.path); 
        
      //_imagen = localImage;
      // final bytes = _imagen.readAsBytesSync();
      // final imagenNow = base64Encode(bytes);
      //imagenRuta = pathRuta;
      //print('String Imagen $imagenRuta');
    }else{
      print('No Image Selected');
    }
    });
  }
  Widget _crearBoton() {
    return ElevatedButton(
      child: Text('Guardar', style: TextStyle(fontSize: 20.0),),
      onPressed: _guardarImagen,
      
    );
  }
  void _guardarImagen()async{
    final String pathRuta = (await getTemporaryDirectory()).path+'${DateTime.now()}.png';
    final File localImage = await imagenFile.copy('$pathRuta');
      imagenFile = localImage;
      imagenRuta = pathRuta;
    // setState(()async {
    //   final File localImage = await imagenFile.copy('$pathRuta');
    //   imagenFile = localImage;
    //   imagenRuta = pathRuta;
    // });
    final regFotData = Provider.of<RegistrosFotograficosData>(context, listen: false);
    regFotData.nuevoRegFotografico(imagenRuta);
    print(imagenRuta);
    mostrarSnackbar('Imagen guardada');
    Navigator.pop(context);
  }
  //metodo para crear el aviso de 'imagen guardada'         
  void mostrarSnackbar(String mensaje){
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds:2500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}

