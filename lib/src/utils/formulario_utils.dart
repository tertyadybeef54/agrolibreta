import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget crearFecha(
    BuildContext context,
    TextEditingController inputFieldController,
    String hint,
    String label,
    String helper) {
  String fecha = '';
  return TextField(
    enableInteractiveSelection: false,
    controller: inputFieldController,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      hintText: hint,
      labelText: label,
      helperText: helper,
      suffixIcon: Icon(Icons.perm_contact_calendar),
      icon: Icon(Icons.calendar_today),
    ),
    onTap: () {
      FocusScope.of(context).requestFocus(new FocusNode());
      _selectDate(context, fecha, inputFieldController);
    },
  );
}

_selectDate(BuildContext context, fecha, inputFieldController) async {
  DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2018),
      lastDate: new DateTime(2025),
      locale: Locale('es', 'ES'));
  if (picked != null) {
    fecha = picked.toString();
    fecha = DateFormat('dd-MM-yyyy').format(picked);
    inputFieldController.text = fecha;
  }
}

String nombreUbicacion = '';
String descripcionCultivo = '';

Widget input(String descripcion, String hilabel, String labeltext,
    TextInputType tipotext, int numeroInput) {
  var inputDecoration = InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
    //counter: Text('letras ${_nombre.length}'),
    hintText: hilabel,
    labelText: labeltext,
    helperText: descripcion,
    icon: Icon(Icons.drive_file_rename_outline),
    suffixIcon: Icon(Icons.touch_app),
  );
  return TextField(
    //autofocus: true
    keyboardType: tipotext,
    textCapitalization: TextCapitalization.sentences,
    decoration: inputDecoration,
    onChanged: (valor) {
      switch (numeroInput) {
        case 0:
          nombreUbicacion = valor;
          break;

        case 1:
          descripcionCultivo = valor;
          break;

        default:
          break;
      }

/*         setState(() {
          //_nombreCultivo = valor;
        }); */
    },
  );
}
