import 'package:agrolibreta_v2/src/dataproviders/cultivo_data.dart';
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

    final cosData = Provider.of<CostosData>(context, listen: true);
    final _sumasAll = cosData.sumasList;
    final _conceptosAll = cosData.conceptosList;
    final _sugeridos = cosData.sugeridosList;
    final culData = Provider.of<CultivoData>(context, listen: false);
    culData.conceptos = [];
    culData.porcentajes = [];
    culData.consultarMR(cultivoArg.fkidModeloReferencia);

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
    });

    return Scaffold(
      appBar: _appBar(context, nombreCul, idCul),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            padding:
                EdgeInsets.only(left: 0.0, right: 0.0, top: 25.0, bottom: 20.0),
            itemCount: 4,
            itemBuilder: (context, i) {
              if (_conceptosAll.length > 0) {
                return _concepto(
                    _conceptosAll[idCul - 1][i].nombreConcepto,
                    _sumasAll[idCul - 1][i],
                    _sugeridos[idCul - 1][i],
                    _conceptosAll[idCul - 1][4 + i].nombreConcepto,
                    _sumasAll[idCul - 1][4 + i],
                    _sugeridos[idCul - 1][4 + i],i+1);
              } else
                return Center(
                  child: Text('Actualizar'),
                );
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
          onPressed: () =>
              Navigator.pushNamed(context, 'configCultivo', arguments: idCul),
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
      double totalCostoSugerido2,
      int n) {
    //colores, verde si esta bajo el presupuesto y rojo caso contrario
    TextStyle color1;
    TextStyle color2;

    if (totalCosto > totalCostoSugerido) {
      color1 = new TextStyle(color: Colors.red);
    } else {
      color1 = new TextStyle(color: Colors.black);
    }

    if (totalCosto2 > totalCostoSugerido2) {
      color2 = new TextStyle(color: Colors.red);
    } else {
      color2 = new TextStyle(color: Colors.black);
    }
    String img1 = n.toString();
    String img2 = (n+4).toString();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRect(
          child: Container(
            height: 150.0,
            width: 150.0,
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.lightGreen.shade200,
                borderRadius: BorderRadius.circular(20.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Image(
                  image: AssetImage('assets/concepto$img1.png'),
                  width: 135.0,
                  height: 85.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 5.0),
                Text(concepto),
                Text('Total: ${totalCosto.toString()}', style: color1),
                Text('Limite: ${totalCostoSugerido.toString()}'),
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
                color: Colors.lightGreen.shade200,
                borderRadius: BorderRadius.circular(20.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Image(
                  image: AssetImage('assets/concepto$img2.png'),
                  width: 135.0,
                  height: 85.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 5.0),
                Text(concepto2),
                Text('Total: ${totalCosto2.toString()}', style: color2),
                Text('Limite: ${totalCostoSugerido2.toString()}'),
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
                BoxDecoration(shape: BoxShape.circle, color: Color(0xff8c6d62)),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
