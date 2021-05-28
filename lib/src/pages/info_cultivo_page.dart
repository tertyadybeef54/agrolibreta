//import 'dart:ui';
import 'package:agrolibreta_v2/src/data/estados_operations.dart';
import 'package:agrolibreta_v2/src/modelos/estado_model.dart';
import 'package:agrolibreta_v2/src/widgets/estados_cultivo_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';

import 'package:agrolibreta_v2/src/dataproviders/cultivo_data.dart';
import 'package:agrolibreta_v2/src/dataproviders/costos_data_provider.dart';

class InformacionCultivo extends StatefulWidget {
  @override
  _InformacionCultivoState createState() => _InformacionCultivoState();
}

class _InformacionCultivoState extends State<InformacionCultivo> {
  TextEditingController _inputFieldDateController = new TextEditingController();
  CultivoModel culTemp = new CultivoModel();
  //variables para calcular el valor de venta ideal
  double cantidad;

  final EstadosOperations _estOper = new EstadosOperations();

  EstadoModel _selectedEstado;
  callback(selectedEstado) {
    _selectedEstado = selectedEstado;
  }


  @override
  Widget build(BuildContext context) {
    //final int idCulArg = ModalRoute.of(context).settings.arguments;
    final culData = Provider.of<CultivoData>(context, listen: false);
    final CultivoModel cultivo = culData.cultivo;
    final costosTotales = culData.costosTotales;
    culTemp = cultivo;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Informacion Genaral del Cultivo')),
      ),
      body: listaInfoCultivo(context, culTemp, costosTotales),
    );
  }

  ListView listaInfoCultivo(
      BuildContext context, CultivoModel cultivo, double costosTotales) {
    return ListView(padding: EdgeInsets.all(20.0), children: <Widget>[
      Icon(Icons.info, size: 80.0),
      SizedBox(height: 20.0),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('  Nombre Distintivo: ${cultivo.nombreDistintivo}'),
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.black45,
              onPressed: () => _editnameAlert(context),
            )
          ]),
          Divider(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('  Área sembrada: ${cultivo.areaSembrada.toString()}'),
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.black45,
              onPressed: () => _editnumberAlert(
                  context, 'Área Sembrada m^2', TextInputType.number, 1),
            )
          ]),
          Divider(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('  Fecha de Inicio: ${cultivo.fechaInicio}'),
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.black45,
              onPressed: () => _editFechaAlert(context, 'Fecha de Inicio', 1),
            )
          ]),
          Divider(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('  Fecha de finalización: ${cultivo.fechaFinal}'),
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.black45,
              onPressed: () => _editFechaAlert(context, 'Fecha Final', 2),
            )
          ]),
          Divider(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('  Presupuesto: ${cultivo.presupuesto}'),
            IconButton(
                icon: Icon(Icons.edit),
                color: Colors.black45,
                onPressed: () {
                  _editnumberAlert(
                      context, 'Presupuesto', TextInputType.number, 2);
                })
          ]),
          Divider(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('  Precio de venta sugerido: ${cultivo.precioVentaIdeal}'),
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.black45,
              onPressed: () => _editPrecioVentaAlert(context, costosTotales),
            )
          ]),
          Divider(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('  Estado: ${cultivo.fkidEstado}'),
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.black45,
              onPressed: () => _cambiarEstadoAlert(context),
            )
          ]),
          Divider(height: 10.0),



        ],
      )
    ]);
  }

//editar nombre
  void _editnameAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (contex) {
        return AlertDialog(
          title: Text(
            'Editar Nombre Distintivo',
            style: TextStyle(fontSize: 18.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 10.0),
                height: 60.0,
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.name,
                  style: TextStyle(fontSize: 18.0),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    labelText: 'Nombre Distintivo',
                    icon: Icon(Icons.drive_file_rename_outline),
                  ),
                  onChanged: (value) {
                    setState(() {});
                    culTemp.nombreDistintivo = value;
                  },
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () => actualizar(),
            )
          ],
        );
      },
    );
  }

//funcion que actualiza
  void actualizar() {
    setState(() {
      final culData = Provider.of<CultivoData>(context, listen: false);
      culData.actualizarData(culTemp);
      final cosData = Provider.of<CostosData>(context, listen: false);
      cosData.actualizarCultivos();
      Navigator.of(context).pop(); 
    });
  }
  void actualizar2(){
    setState(() {
      final culData = Provider.of<CultivoData>(context, listen: false);
      culData.actualizarData(culTemp);
      final cosData = Provider.of<CostosData>(context, listen: false);
      cosData.actualizarCultivos();
      cosData.conceptosList = [];
      cosData.sumasList = [];
      cosData.sugeridosList = [];
      cosData.obtenerCostosByConceptos();
      Navigator.of(context).pop();
    });
  }

  /* void _editLocationAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (contex) {
        return AlertDialog(
          title: Text(
            'Editar Ubicación',
            style: TextStyle(fontSize: 18.0),
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 10.0),
              height: 60.0,
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.name,
                style: TextStyle(fontSize: 18.0),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Ubicación',
                  icon: Icon(Icons.drive_file_rename_outline),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 10.0),
              height: 60.0,
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.name,
                style: TextStyle(fontSize: 18.0),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Descripción',
                  icon: Icon(Icons.drive_file_rename_outline),
                ),
              ),
            ),
          ]),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }
 */
//alerta del area y del presupuesto
  void _editnumberAlert(
      BuildContext context, String titulo, TextInputType tipotext, int n) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (contex) {
        return AlertDialog(
          title: Text(
            'Editar $titulo',
            style: TextStyle(fontSize: 18.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _input('$titulo', tipotext, n),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () => actualizar2(),
            )
          ],
        );
      },
    );
  }

//input de area y del presupuesto
  Widget _input(String titulo, TextInputType tipotext, n) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      height: 60.0,
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        keyboardType: tipotext,
        style: TextStyle(fontSize: 18.0),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          labelText: '$titulo',
          icon: Icon(Icons.drive_file_rename_outline),
        ),
        onChanged: (value) {
          if (n == 1) {
            culTemp.areaSembrada = double.parse(value);
          }
          if (n == 2) {
            culTemp.presupuesto = int.parse(value);
          }
          setState(() {});
        },
      ),
    );
  }

//alerta de fecha de inicial Y final
  void _editFechaAlert(BuildContext context, String titulo, int n) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (contex) {
        return AlertDialog(
          title: Text(
            'Editar $titulo',
            style: TextStyle(fontSize: 18.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _input2('$titulo', n),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar', style: TextStyle(fontSize: 17.0)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Guardar', style: TextStyle(fontSize: 17.0)),
              onPressed: () => actualizar(),
            )
          ],
        );
      },
    );
  }

//inputs de las fechas inicial y final
  Widget _input2(String titulo, int n) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      height: 60.0,
      child: TextField(
          enableInteractiveSelection: false,
          controller: _inputFieldDateController,
          style: TextStyle(fontSize: 20.0),
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            labelText: '$titulo',
            icon: Icon(Icons.calendar_today),
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _selectDate(context, n);
          }),
    );
  }

  _selectDate(BuildContext context, int n) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime.now(),
      lastDate: new DateTime(2050),
    );

    if (picked != null) {
      setState(() {
        if (n == 1) {
          culTemp.fechaInicio = DateFormat('dd-MM-yyyy').format(picked);
          _inputFieldDateController.text = culTemp.fechaInicio;
        }
        if (n == 2) {
          culTemp.fechaFinal = DateFormat('dd-MM-yyyy').format(picked);
          _inputFieldDateController.text = culTemp.fechaFinal;
        }
      });
    }
  }

//dialogo del precio de venta
  void _editPrecioVentaAlert(BuildContext context, double costosTotales) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (contex) {
        return AlertDialog(
          title: Text(
            'Editar Precio de Venta Sugerido',
            style: TextStyle(fontSize: 18.0),
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 10.0),
              height: 60.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 18.0),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Cantidad de Unidades',
                  icon: Icon(Icons.drive_file_rename_outline),
                ),
                onChanged: (value) {
                  cantidad = double.parse(value);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 10.0),
              height: 60.0,
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 18.0),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Porcentaje de Ganancia',
                  icon: Icon(Icons.drive_file_rename_outline),
                ),
                onChanged: (value) {
                  final double porcentaje = double.parse(value);
                  final n = (porcentaje * 0.01 + 1) * costosTotales / cantidad;

                  culTemp.precioVentaIdeal = num.parse(n.toStringAsFixed(2));
                },
              ),
            ),
          ]),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () => actualizar(),
            )
          ],
        );
      },
    );
  }

  void _cambiarEstadoAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (contex) {
        return AlertDialog(
          title: Center(
              child: Text('Cambiar estado del cultivo',
                  style: TextStyle(fontSize: 18.0))),
          content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            _seleccioneEstado(),
          ]),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar', style: TextStyle(fontSize: 17.0)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
                child: Text('Guardar', style: TextStyle(fontSize: 17.0)),
                onPressed: () {
                  if(_selectedEstado!=null){
                    culTemp.fkidEstado = _selectedEstado.idEstado.toString(); 
                    actualizar();
                  }
                })
          ],
        );
      },
    );
  } 
//dropdown para seleccionar el estado del cultivo
  Widget _seleccioneEstado() {
    return FutureBuilder<List<EstadoModel>>(
      future: _estOper.consultarEstados(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? EstadoDropdown(snapshot.data, callback) //selected concepto
            : Text('sin conceptos');
      },
    );
  }



}
