import 'package:agrolibreta_v2/src/data/estados_operations.dart';
import 'package:agrolibreta_v2/src/data/ubicaciones_operations.dart';
import 'package:agrolibreta_v2/src/dataproviders/costos_data_provider.dart';
import 'package:agrolibreta_v2/src/modelos/estado_model.dart';
import 'package:agrolibreta_v2/src/modelos/ubicacion_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';

class HomePage extends StatelessWidget {
  final UbicacionesOperations _ubiOper = new UbicacionesOperations();
  final EstadosOperations _estOper = new EstadosOperations();
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
    final _nombre = cultivo.nombreDistintivo;
    //final _producto = cultivo.fkidProductoAgricola; //para futura version
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
                Text('Cultivo de: arveja'),
                Text('Fecha: $_fecha'),
                ubicacion(_ubicacion),
                estado(_estado),
                Text('Área Sembrada: $_area'),
                Text('Presupuesto: $_presupuesto'),
                Text('Precio de Venta: $_precio'),
                Text('Id MR: $_mR'),
                SizedBox(height: 20.0),
                _botonEntrar(context, cultivo),
              ],
            ),
          ],
        ));
  }

//future para mostrar el nombre de la ubicacion ya que en la tabla de cultivo
//tengo la llave foranea del id de la ubicacion
  Widget ubicacion(String fkubicacion) {
    return FutureBuilder<UbicacionModel>(
        future: _ubiOper.getUbicacionById(fkubicacion),
        builder:
            (BuildContext context, AsyncSnapshot<UbicacionModel> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            child = Text('Ubicación: ${snapshot.data.nombreUbicacion}');
          } else if (snapshot.hasError) {
            child = Text('Ubicación: nn');
          } else {
            child = SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
              width: 10,
              height: 10, //
            );
          }
          return child;
        });
  }

//future para mostrar el nombre de la estado ya que en la tabla de cultivo
//tengo la llave foranea del id de la estado
  Widget estado(String fkestado) {
    return FutureBuilder<EstadoModel>(
        future: _estOper.getEstadoById(fkestado),
        builder: (BuildContext context, AsyncSnapshot<EstadoModel> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            child = Text('Estado: ${snapshot.data.nombreEstado}');
          } else if (snapshot.hasError) {
            child = Text('Estado: nn');
          } else {
            child = SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
              width: 10,
              height: 10, //
            );
          }
          return child;
        });
  }

  Widget _botonEntrar(BuildContext context, CultivoModel cultivo) {
    return TextButton(
        onPressed: () {
          Navigator.pushNamed(context, 'resumenCostos', arguments: cultivo);
        },
        child: Text('Entrar',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)));
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
