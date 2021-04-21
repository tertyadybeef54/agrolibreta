import 'package:agrolibreta_v2/src/modelos/concepto_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ConceptoDropdown extends StatefulWidget {
  List<ConceptoModel> concepto;

  Function(ConceptoModel) callback;

  ConceptoDropdown(
    this.concepto,
    this.callback, {
    Key key,
  }) : super(key: key);
  @override
  _ConceptoDropdownState createState() => _ConceptoDropdownState();
}

class _ConceptoDropdownState extends State<ConceptoDropdown> {
  String selected = 'Seleccione concepto';
  @override
  Widget build(BuildContext context) {
    
    return DropdownButton<ConceptoModel>(
      hint: Text(selected),
      onChanged: (ConceptoModel value) {
        setState(() {
          widget.callback(value);
          selected = value.nombreConcepto;
        });
      },
      items: widget.concepto.map((concepto) {
        return DropdownMenuItem(
          value: concepto,
          child: Text(concepto.nombreConcepto),
        );
      }).toList(),
    );
  }
}
