
import 'package:flutter/material.dart';
import 'dart:io';

class DetalleRegistroFotograficoPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final numero = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Column(
            children: [
              Text('Detalle'),
              Text('Registro Fotografico'),
            ],
          ),
        ),   
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
        children: <Widget>[
        
          Hero(
            tag: numero,
            child: ClipRRect(
              child: Container(
                width: double.infinity,
                height: 400.0,
                color: Colors.white,
                child: Image.file(File(numero),) //fit: BoxFit.cover),
              ),
            ),    
          ),
          _crearBoton(),
        ],
        ),
      ),
      
    );
  }
   Widget _crearBoton() {
    return ElevatedButton(
      child: Text('Editar', style: TextStyle(fontSize: 20.0),),
      onPressed: (){}
    );
  }
}