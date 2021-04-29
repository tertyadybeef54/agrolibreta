import 'package:agrolibreta_v2/src/widgets/estados_cultivo_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:agrolibreta_v2/src/data/estados_operations.dart';
import 'package:agrolibreta_v2/src/modelos/estado_model.dart';

class ConfigCultivoPage extends StatefulWidget {
  
  @override
  _ConfigCultivoPageState createState() => _ConfigCultivoPageState();
}

class _ConfigCultivoPageState extends State<ConfigCultivoPage> {
  EstadosOperations estOper = new EstadosOperations();
  // ignore: unused_field
  List <String> _estados = ['Activo','Inactivo','Perdido'];
  // ignore: unused_field
  EstadoModel _selectedEstado;
  callback(selectedEstado) {
    setState(() {
      _selectedEstado = selectedEstado;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            onTap: ()=>Navigator.pushNamed(context, 'verModelo'),
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
              _seleccioneConcepto(),
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

//dropdown para seleccionar el estado del cultivo
   Widget _seleccioneConcepto() {
    return FutureBuilder<List<EstadoModel>>(
          future: estOper.consultarEstados(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? EstadoDropdown(snapshot.data, callback) //selected concepto
                : Text('sin conceptos');
          },
    );
  }
}


