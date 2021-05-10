import 'package:agrolibreta_v2/src/dataproviders/modelo_referencia_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrolibreta_v2/src/modelos/concepto_model.dart';
import 'package:agrolibreta_v2/src/data/concepto_operations.dart';
import 'package:agrolibreta_v2/src/widgets/concepto_dropdown.dart';
import 'package:agrolibreta_v2/src/dataproviders/porcentajes_data_provider.dart';

// ignore: must_be_immutable
class CrearModeloReferencia extends StatelessWidget {
  //operaciones CRUD porcentajes y conceptos
  final ConceptoOperations conOper = new ConceptoOperations();

  double _porcentaje = 0.0; // valor del porcentaje asignado

  //variables para crear nuevo concepto
  //String _nombreConcepto = ''; //nombre asignado al concepto

  ConceptoModel _selectedConcepto; //concepto seleccionado en el dropdown
  callback(selectedConcepto) {
    _selectedConcepto = selectedConcepto;
  }

  @override
  Widget build(BuildContext context) {
    final porcentajesData = Provider.of<PorcentajeData>(context);

    final porcentajes = porcentajesData.porcentajes;
    final conceptos = porcentajesData.conceptos;
    final suma = porcentajesData.suma;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Column(
            children: [
              Text('Nuevo modelo de referencia'),
              Text('Cree sus porcentajes'),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.only(
                left: 30.0, right: 30.0, top: 20.0, bottom: 90.0),
            itemCount: porcentajes.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Icon(Icons.grass_rounded),
                  onTap: () {}, //aca se pondra funcion para editar
                  title: Text(
                      '${conceptos[index].nombreConcepto}: ${porcentajes[index].porcentaje} %'),
                  trailing: Icon(Icons.edit),
                ),
              );
            },
          ),
          _sumaBoton(context, suma),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _crearItem(context);
        },
      ),
    );
  }

//Registrar un nuevo porcentaje
  void _crearItem(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
//providers
        final modelosReferenciaData =
            Provider.of<ModeloReferenciaData>(context, listen: false);

        final porcentajesData =
            Provider.of<PorcentajeData>(context, listen: false);
        print('ultimo MR creado: ${modelosReferenciaData.id.toString()}');

        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text('Registrar Porcentaje'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _seleccioneConcepto(context),
              Divider(),
              _input('Valor del porcentaje', '10', '', TextInputType.number),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                porcentajesData.anadirPorcentaje(
                    modelosReferenciaData.id, _porcentaje, _selectedConcepto);
                Navigator.pop(context);
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  //##########################################
  //dropdown para seleccionar un concepto ya creado
  Widget _seleccioneConcepto(BuildContext context) {
    return Row(
      children: [
        FutureBuilder<List<ConceptoModel>>(
          future: conOper.consultarConceptos(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ConceptoDropdown(snapshot.data, callback) //selected concepto
                : Text('sin conceptos');
          },
        ),

//se deja el codigo para futuras versiones permitir crear conceptos
/*         Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 9.0, vertical: 8.8),
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.lightBlue),
            ),
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: () => _registrarConcepto(context),
            ),
          ],
        ), */
      ],
    );
  }

//###################################################
//registro de un nuevo concepto con su funcion de input, futuras versiones
/*   void _registrarConcepto(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Registrar concepto'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _inputNombre('Nombre', '', '', TextInputType.name),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    final nuevoConcepto = new ConceptoModel(
                      nombreConcepto: _nombreConcepto,
                    );
                    await conOper.nuevoConcepto(nuevoConcepto);

                    Navigator.pop(context, 'crearModeloReferencia');
                  },
                  child: Text('Guardar')),
            ],
          );
        }).then((value) => Navigator.pop(context));
  } */
//input del nombre del concepto para futuras versiones
/*   Widget _inputNombre(String descripcion, String hilabel, String labeltext,
      TextInputType tipotext) {
    var inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      hintText: hilabel,
      labelText: labeltext,
      helperText: descripcion,
      icon: Icon(Icons.drive_file_rename_outline),
      //suffixIcon: Icon(Icons.touch_app),
    );
    return Container(
      padding: EdgeInsets.only(bottom: 5.0),
      height: 60.0,
      width: double.infinity,
      child: TextField(
        textAlignVertical: TextAlignVertical.bottom,
        keyboardType: tipotext,
        textCapitalization: TextCapitalization.sentences,
        decoration: inputDecoration,
        onChanged: (valor) {
          _nombreConcepto = valor;
        },
      ),
    );
  } */

  //#######################################################
  //input para el porcentaje
  Widget _input(String descripcion, String hilabel, String labeltext,
      TextInputType tipotext) {
    var inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      hintText: hilabel,
      labelText: labeltext,
      helperText: descripcion,
      icon: Icon(Icons.drive_file_rename_outline),
    );
    return Container(
      padding: EdgeInsets.only(bottom: 5.0),
      height: 60.0,
      width: double.infinity,
      child: TextField(
        textAlignVertical: TextAlignVertical.bottom,
        keyboardType: tipotext,
        textCapitalization: TextCapitalization.sentences,
        decoration: inputDecoration,
        onChanged: (valor) {
          _porcentaje = double.parse(valor);
        },
      ),
    );
  }

  // widges que muestra la suma restante y el boton
  Widget _sumaBoton(BuildContext context, double suma) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('debe ser 100 y lleva: ${suma.toString()} %'),
          SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
              onPressed: () {
               final porcentajesData =
                    Provider.of<PorcentajeData>(context, listen: false);                
                final modData =
                Provider.of<ModeloReferenciaData>(context, listen: false);
                modData.nuevoConPorList(porcentajesData.conceptos, porcentajesData.porcentajes);
 
                porcentajesData.reset();

                Navigator.pop(context);
              },
              child: Text('Finalizar')),
          SizedBox(
            height: 30.0,
          )
        ],
      ),
    );
  }
}
