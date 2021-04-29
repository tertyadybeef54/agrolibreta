import 'package:agrolibreta_v2/src/data/concepto_operations.dart';
import 'package:agrolibreta_v2/src/data/porcentaje_operations.dart';
import 'package:agrolibreta_v2/src/modelos/porcentaje_model.dart';
import 'package:flutter/material.dart';

class VerModeloReferencia extends StatefulWidget {
  VerModeloReferencia({Key key}) : super(key: key);

  @override
  _VerModeloReferenciaState createState() => _VerModeloReferenciaState();
}

class _VerModeloReferenciaState extends State<VerModeloReferencia> {
  //operaciones CRUD porcentajes y conceptos
  PorcentajeOperations porOper = new PorcentajeOperations();
  ConceptoOperations conOper = new ConceptoOperations();
  //listas de solo los valores a mostrar en el listview.buider
  List conceptos = ['semilla','mano de obra'];
  List valores = [5,95];

  List<PorcentajeModel> porcentajes =
      []; //listado de porcentajes de ese nuevo modeloreferencia
  double _resto = 000; //total restante disponible del 100 %

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Modelo de referencia')),
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.only(
                left: 30.0, right: 30.0, top: 20.0, bottom: 90.0),
            itemCount: valores.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Icon(Icons.grass_rounded),
                  onTap: () {},
                  title: Text('${conceptos[index]}:  ${valores[index]} %'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              );
            },
          ),
          _sumaBoton(),
        ],
      ),
    );
  }

//###################################################

  //#######################################################
  // widges que muestra la suma restante y el boton
  Widget _sumaBoton() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('suma restante: $_resto %'),
          SizedBox(
            height: 10.0,
          ),
          ElevatedButton(onPressed: () {}, child: Text('Finalizar')),
          SizedBox(
            height: 30.0,
          )
        ],
      ),
    );
  }
}
