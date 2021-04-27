import 'package:agrolibreta_v2/src/modelos/modelo_referencia_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ModeloReferenciaDropdowun extends StatefulWidget {
  List<ModeloReferenciaModel> modelosReferencia;
  int control;

  Function(ModeloReferenciaModel, int) callback;

  ModeloReferenciaDropdowun(
    this.modelosReferencia,
    this.control,
    this.callback, {
    Key key,
  }) : super(key: key);
  @override
  _ModeloReferenciaDropdownState createState() =>
      _ModeloReferenciaDropdownState();
}

class _ModeloReferenciaDropdownState extends State<ModeloReferenciaDropdowun> {
  String selected = 'Seleccione';
  @override
  Widget build(BuildContext context) {
    return DropdownButton<ModeloReferenciaModel>(
      hint: Text(selected),
      onChanged: (ModeloReferenciaModel value) {
        setState(() {
          widget.callback(value, 0);
          selected = value.idModeloReferencia.toString();
        });
      },
      items: widget.modelosReferencia.map((modeloReferencia) {
        return DropdownMenuItem(
          value: modeloReferencia,
          child: Text(modeloReferencia.idModeloReferencia.toString()),
        );
      }).toList(),
    );
  }
}
