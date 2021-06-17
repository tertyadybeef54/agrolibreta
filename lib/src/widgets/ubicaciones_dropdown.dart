import 'package:agrolibreta_v2/src/modelos/ubicacion_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UbicacionesDropdowun extends StatefulWidget {
  List<UbicacionModel> ubicaciones;

  Function(UbicacionModel) callback;

  UbicacionesDropdowun(
    this.ubicaciones,
    this.callback, {
    Key key,
  }) : super(key: key);
  @override
  _UbicacionesDropdownState createState() => _UbicacionesDropdownState();
}

class _UbicacionesDropdownState extends State<UbicacionesDropdowun> {
  String selected = 'Seleccione ubicación';
  @override
  Widget build(BuildContext context) {
    
    return DropdownButton<UbicacionModel>(
      hint: Text(selected),
      onChanged: (UbicacionModel value) {
        setState(() {
          widget.callback(value);
          selected = value.nombreUbicacion;
        });
      },
      items: widget.ubicaciones.map((ubicacion) {
        return DropdownMenuItem(
          value: ubicacion,
          child: Text(ubicacion.nombreUbicacion),
        );
      }).toList(),
    );
  }
}
