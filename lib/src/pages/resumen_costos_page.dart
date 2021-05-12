import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrolibreta_v2/src/dataproviders/costos_data_provider.dart';

class ResumencostosPage extends StatefulWidget {
  @override
  _ResumencostosPageState createState() => _ResumencostosPageState();
}

class _ResumencostosPageState extends State<ResumencostosPage> {
  @override
  Widget build(BuildContext context) {
    final CultivoModel cultivoArg = ModalRoute.of(context).settings.arguments;

    final nombreCul = cultivoArg.nombreDistintivo;
    final idCul = cultivoArg.idCultivo;

    final cosData = Provider.of<CostosData>(context, listen: false);
    final _sumasAll = cosData.sumasList;
    final _conceptosAll = cosData.conceptosList;
    final _sugeridos = cosData.sugeridosList;

 /*    _cultivos.forEach((element) {
      print(element.idCultivo);
    });
    _sumasAll.forEach((element) {
      print(element.toString());
    });
    _conceptosAll.forEach((element) {
      element.forEach((e) {
        print(e.nombreConcepto);
      });
    });
    _sugeridos.forEach((element) {
      print(element.toString());
    }); */

    return Scaffold(
      appBar: _appBar(context, nombreCul, idCul),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            padding:
                EdgeInsets.only(left: 0.0, right: 0.0, top: 25.0, bottom: 20.0),
            itemCount: 4,
            itemBuilder: (context, i) {
              return _concepto(
                  _conceptosAll[idCul - 1][i].nombreConcepto,
                  _sumasAll[idCul - 1][i],
                  _sugeridos[idCul - 1][i],
                  _conceptosAll[idCul - 1][4 + i].nombreConcepto,
                  _sumasAll[idCul - 1][4 + i],
                  _sugeridos[idCul - 1][4 + i]);
            },
          ),
          _refrescar(context),
        ],
      ),
      floatingActionButton: _botonNuevoCosto(context, idCul),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _appBar(BuildContext context, String nombreCul, int idCul) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Center(
        child: Text(nombreCul),
      ),
      actions: <Widget>[
        IconButton(
          iconSize: 40.0,
          icon: new Icon(Icons.settings),
          onPressed: () => Navigator.pushNamed(context, 'configCultivo', arguments: idCul),
        ),
      ],
    );
  }

  Widget _concepto(
      String concepto,
      double totalCosto,
      double totalCostoSugerido,
      String concepto2,
      double totalCosto2,
      double totalCostoSugerido2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRect(
          child: Container(
            height: 150.0,
            width: 150.0,
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(20.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Image(
                  image: AssetImage('assets/no-image.png'),
                  width: 135.0,
                  height: 85.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 5.0),
                Text(concepto),
                Text('Total: ${totalCosto.toString()}'),
                Text('Sugerido: ${totalCostoSugerido.toString()}'),
                SizedBox(height: 5.0)
              ],
            ),
          ),
        ),
        ClipRect(
          child: Container(
            height: 150.0,
            width: 150.0,
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(20.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Image(
                  image: AssetImage('assets/no-image.png'),
                  width: 135.0,
                  height: 85.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 5.0),
                Text(concepto2),
                Text('Total: ${totalCosto2.toString()}'),
                Text('Sugerido: ${totalCostoSugerido2.toString()}'),
                SizedBox(height: 5.0)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _botonNuevoCosto(BuildContext context, int idCul) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, 'crearCosto',
          arguments: idCul.toString()),
    );
  }

  Widget _refrescar(BuildContext context) {
    return Positioned(
      top: 0.0,
      right: 0.0,
      width: 40.0,
      height: 40.0,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            color: Colors.white,
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
