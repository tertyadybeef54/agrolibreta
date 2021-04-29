import 'dart:ui';

import 'package:flutter/material.dart';

class ResumencostosPage extends StatelessWidget {
  final String _nombreCul = '        Arveja de abril';
  final List<String> _conceptos = [
    'semilla',
    'insumos',
    'otros',
  ];
  final List<String> _conceptos2 = ['mano de obra', 'transporte', 'alguno'];
  final List<double> _sumas = [100, 200, 300];
  final List<double> _sumas2 = [300, 100, 100];
  final List<double> _sugeridos = [110, 205, 400];
  final List<double> _sugeridos2 = [400, 90, 100];

  @override
  Widget build(BuildContext context) {
    //final double mitad = MediaQuery.of(context).size.width / 2;
    return Scaffold(
      appBar: _appBar(context),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            padding:
                EdgeInsets.only(left: 0.0, right: 0.0, top: 30.0, bottom: 20.0),
            itemCount: _conceptos.length,
            itemBuilder: (context, index) {
              return _concepto(
                  _conceptos[index],
                  _sumas[index],
                  _sugeridos[index],
                  _conceptos2[index],
                  _sumas2[index],
                  _sugeridos2[index]);
            },
          ),
        ],
      ),
      floatingActionButton: _botonNuevoGasto(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  //metodo que crear el widget del appBar
  Widget _appBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Center(
        child: Text(_nombreCul),
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

//Metodo para crar cada uno de las cuatro clasificaciones de los gastos
  Widget _concepto(String concepto, double totalCosto, double totalSugerido,
      String concepto2, double totalCosto2, double totalSugerido2) {
    return Row(
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
                Text('Sugerido: ${totalSugerido.toString()}'),
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
                Text('Sugerido: ${totalSugerido2.toString()}'),
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
}
