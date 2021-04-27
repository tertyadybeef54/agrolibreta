import 'package:flutter/material.dart';

class ConfigCultivoPage extends StatefulWidget {
  
  @override
  _ConfigCultivoPageState createState() => _ConfigCultivoPageState();
}

class _ConfigCultivoPageState extends State<ConfigCultivoPage> {

  String _estadoSeleccionado = 'Activo';
  List <String> _estados = ['Activo','Inactivo','Perdido'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Configuración Cultivo')),
      ),
      body: ListView(
        //padding: EdgeInsets.all(20.0),
        children: <Widget>[
          SizedBox(height:20.0),
          Icon(Icons.settings, size: 85.0),
          SizedBox(height:20.0),
          Divider(height: 10.0),
          ListTile(
            title:Text('Informacion General'),
            leading: Icon(Icons.info),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: ()=>Navigator.pushNamed(context, 'infoCultivo'),
          ),
          Divider(height: 10.0),
          ListTile(
            title:Text('Modelo de Referencia'),
            leading: Icon(Icons.article),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: (){},
          ),
          Divider(height: 10.0),
          ListTile(
            title:Text('Cambiar Estado'),
            leading: Icon(Icons.drag_indicator),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: ()=>_cambiarEstadoAlert(context),
          ),
          Divider(height: 10.0),
        ]
      ),
    );
  }

  void _cambiarEstadoAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (contex){
        return AlertDialog(
          title: Center(child: Text('Cambiar estado del cultivo' , style: TextStyle(fontSize: 18.0))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _crearDropdown(),
            ]
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar', style: TextStyle(fontSize: 17.0)),
              onPressed: ()=>Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Guardar', style: TextStyle(fontSize: 17.0)),
              onPressed: ()=>Navigator.of(context).pop(),
            )
          ],
        );
      },
    );  
  }

  List <DropdownMenuItem<String>> getOpcionesDropdown(){

    List <DropdownMenuItem<String>> lista = []; 
    _estados.forEach((estado) { 
      lista.add(DropdownMenuItem(
        child: Text(estado),
        value: estado,
      ));
    });
    return lista;
  }

  Widget _crearDropdown() {
    return Row(
      children: <Widget> [
        Icon(Icons.drag_indicator),
        SizedBox(width:30.0),
        DropdownButton(
          value: _estadoSeleccionado,
          items: getOpcionesDropdown(),
          onChanged: (opt){
              _estadoSeleccionado = opt;
            setState(() {
            });
          },
        ),
      ],
    );
  }
}


