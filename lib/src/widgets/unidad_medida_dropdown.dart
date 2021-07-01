import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:agrolibreta_v2/src/modelos/unidad_medida_model.dart';

// ignore: must_be_immutable
class UnidadMedidaDropdown extends StatefulWidget {
  List<UnidadMedidaModel> unidadMedida;

  Function(UnidadMedidaModel) callback;

  UnidadMedidaDropdown(
    this.unidadMedida,
    this.callback, {
    Key key,
  }) : super(key: key);
  @override
  _UnidadMedidaDropdownState createState() => _UnidadMedidaDropdownState();
}

class _UnidadMedidaDropdownState extends State<UnidadMedidaDropdown> {
  String selected = 'Unidad';
  @override
  Widget build(BuildContext context) {
    return DropdownButton<UnidadMedidaModel>(
      hint: Text(selected),
      onChanged: (UnidadMedidaModel value) {
        setState(() {
          widget.callback(value);
          selected = value.nombreUnidadMedida;
        });
      },
      items: widget.unidadMedida.map((unidadMedida) {
        return DropdownMenuItem(
          value: unidadMedida,
          child: Text(unidadMedida.nombreUnidadMedida),
        );
      }).toList(),
    );
  }
}
