import 'package:agrolibreta_v2/src/data/concepto_operations.dart';
import 'package:agrolibreta_v2/src/data/porcentaje_operations.dart';
import 'package:agrolibreta_v2/src/modelos/concepto_model.dart';
import 'package:agrolibreta_v2/src/modelos/porcentaje_model.dart';
import 'package:agrolibreta_v2/src/widgets/concepto_dropdown.dart';
//import 'package:agrolibreta_v2/src/modelos/porcentaje_model.dart';
import 'package:flutter/material.dart';

class CrearModeloReferencia extends StatefulWidget {
  CrearModeloReferencia({Key key}) : super(key: key);

  @override
  _CrearModeloReferenciaState createState() => _CrearModeloReferenciaState();
}

class _CrearModeloReferenciaState extends State<CrearModeloReferencia> {
  //operaciones CRUD porcentajes y conceptos
  PorcentajeOperations porOper = new PorcentajeOperations();
  ConceptoOperations conOper = new ConceptoOperations();
  //listas de solo los valores a mostrar en el listview.buider
  List conceptos = [];
  List valores = [];

  List<PorcentajeModel> porcentajes =
      []; //listado de porcentajes de ese nuevo modeloreferencia
  double _porcentaje = 0.0; // valor del porcentaje asignado
  double _resto = 100; //total restante disponible del 100 %
  double _suma = 0; //suma de todos los valores de los porcentajes creados
  int _idModeloReferencia = 1;
  //variables para crear nuevo concepto
  String _nombreConcepto = ''; //nombre asignado al concepto
  ConceptoModel _selectedConcepto; //concepto seleccionado en el dropdown
  callback(selectedConcepto) {
    setState(() {
      _selectedConcepto = selectedConcepto;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Nuevo modelo de referencia')),
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
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Registrar Porcentaje'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _seleccioneConcepto(),
                Divider(),
                _input('Volor del porcentaje', '10', '', TextInputType.number),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    final nuevoPorcentaje = new PorcentajeModel(
                        fk2idModeloReferencia: _idModeloReferencia,
                        fk2idConcepto: _selectedConcepto.idConcepto,
                        porcentaje: _porcentaje);
                    await porOper.nuevoPorcentaje(nuevoPorcentaje);
                    porcentajes =
                        await porOper.consultarPorcentajesbyModeloReferencia(
                            _idModeloReferencia.toString());
                    _suma = 0;
                    conceptos = [];
                    valores = [];

                    porcentajes.forEach((porcentaje) async {
                      _suma = _suma + porcentaje.porcentaje;
                      final ConceptoModel _concepTemp = await conOper
                          .getConceptoById(porcentaje.fk2idConcepto);
                      valores.add(porcentaje.porcentaje);
                      conceptos.add(_concepTemp.nombreConcepto);
                      setState(() {});
                      _resto = 100 - _suma;
                    });
                    Navigator.pop(context, 'crearModeloReferencia');
                  },
                  child: Text('Guardar')),
            ],
          );
        });
  }

  //##########################################
  //dropdown para seleccionar un concepto ya creado
  Widget _seleccioneConcepto() {
    return Row(
      children: [
        Icon(Icons.list_alt, color: Colors.black45),
        SizedBox(width: 30.0),
        FutureBuilder<List<ConceptoModel>>(
          future: conOper.consultarConceptos(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ConceptoDropdown(snapshot.data, callback) //selected concepto
                : Text('sin conceptos');
          },
        ),
        Stack(
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
        ),
      ],
    );
  }

//###################################################
//registro de un nuevo concepto con su funcion de input
  void _registrarConcepto(BuildContext context) {
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
                    setState(() {});
                    Navigator.pushNamed(context, 'crearModeloReferencia');
                  },
                  child: Text('Guardar')),
            ],
          );
        });
  }

  Widget _inputNombre(String descripcion, String hilabel, String labeltext,
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
          setState(() {
            _nombreConcepto = valor;
          });
        },
      ),
    );
  }

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
          setState(() {
            _porcentaje = double.parse(valor);
          });
        },
      ),
    );
  }

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
