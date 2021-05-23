import 'package:agrolibreta_v2/src/dataproviders/costos_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';

class HomePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final cosData = Provider.of<CostosData>(context);

    final List<CultivoModel> cultivos = cosData.cultivos;
    cosData.obtenerCostosByConceptos();

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
    //final _idCultivo = cultivo.idCultivo;
    final _nombre = cultivo.nombreDistintivo;
    final _producto = cultivo.fkidProductoAgricola;
    final _fecha = cultivo.fechaInicio;
    final _ubicacion = cultivo.fkidUbicacion;
    final _estado = cultivo.fkidEstado;
    final _area = cultivo.areaSembrada.toString();
    final _presupuesto = cultivo.presupuesto.toString();
    final _precio = cultivo.precioVentaIdeal.toString();
    final _mR = cultivo.fkidModeloReferencia;
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
                Text('MR: $_mR'),
                SizedBox(height: 20.0),
                //TextButton(onPressed: () {}, child: Text('Entrar')),
                _botonEntrar(context, cultivo),
              ],
            ),
          ],
        ));
  }

  Widget _botonEntrar(BuildContext context, CultivoModel cultivo) {
    return TextButton(
        onPressed: () {
          Navigator.pushNamed(context, 'resumenCostos',
              arguments: cultivo);
        },
        child: Text('Entrar',style: TextStyle(fontSize:18.0,fontWeight: FontWeight.bold)));
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
}
