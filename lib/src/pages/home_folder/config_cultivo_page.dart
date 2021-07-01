import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrolibreta_v2/src/data/estados_operations.dart';
import 'package:agrolibreta_v2/src/dataproviders/cultivo_data.dart';

// ignore: must_be_immutable
class ConfigCultivoPage extends StatelessWidget {
  EstadosOperations estOper = new EstadosOperations();

  @override
  Widget build(BuildContext context) {
    //se obtiene el id del cultivo que esta viendo
    final int idCulArg = ModalRoute.of(context).settings.arguments;
    //provider para acceder a los datos del cultivo
    final culData = Provider.of<CultivoData>(context, listen: false);
    culData.getCultivo(idCulArg); //asignar el cultivo
    culData.calcularCostosTotales(idCulArg);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Configuración Cultivo'),
      ),
      body: ListView(
          children: <Widget>[
            SizedBox(height: 20.0),
            Icon(Icons.settings, size: 85.0),
            SizedBox(height: 20.0),
            Divider(height: 10.0),
            ListTile(
              title: Text('Informacion General'),
              leading: Icon(Icons.info),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => Navigator.pushNamed(context, 'infoCultivo',
                  arguments: idCulArg),
            ),
            Divider(height: 10.0),
            ListTile(
              title: Text('Modelo de Referencia'),
              leading: Icon(Icons.article),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => Navigator.pushNamed(context, 'verModelo',
                  arguments: idCulArg),
            ),
            Divider(height: 10.0),
          ]),
    );
  }

}
