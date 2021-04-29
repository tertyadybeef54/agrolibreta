import 'package:agrolibreta_v2/src/modelos/estado_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class EstadoDropdown extends StatefulWidget {
  List<EstadoModel> estado;
  Function(EstadoModel) callback;

  EstadoDropdown(
    this.estado,
    this.callback, {
    Key key,
  }) : super(key: key);
  @override
  _EstadoDropdownState createState() => _EstadoDropdownState();
}

class _EstadoDropdownState extends State<EstadoDropdown> {
  String selected = 'Seleccionar';
  @override
  Widget build(BuildContext context) {
    
    return DropdownButton<EstadoModel>(
      hint: Text(selected),
      onChanged: (EstadoModel value) {
        setState(() {
          widget.callback(value);
          selected = value.nombreEstado;
        });
      },
      items: widget.estado.map((estado) {
        return DropdownMenuItem(
          value: estado,
          child: Text(estado.nombreEstado),
        );
      }).toList(),
    );
  }
}
