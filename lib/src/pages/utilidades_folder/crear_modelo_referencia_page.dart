import 'package:agrolibreta_v2/src/dataproviders/modelo_referencia_provider.dart';
import 'package:agrolibreta_v2/src/modelos/porcentaje_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrolibreta_v2/src/modelos/concepto_model.dart';
import 'package:agrolibreta_v2/src/data/concepto_operations.dart';
import 'package:agrolibreta_v2/src/widgets/concepto_dropdown.dart';
import 'package:agrolibreta_v2/src/dataproviders/porcentajes_data_provider.dart';

class CrearModeloReferencia extends StatefulWidget {
  @override
  _CrearModeloReferenciaState createState() => _CrearModeloReferenciaState();
}

class _CrearModeloReferenciaState extends State<CrearModeloReferencia> {
  List<Widget> listado;
  double _porcentaje = 0;
  ConceptoModel _selectedConcepto; //concepto seleccionado en el dropdown
  callback(selectedConcepto) {
    _selectedConcepto = selectedConcepto;
  }

  final ConceptoOperations conOper = new ConceptoOperations();
  @override
  Widget build(BuildContext context) {
    final porcentajesData = Provider.of<PorcentajeData>(context, listen: false);
    final List<PorcentajeModel> porcentajes = porcentajesData.porcentajes;
    final List<ConceptoModel> conceptos = porcentajesData.conceptos;
    final double suma = porcentajesData.suma;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              Text('Nuevo modelo de referencia'),
              Text('Cree sus porcentajes'),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refrescar,
        child: ListView(
          children: _armarWidgets(porcentajes, conceptos, suma),
        ),
      ),
      floatingActionButton: _addPorcentaje(suma),
    );
  }

  List<Widget> _armarWidgets(List<PorcentajeModel> porcentajes,
      List<ConceptoModel> conceptos, double suma) {
    listado = [];
    for (var i = 0; i < porcentajes.length; i++) {
      listado.add(_conceptoPorcentaje(porcentajes[i], conceptos[i]));
    }
    listado.add(_textoSumaBoton(suma, porcentajes, conceptos));
    return listado;
  }

  Widget _conceptoPorcentaje(
      PorcentajeModel porcentaje, ConceptoModel concepto) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        Provider.of<PorcentajeData>(context, listen: false).eliminarPorcentaje(
            porcentaje.idPorcentaje,
            porcentaje.porcentaje,
            concepto.idConcepto);
      },
      background: Container(
        color: Colors.red,
      ),
      child: Card(
        child: ListTile(
          leading: Icon(Icons.grass_rounded),
          title: Text('${concepto.nombreConcepto}: ${porcentaje.porcentaje} %'),
          trailing: Icon(
            Icons.arrow_left,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _textoSumaBoton(double suma, List<PorcentajeModel> porcentajes, List<ConceptoModel> conceptos) {
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
                if (suma < 100) {
                  mostrarSnackbar(context, 'la suma debe ser 100%');
                } else {
                  final modData =
                      Provider.of<ModeloReferenciaData>(context, listen: false);
                  modData.nuevoConPorList(conceptos, porcentajes);
                  final porcentajesData =
                      Provider.of<PorcentajeData>(context, listen: false);
                  porcentajesData.reset();
                  modData.getModelosReferencia();

                  Navigator.pop(context);
                }
              },
              child: Text('Finalizar')),
          SizedBox(
            height: 30.0,
          )
        ],
      ),
    );
  }

  Widget _addPorcentaje(double suma) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        _crearItem(context, suma);
      },
    );
  }

  void _crearItem(BuildContext context, double suma) {
    final modelosReferenciaData =
        Provider.of<ModeloReferenciaData>(context, listen: false);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        //providers
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
                final double sumaTemp = suma + _porcentaje;
                if (sumaTemp <= 100) {
                  porcentajesData.anadirPorcentaje(
                      modelosReferenciaData.id, _porcentaje, _selectedConcepto);
/*                   _porcentajes.add(new PorcentajeModel(porcentaje: _porcentaje));
                  _conceptos.add(new ConceptoModel(
                    idConcepto: _selectedConcepto.idConcepto,
                    nombreConcepto: _selectedConcepto.nombreConcepto
                    ),
                  ); */
                  Navigator.pop(context);
                } else {
                  mostrarSnackbar(context, 'la suma no debe superar el 100%');
                  Navigator.pop(context);
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

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
      ],
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
          _porcentaje = double.parse(valor);
        },
      ),
    );
  }

  void mostrarSnackbar(BuildContext context, String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 2500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Future<void> _refrescar() async {
    setState(() {});
  }
}

/* // ignore: must_be_immutable
class CrearModeloReferencia extends StatelessWidget {
  //operaciones CRUD porcentajes y conceptos
  final ConceptoOperations conOper = new ConceptoOperations();

  List<PorcentajeModel> _porcentajes = [];
  List<ConceptoModel> _conceptos = [];
  double _porcentaje = 0.0; // valor del porcentaje asignado
  //variables para crear nuevo concepto
  //String _nombreConcepto = ''; //nombre asignado al concepto

  ConceptoModel _selectedConcepto; //concepto seleccionado en el dropdown
  callback(selectedConcepto) {
    _selectedConcepto = selectedConcepto;
  }

  @override
  Widget build(BuildContext context) {
    final porcentajesData = Provider.of<PorcentajeData>(context, listen: false); 

//aca esta el problema de que ponga los datos del anterior modelo de referencia
    final porcentajes = porcentajesData.porcentajes;
    final conceptos = porcentajesData.conceptos;
    final suma = porcentajesData.suma;
    _porcentajes = porcentajes;
    _conceptos = conceptos;

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
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  Provider.of<PorcentajeData>(context, listen: false)
                      .eliminarPorcentaje(porcentajes[index].idPorcentaje, porcentajes[index].porcentaje, conceptos[index].idConcepto);
                  _porcentajes.removeWhere(
                      (e) => e.idPorcentaje == porcentajes[index-1].porcentaje);
                  _conceptos.removeWhere(
                      (e) => e.idConcepto == conceptos[index-1].idConcepto);
                },
                background: Container(
                  child: Text('Eliminar'),
                  color: Colors.red,
                ),
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.grass_rounded),
                    title: Text(
                        '${conceptos[index].nombreConcepto}: ${porcentajes[index].porcentaje} %'),
                    trailing: Icon(
                      Icons.arrow_left,
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            },
          ),
          _sumaBoton(context, suma, conceptos, porcentajes),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _crearItem(context, suma);
        },
      ),
    );
  }

//Registrar un nuevo porcentaje
  void _crearItem(BuildContext context, double suma) {
    final modelosReferenciaData =
    Provider.of<ModeloReferenciaData>(context, listen: false);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
//providers


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
                final double sumaTemp = suma + _porcentaje;
                if (sumaTemp < 100) {
                  porcentajesData.anadirPorcentaje(
                      modelosReferenciaData.id, _porcentaje, _selectedConcepto);
/*                   _porcentajes.add(new PorcentajeModel(porcentaje: _porcentaje));
                  _conceptos.add(new ConceptoModel(
                    idConcepto: _selectedConcepto.idConcepto,
                    nombreConcepto: _selectedConcepto.nombreConcepto
                    ),
                  ); */
                  Navigator.pop(context);
                } else {
                  mostrarSnackbar2(context, 'la suma no debe superar el 100%');
                  Navigator.pop(context);
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void mostrarSnackbar2(BuildContext context, String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 2500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
      ],
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
          _porcentaje = double.parse(valor);
        },
      ),
    );
  }

  // widges que muestra la suma restante y el boton
  Widget _sumaBoton(BuildContext context, double suma,
      List<ConceptoModel> conceptos, List<PorcentajeModel> porcentajes) {
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
                modData.nuevoConPorList(_conceptos, _porcentajes);

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
 */
