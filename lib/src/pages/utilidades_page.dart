import 'package:flutter/material.dart';

class UtilidadesPage extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
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
            leading: Icon(Icons.info),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: (){},
          ),
          ListTile(
            title:Text('Ubicaciones'),
            leading: Icon(Icons.info),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: (){},
          ),
          ListTile(
            title:Text('Unidades de Medida'),
            leading: Icon(Icons.info),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: (){},
          ),
          ListTile(
            title:Text('Productos y Actividades'),
            leading: Icon(Icons.info),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: (){},
          ),
        ],
      )
    );
  }
}