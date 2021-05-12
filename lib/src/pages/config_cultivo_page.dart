import 'package:agrolibreta_v2/src/dataproviders/costos_data_provider.dart';
import 'package:agrolibreta_v2/src/dataproviders/cultivo_data.dart';
import 'package:agrolibreta_v2/src/widgets/estados_cultivo_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:agrolibreta_v2/src/data/estados_operations.dart';
import 'package:agrolibreta_v2/src/modelos/estado_model.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ConfigCultivoPage extends StatelessWidget {
  EstadosOperations estOper = new EstadosOperations();

  EstadoModel _selectedEstado;
  callback(selectedEstado) {
    _selectedEstado = selectedEstado;
  }

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
        title: Center(child: Text('Configuración Cultivo')),
      ),
      body: ListView(
          //padding: EdgeInsets.all(20.0),
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
            ListTile(
              title: Text('Cambiar Estado'),
              leading: Icon(Icons.drag_indicator),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => _cambiarEstadoAlert(context, idCulArg),
            ),
            Divider(height: 10.0),
          ]),
    );
  }

  void _cambiarEstadoAlert(BuildContext context, int idCul) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (contex) {
        return AlertDialog(
          title: Center(
              child: Text('Cambiar estado del cultivo',
                  style: TextStyle(fontSize: 18.0))),
          content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            _seleccioneConcepto(),
          ]),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar', style: TextStyle(fontSize: 17.0)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
                child: Text('Guardar', style: TextStyle(fontSize: 17.0)),
                onPressed: () {
                final culData = Provider.of<CultivoData>(context, listen: false);
                culData.actualizarEstadoCul(idCul, _selectedEstado.idEstado);
                final cosData = Provider.of<CostosData>(context, listen: false);
                cosData.actualizarCultivos();
                Navigator.of(context).pop();
                })
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
