import 'package:agrolibreta_v2/src/data/costo_operations.dart';
import 'package:agrolibreta_v2/src/data/producto_actividad_operations.dart';
import 'package:agrolibreta_v2/src/modelos/costo_model.dart';
import 'package:agrolibreta_v2/src/modelos/registro_fotografico_model.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:intl/intl.dart';

class DetalleRegistroFotograficoPage extends StatelessWidget {

  final ProductoActividadOperations _proActOper =
      new ProductoActividadOperations();
  final CostoOperations _cosOper = new CostoOperations();
  
  @override
  Widget build(BuildContext context) {
    final RegistroFotograficoModel imagen =
        ModalRoute.of(context).settings.arguments;

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
      body: futureCostos(imagen),
    );
  }

  Widget futureCostos(RegistroFotograficoModel imagen) {
    final id = imagen.idRegistroFotografico.toString();
    return FutureBuilder<List<CostoModel>>(
        future: _cosOper.costosByRegisto(id),
        builder:
            (BuildContext context, AsyncSnapshot<List<CostoModel>> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            print(snapshot.data);
            child = img(context, imagen, snapshot.data);
          } else if (snapshot.hasError) {
            child = Text(snapshot.error);
          } else {
            child = SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
              ),
              width: 200,
              height: 200, //
            );
          }
          return child;
        });
  }

  Widget _crearBoton(BuildContext context, RegistroFotograficoModel imagen){
    return Center(
      child: Column(
        children: [
          ElevatedButton(
              child: Text(
                'Editar',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () {
                Navigator.pushNamed(context, 'editarRegistro',
                arguments: imagen);
              }),
        ],
      ),
    );
  }

  void mostrarSnackbar(BuildContext context, String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 2500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Widget img(BuildContext context, RegistroFotograficoModel imagen,
      List<CostoModel> costos) {
    return ListView(
      children: armarWidgets(context, costos, imagen),
    );
  }

  List<Widget> armarWidgets(BuildContext context, List<CostoModel> costos,
      RegistroFotograficoModel imagen) {
    List<Widget> listado = [];
    listado.add(_heroimg(imagen));
    listado.add(_crearBoton(context, imagen));
    listado.add(_titulos(context));
    costos.forEach((costo) {
      listado.add(_costo(context, costo));
    });
    return listado;
  }

  Widget _heroimg(RegistroFotograficoModel imagen) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Hero(
        tag: imagen.pathFoto,
        child: ClipRRect(
          child: Container(
              width: double.infinity,
              height: 400.0,
              color: Colors.white,
              child: Image.file(
                File(imagen.pathFoto),
              ) //fit: BoxFit.cover),
              ),
        ),
      ),
    );
  }

  Widget _titulos(BuildContext context) {
    //estas variables permiten obtener el ancho para ser asignado a cada criterio
    final double ancho = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 5.0,
        ),
        criterio('Fecha', ancho * 0.15),
        criterio('Cant', ancho * 0.1),
        criterio('Nombre', ancho * 0.34),
        criterio('V.und', ancho * 0.20),
        SizedBox(
          width: 5.0,
        )
      ],
    );
  }

  Widget _costo(
    BuildContext context,
    CostoModel costo,
  ) {
    final double ancho = MediaQuery.of(context).size.width;
    final fecha = costo.fecha.toString();
    final fechaDate = DateTime.tryParse(fecha);
    final fechaFormatted = DateFormat('dd-MM-yy').format(fechaDate);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 5.0,
        ),
        criterio(fechaFormatted, ancho * 0.15), //fecha
        criterio(costo.cantidad.toString(), ancho * 0.1), //cantidad
        criterioFuture(costo.fkidProductoActividad, ancho * 0.34),
        criterio(costo.valorUnidad.toString(), ancho * 0.2),
        //valor unidad
        SizedBox(
          width: 5.0,
        )
      ],
    );
  }

  Widget criterio(String valor, double ancho) {
    return Container(
      height: 25.0,
      width: ancho,
      margin: EdgeInsets.all(1.0),
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(3.0)),
      child: Center(child: Text(valor)),
    );
  }

  Widget criterioFuture(String fk, double ancho) {
    return FutureBuilder<String>(
        future: _proActOper.consultarNombre(fk),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            child = Text(snapshot.data);
          } else if (snapshot.hasError) {
            child = Text('nn');
          } else {
            child = SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
              width: 10,
              height: 10, //
            );
          }
          return Container(
              height: 25.0,
              width: ancho,
              margin: EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(3.0)),
              child: Center(child: child));
        });
  }
}
