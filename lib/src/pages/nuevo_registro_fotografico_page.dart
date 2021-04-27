import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class NuevoRegistroFotograficoPage extends StatefulWidget {

  @override
  _NuevoRegistroFotograficoPageState createState() => _NuevoRegistroFotograficoPageState();
}

class _NuevoRegistroFotograficoPageState extends State<NuevoRegistroFotograficoPage> {
  File image;
  final _picker = ImagePicker();
  final _lista = ['cultivo_1','cultivo_2','cultivo_3',];
  var _vista = 'Seleccione un cultivo';

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
          icon: new Icon(Icons.image),
          onPressed:_selectImage,
          ),
           IconButton(
          iconSize: 30.0,
          icon: new Icon(Icons.photo_camera),
          onPressed:_tomarFoto,
          )
        
        ],
      ),
      body: SingleChildScrollView(
        child:Container(
          padding:EdgeInsets.all(15.0),
          child: Column(
            children:[
              
              mostrarImagen(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text('Cultivo: '),
                DropdownButton(
                  items: _lista.map((String a){
                    return DropdownMenuItem(
                      value: a,
                      child: Text(a));
                  }).toList(),
                  onChanged:(_value) =>{
                    setState((){
                      _vista = _value;
                    })
                  },
                  hint: Text(_vista),
                ),],
              ),
              _crearBoton(),
            ],
          )
          
        )
      
      )
    );

  }

  Widget _crearBoton() {
    return ElevatedButton(
      child: Text('Guardar', style: TextStyle(fontSize: 20.0),),
      onPressed: (){}
    );
  }
  Widget mostrarImagen(){
    if(image!= null){
      return Image.file(
        image, 
        height: 300.0,
        fit:BoxFit.cover,
      );
    }else {
      return Image.asset('assets/no-image.png');
    }
  }

  Future _selectImage()async{
      _procesarImagen(ImageSource.gallery);
  } 
      
  Future _tomarFoto()async{
    _procesarImagen(ImageSource.camera);
  } 

  Future _procesarImagen(ImageSource origen)async{
      final pickedFile = await _picker.getImage(source:origen);
      
      try{
        image = File(pickedFile.path);
      }catch(e){ print('$e'); }

      if(image!= null){}

      setState(() {});
  }
}

