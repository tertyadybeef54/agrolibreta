import 'package:agrolibreta_v2/src/dataproviders/modelo_referencia_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UtilidadesPage extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
    final modelosReferenciaData = Provider.of<ModeloReferenciaData>(context, listen: false);
    modelosReferenciaData.obtenerByID();
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Utilidades')),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height:20.0),
          Icon(Icons.dns, size: 85.0),
          SizedBox(height:20.0),
          Divider(height: 10.0),
          ListTile(
            title:Text('Modelos de Referencia'),
            leading: Icon(Icons.article),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: ()=>Navigator.pushNamed(context, 'modeloUtil'),
          ),
          Divider(),
          ListTile(
            title:Text('Ubicaciones'),
            leading: Icon(Icons.location_on),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: ()=>Navigator.pushNamed(context, 'ubicacionUtil'),
          ),
          Divider(),
          ListTile(
            title:Text('Unidades de Medida'),
            leading: Icon(Icons.square_foot),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: ()=>Navigator.pushNamed(context, 'unidadMedidaUtil'),
          ),Divider(),
          ListTile(
            title:Text('Productos y Actividades'),
            leading: Icon(Icons.grass_rounded),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: ()=>Navigator.pushNamed(context, 'productoUtil'),
          ),
          Divider(),
        ],
      )
    );
  }
}