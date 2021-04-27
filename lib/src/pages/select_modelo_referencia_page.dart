import 'package:agrolibreta_v2/src/data/concepto_operations.dart';
import 'package:agrolibreta_v2/src/data/modelos_referencia_operations.dart';
import 'package:agrolibreta_v2/src/data/porcentaje_operations.dart';
import 'package:agrolibreta_v2/src/modelos/concepto_model.dart';
import 'package:agrolibreta_v2/src/modelos/modelo_referencia_model.dart';
import 'package:agrolibreta_v2/src/modelos/porcentaje_model.dart';
import 'package:agrolibreta_v2/src/widgets/modelo_referencia_dropdown.dart';
import 'package:flutter/material.dart';

class SelectModeloReferencia extends StatefulWidget {
  SelectModeloReferencia({Key key}) : super(key: key);

  @override
  _SelectModeloReferenciaState createState() => _SelectModeloReferenciaState();
}

class _SelectModeloReferenciaState extends State<SelectModeloReferencia> {
  //operaciones CRUD modelosReferencia porcentajes y conceptos
  ModelosReferenciaOperations modRefOper = new ModelosReferenciaOperations();
  PorcentajeOperations porOper = new PorcentajeOperations();
  ConceptoOperations conOper = new ConceptoOperations();
  //listas de solo los valores a mostrar en el listview.buider
  List conceptos = [];
  List valores = [];
  int _control = 0;
  List<PorcentajeModel> porcentajes =
      []; //listado de porcentajes de ese nuevo modeloreferencia
  // ignore: unused_field
  ModeloReferenciaModel
      _selectedModeloReferencia; //modeloreferencia seleccionado en el dropdown
  callback(selectedModeloReferencia, control) {
    setState(() {
      _selectedModeloReferencia = selectedModeloReferencia;
      _control = control;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Modelo de referencia')),
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.only(
                left: 30.0, right: 30.0, top: 60.0, bottom: 90.0),
            itemCount: valores.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Icon(Icons.grass_rounded),
                  title: Text('${conceptos[index]}:  ${valores[index]} %'),
                ),
              );
            },
          ),
          _seleccionarModeloReferencia(),
          _textoBoton(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          final nuevoModeloReferencia = new ModeloReferenciaModel(
            suma: 20,
          );
          modRefOper.nuevoModeloReferencia(nuevoModeloReferencia);
        },
      ),
    );
  }

//##############################
//

  void _cargarData() async {
    if (_selectedModeloReferencia != null) {
      porcentajes = await porOper.consultarPorcentajesbyModeloReferencia(
          _selectedModeloReferencia.idModeloReferencia.toString());
      conceptos = [];
      valores = [];
      porcentajes.forEach((porcentaje) async {
        final ConceptoModel _concepTemp =
            await conOper.getConceptoById(porcentaje.fk2idConcepto);
        conceptos.add(_concepTemp.nombreConcepto);
        valores.add(porcentaje.porcentaje);
        _control = 1;
      });
    }
  }

//
//#############################
  //dropdown para los modelos de referencia
  Widget _seleccionarModeloReferencia() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.label_important, color: Colors.black45),
        SizedBox(width: 30.0),
        FutureBuilder<List<ModeloReferenciaModel>>(
          future: modRefOper.consultarModelosReferencia(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ModeloReferenciaDropdowun(snapshot.data, _control, callback)
                : Text('Usar por defecto');
          },
        ),
        IconButton(
            icon: Icon(Icons.visibility),
            color: Colors.black,
            onPressed: () {
              if (_control == 0) {
                _cargarData();
              }
              setState(() {});
            }),
      ],
    );
  }
//se debe mejorar para que muestre los valores del modelo de referencia seleccionado sin necesidad de oprmiri dos veces el ojo, una posible solucion seria poner un CircularProgressIndicator() mientras se carga los datos, ademas deshabilitar el ojo hasta que escoja otro valor del dropdown.
//###################################################

  // widges que muestra la suma restante y el boton
  Widget _textoBoton() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Escoja un modelo de referencia existente'),
          SizedBox(
            height: 10.0,
          ),
          Text('El modelo de referencia por defecto es el 1'),
          SizedBox(
            height: 10.0,
          ),
          Text('Tambien puede crearlo en el boton redondo'),
          SizedBox(
            height: 10.0,
          ),
          ElevatedButton(onPressed: () {}, child: Text('Ok')),
          SizedBox(
            height: 30.0,
          )
        ],
      ),
    );
  }
}
