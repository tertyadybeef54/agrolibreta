import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrolibreta_v2/src/modelos/costo_model.dart';
import 'package:agrolibreta_v2/src/data/costo_operations.dart';
import 'package:agrolibreta_v2/src/data/cultivo_operations.dart';
import 'package:agrolibreta_v2/src/data/producto_actividad_operations.dart';
import 'package:agrolibreta_v2/src/dataproviders/filtros_costos_data_provider.dart';

class VerCostoPage extends StatefulWidget {
  @override
  _VerCostoPageState createState() => _VerCostoPageState();
}

class _VerCostoPageState extends State<VerCostoPage> {
  final ProductoActividadOperations _proActOper =
      new ProductoActividadOperations();

  final CultivoOperations _culOper = new CultivoOperations();
  final CostoOperations _cosOper = new CostoOperations();
  int _idCosto;
  @override
  Widget build(BuildContext context) {
    final CostoModel costo = ModalRoute.of(context).settings.arguments;
    final fecha = costo.fecha.toString();
    final fechaDate = DateTime.tryParse(fecha);
    final fechaFormatted = DateFormat('dd-MM-yyyy').format(fechaDate);
    _idCosto = costo.idCosto;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del costo'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              iconSize: 30.0,
              onPressed: () {
                Navigator.pushNamed(context, 'EditarCosto', arguments: costo);
              })
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refrescar,
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Row(
                children: [
                  Text('Fecha: '),
                  Text(fechaFormatted),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.label),
              title: Row(
                children: [
                  Text('Cantidad: '),
                  Text(costo.cantidad.toString()),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.square_foot),
              title: Row(
                children: [
                  Text('Unidad: '),
                  _criterioUnidad(costo.fkidProductoActividad)
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.label_important),
              title: Row(
                children: [

                  Text('Nombre: '),
                  _criterioFuture(costo.fkidProductoActividad)
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.label),
              title: Row(
                children: [
                  Text('Valor Unidad: '),
                  Text(costo.valorUnidad.toString()),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.label),
              title: Row(
                children: [
                  Text('Valor Total: '),
                  Text((costo.cantidad * costo.valorUnidad).round().toString()),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.grass),
              title: Row(
                children: [
                  Text('Cultivo: '),
                  _cultivo(costo.fkidCultivo),
                ],
              ),
            ),
            Row(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                  onPressed: () => _confirmacion(context),
                  child: Text('ELIMINAR'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _criterioFuture(String fk) {
    return FutureBuilder<String>(
        future: _proActOper.consultarNombre(fk),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            child = Text(snapshot.data);
          } else if (snapshot.hasError) {
            child = Text('nn');
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

  Widget _criterioUnidad(String fk) {
    return FutureBuilder<String>(
        future: _proActOper.consultarNombreUnidad(fk),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            child = Text(snapshot.data);
          } else if (snapshot.hasError) {
            child = Text('nn');
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

  Widget _cultivo(String fk) {
    return FutureBuilder<String>(
        future: _culOper.getNombreCultivoById(fk),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            child = Text(snapshot.data);
          } else if (snapshot.hasError) {
            child = Text('nn');
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

  Future<void> _refrescar() async {
    setState(() {});
  }

//dialogo 'esta seguro que desea eliminar'
  void _confirmacion(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text('¿Quiere eliminar el costo?'),
          //content: Column(),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
            SizedBox(
              width: 20.0,
            ),
            TextButton(
              onPressed: _eliminar,
              child: Text('Sí'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _eliminar() async {
    await _cosOper.deleteCosto(_idCosto);
    Navigator.pop(context);
    Navigator.pop(context);
    final filData = Provider.of<FiltrosCostosData>(context, listen: false);
    filData.costos = [];
    filData.resetCostos();
  }
}
