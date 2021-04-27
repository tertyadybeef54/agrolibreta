import 'package:flutter/material.dart';

class DetalleRegistroFotograficoPage extends StatelessWidget {
const DetalleRegistroFotograficoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
          children: [
            Text('Detalle'),
            Text('Registro Fotografico'),
          ],),
        ),   
      ),
      body:Column(
        children:[Image.asset('assets/no-image.png'),
        _crearBoton(),
        ]),
      floatingActionButton: FloatingActionButton(
       child: Icon(Icons.add),
       onPressed: ()=>Navigator.pushNamed(context,'nuevoRegistroFoto'),
      ),
    );
  }
   Widget _crearBoton() {
    return ElevatedButton(
      child: Text('Guardar', style: TextStyle(fontSize: 20.0),),
      onPressed: (){}
    );
  }
}