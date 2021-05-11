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

    final _cultivos = cosData.cultivos;
    final _sumasAll = cosData.sumasList;
    final _conceptosAll = cosData.conceptosList;

    _cultivos.forEach((element) {
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

    return Scaffold(
      appBar: _appBar(context, nombreCul),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            padding:
                EdgeInsets.only(left: 0.0, right: 0.0, top: 30.0, bottom: 20.0),
            itemCount: 4,
            itemBuilder: (context, i) {
              return _concepto(
                  _conceptosAll[idCul-1][i].nombreConcepto,
                  _sumasAll[idCul-1][i],
                  100,
                  _conceptosAll[idCul-1][4 + i].nombreConcepto,
                  _sumasAll[idCul-1][4 + i],
                  100);
            },
          ),
          _refrescar(context),
        ],
      ),
      floatingActionButton: _botonNuevoGasto(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _appBar(BuildContext context, String nombreCul) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Center(
        child: Text(nombreCul),
      ),
      actions: <Widget>[
        IconButton(
          iconSize: 40.0,
          icon: new Icon(Icons.settings),
          onPressed: () => Navigator.pushNamed(context, 'configCultivo'),
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

  Widget _botonNuevoGasto(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, 'crearCosto'),
    );
  }

  Widget _refrescar(BuildContext context) {
    return Positioned(
      top: 2.0,
      right: 2.0,
      width: 40.0,
      height: 40.0,
      child: Ink(
        decoration: const ShapeDecoration(
          color: Colors.red,
          shape: CircleBorder(),
        ),
        child: IconButton(
          icon: const Icon(Icons.refresh),
          color: Colors.white,
          onPressed: () {
            setState(() {
            });
          },
        ),
      ),
    );
  }
}
