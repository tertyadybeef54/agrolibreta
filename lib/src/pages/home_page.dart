import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';
import 'package:agrolibreta_v2/src/dataproviders/cultivos_data.dart';

class HomePage extends StatelessWidget {
  //final String nombre = '';
  final String cultivo = '';
  final String fecha = '';
  final String ubicacion = '';
  final String estado = '';
  final int areaSembrada = 0;
  final int presupuesto = 0;
  final double precioVenta = 0;
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final cultivosData = Provider.of<CultivosData>(context);
    final List<CultivoModel> cultivos = cultivosData.cultivos;

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
      body: _crearListaDeCultivo(context, cultivos),
      floatingActionButton: _agregarCultivo(context),
    );
  }

  Widget _crearListaDeCultivo(
      BuildContext context, List<CultivoModel> cultivos) {
    return ListView.builder(
      itemCount: cultivos.length,
      itemBuilder: (context, index) {
        return _crearCards(
          context,
          cultivos[index],
        );
      },
    );
  }
//tarjerta que muestra la informacion de cada cultivo
//MEJORAR: cambiar los ids por nombres, con if de manera provicional
//          para el estado y el nombre del cultivo
  Widget _crearCards(BuildContext context, CultivoModel cultivo) {     
    final _nombre = cultivo.nombreDistintivo;
    final _producto = cultivo.fkidProductoAgricola;
    final _fecha = cultivo.fechaInicio;
    final _ubicacion = cultivo.fkidUbicacion;
    final _estado = cultivo.fkidEstado;
    final _area = cultivo.areaSembrada.toString();
    final _presupuesto = cultivo.presupuesto.toString();
    final _precio = cultivo.precioVentaIdeal.toString();
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
                Text('Nombre: $_nombre'),
                Text('Cultivo de: $_producto'),
                Text('Fecha: $_fecha'),
                Text('Ubicación: $_ubicacion'),
                Text('Estado: $_estado'),
                Text('Área Sembrada: $_area'),
                Text('Presupuesto: $_presupuesto'),
                Text('Precio de Venta: $_precio'),
                SizedBox(height: 20.0),
                //TextButton(onPressed: () {}, child: Text('Entrar')),
                _botonEntrar(context),
              ],
            ),
          ],
        ));
  }

//botton para añadir nuevo cultivo
  Widget _agregarCultivo(BuildContext context) {
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
