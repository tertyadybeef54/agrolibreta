import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String nombre = '';
  String cultivo = '';
  String fecha = '';
  String ubicacion = '';
  String estado = '';
  double areaSembrada = 0;
  int presupuesto = 0;
  double precioVenta = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('        Mis Cultivos')),
        actions: <Widget>[
          IconButton(
            iconSize: 40.0,
            icon: new Icon(Icons.account_circle),
            onPressed: () => Navigator.pushNamed(context, 'perfilUsuario'),
          ),
        ],
      ),
      body: _crearListaDeCultivo(),
      floatingActionButton: _agregarCultivo(),
    );
  }

  ListView _crearListaDeCultivo() {
    return ListView(padding: EdgeInsets.all(20.0), children: [
      _crearCards(),
      _crearCards(),
      _crearCards(),
    ]);
  }

  Widget _crearCards() {
    return Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Row(
          children: <Widget>[
            Image(
              image: AssetImage('assets/plant.jpg'),
              width: 100.0,
              height: 210.0,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0),
                Text('Nombre: $nombre'),
                Text('Cultivo de: $cultivo'),
                Text('Fecha: $fecha'),
                Text('Ubicación: $ubicacion'),
                Text('Estado: $estado'),
                Text('Área Sembrada: $areaSembrada'),
                Text('Presupuesto: $presupuesto'),
                Text('Precio de Venta: $precioVenta'),
                SizedBox(height: 20.0),
                //TextButton(onPressed: () {}, child: Text('Entrar')),
                _botonEntrar(context),
              ],
            ),
          ],
        ));
  }

//botton para añadir nuevo cultivo
  Widget _agregarCultivo() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.pushNamed(context, 'crearCultivo');
      },
    );
  }

  Widget _botonEntrar(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pushNamed(context, 'resumenCostos');
        },
        child: Text('Entrar'));
  }
}
