import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class CultivoDropdown extends StatefulWidget {
  List<CultivoModel> cultivo;
  Function(CultivoModel) callback;

  CultivoDropdown(
    this.cultivo,
    this.callback, {
    Key key,
  }) : super(key: key);
  @override
  _CultivoDropdownState createState() => _CultivoDropdownState();
}

class _CultivoDropdownState extends State<CultivoDropdown> {
  String selected = 'Seleccionar';
  @override
  Widget build(BuildContext context) {
    
    return DropdownButton<CultivoModel>(
      hint: Text(selected),
      onChanged: (CultivoModel value) {
        setState(() {
          widget.callback(value);
          selected = value.nombreDistintivo;
        });
      },
      items: widget.cultivo.map((cultivo) {
        return DropdownMenuItem(
          value: cultivo,
          child: Text(cultivo.nombreDistintivo),
        );
      }).toList(),
    );
  }
}
