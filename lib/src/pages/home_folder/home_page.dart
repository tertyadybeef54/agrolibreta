import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrolibreta_v2/src/modelos/estado_model.dart';
import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';
import 'package:agrolibreta_v2/src/modelos/ubicacion_model.dart';

import 'package:agrolibreta_v2/src/data/estados_operations.dart';
import 'package:agrolibreta_v2/src/data/ubicaciones_operations.dart';

import 'package:agrolibreta_v2/src/dataproviders/costos_data_provider.dart';
import 'package:agrolibreta_v2/src/dataproviders/usuario_data_provider.dart';
import 'package:agrolibreta_v2/src/preferencias_usuario/preferencias_usuario.dart';


class HomePage extends StatelessWidget {
  //referencia a la clase que accede al CRUD de las ubicaciones y los estados
  final UbicacionesOperations _ubiOper = new UbicacionesOperations();
  final EstadosOperations _estOper = new EstadosOperations();
  final prefs = new PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {
    prefs.ultimaPagina = 'taps';
    final cosData = Provider.of<CostosData>(context);
    final List<CultivoModel> cultivos = cosData.cultivos;
    cosData.obtenerCostosByConceptos();
    //widget padre de la pagina home
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:Text('Mis Cultivos'),
        actions: <Widget>[
          IconButton(
            iconSize: 40.0,
            icon: new Icon(Icons.account_circle),
            onPressed: () {
              Provider.of<UsuarioProvider>(context, listen: false)
                  .getUsuarios();
              Navigator.pushNamed(context, 'perfilUsuario');
            },
          ),
        ],
      ),
      body: _crearListaDeCultivo(context, cultivos),
      floatingActionButton: cultivos.length>2? _agregarCultivo(context):_agregarCultivo2(context),
    );
  }
//body de la vista de usuario home
  Widget _crearListaDeCultivo(
      BuildContext context, List<CultivoModel> cultivos) {

    return ListView.builder(
      padding: EdgeInsets.all(5.0),
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
    final _precio = cultivo.precioVentaIdeal.round().toString();
    final _mR = cultivo.fkidModeloReferencia;
    return Card(
        color: _estado != '1' ? Colors.black12 : Colors.white,
        clipBehavior: Clip.antiAlias,
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Row(
          children: <Widget>[
            Image(
              image: AssetImage('assets/arveja.jpg'),
              width: 130.0,
              height: 210.0,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0),
                Row(children: [
                  Text('Nombre: '),
                  Text('$_nombre',
                      style: TextStyle(fontWeight: FontWeight.bold))
                ]),
                Row(children: [
                  Text('Fecha: '),
                  Text('$_fecha',
                      style: TextStyle(fontWeight: FontWeight.bold))
                ]),
                ubicacion(_ubicacion),
                estado(_estado),
                Row(children: [
                  Text('??rea Sembrada: '),
                  Text('$_area',
                      style: TextStyle(fontWeight: FontWeight.bold))
                ]),
                Row(children: [
                  Text('Presupuesto: '),
                  Text('$_presupuesto',
                      style: TextStyle(fontWeight: FontWeight.bold))
                ]),
                Row(children: [
                  Text('Precio de Venta: '),
                  Text('$_precio',
                      style: TextStyle(fontWeight: FontWeight.bold))
                ]),
                Row(children: [
                  Text('Id MR: '),
                  Text('$_mR',
                      style: TextStyle(fontWeight: FontWeight.bold))
                ]),
                //SizedBox(height: 20.0),
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
            child = Row(children: [
              Text('Ubicaci??n: '),
              Text('${snapshot.data.nombreUbicacion}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ]);
          } else if (snapshot.hasError) {
            child = Row(children: [
              Text('Ubicaci??n: '),
              Text('No existe',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ]);
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
            child = Row(children: [
              Text('Estado: '),
              Text('${snapshot.data.nombreEstado}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ]);
          } else if (snapshot.hasError) {
            child = Row(children: [
              Text('Estado: '),
              Text('No existe',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ]);
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

  //botton para a??adir nuevo cultivo
  Widget _agregarCultivo(BuildContext context) {
    return 
        FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, 'crearCultivo');
          },
    );
  }
    //botton para a??adir nuevo cultivo
  Widget _agregarCultivo2(BuildContext context) {
    return 
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:[
        SizedBox(width: 20.0,),
        Text('''
          Resuelva sus dudas a travez de:
          https://agrolibretav1.web.app/
        '''),
        FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, 'crearCultivo');
          },
        )
      ]
    );
  }
}
