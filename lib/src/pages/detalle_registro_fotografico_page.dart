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
                    child: Image.file(
                      File(numero),
                    ) //fit: BoxFit.cover),
                    ),
              ),
            ),
            _crearBoton(context),
          ],
        ),
      ),
    );
  }

  Widget _crearBoton(BuildContext context) {
    return ElevatedButton(
        child: Text(
          'Editar',
          style: TextStyle(fontSize: 20.0),
        ),
        onPressed: () {
          mostrarSnackbar(context, 'en actualización');
        });
  }

  void mostrarSnackbar(BuildContext context, String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 2500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
