import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InformacionCultivo extends StatefulWidget {
  
  @override
  _InformacionCultivoState createState() => _InformacionCultivoState();
}

class _InformacionCultivoState extends State<InformacionCultivo> {

final nombreDistintivo = '';
final ubicacion = '';
final productoAgricola = '';
final areaSembrada = 0;
final fechaInicio = '';
final fechaFinal = '';
final presupuesto = 0;
final precioVenta = 0;
String _fecha = '';

TextEditingController _inputFieldDateController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Informacion Genaral del Cultivo')),
      ),
      body: listaInfoCultivo(context),
    );
  }

  ListView listaInfoCultivo(BuildContext context) {
    
      return ListView(
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          Icon(Icons.info, size: 80.0),
          SizedBox(height:20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(height: 10.0),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Text('  Nombre Distintivo: $nombreDistintivo'),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: ()=>_editnameAlert(context),
                )]),
              Divider(height: 10.0),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Text('  Ubicación: $ubicacion'),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: ()=>_editLocationAlert(context),
                )]),
              Divider(height: 10.0),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Text('  Área sembrada: $areaSembrada'),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: ()=>_editnumberAlert(context, 'Área Sembrada m^2', TextInputType.number),
                )]),
              Divider(height: 10.0),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Text('  Fecha de Inicio: $fechaInicio'),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: ()=>_editFechaAlert(context, 'Fecha de Inicio'),
                )]),
              Divider(height: 10.0),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Text('  Fecha de finalización: $fechaFinal'),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: ()=>_editFechaAlert(context, 'Fecha Final'),
                )]),
              Divider(height: 10.0),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Text('  Presupuesto: $presupuesto'),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: ()=>_editnumberAlert(context, 'Presupuesto', TextInputType.number),
                )]),
              Divider(height: 10.0),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Text('  Precio de venta sugerido: $precioVenta'),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: ()=>_editPrecioVentaAlert(context),
                )]),
              Divider(height: 10.0),
            ],
          )
        ]
      );
  }

  void _editnameAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (contex){
        return AlertDialog(
          title: Text('Editar Nombre Distintivo', style: TextStyle(fontSize: 18.0),),
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
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    labelText: 'Nombre Distintivo',
                    icon: Icon(Icons.drive_file_rename_outline),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: ()=>Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: ()=>Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  } 

  void _editLocationAlert(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (contex){
        return AlertDialog(
          title: Text('Editar Ubicación', style: TextStyle(fontSize: 18.0),),
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
                      borderRadius: BorderRadius.circular(10.0)
                    ),
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
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    labelText: 'Descripción',
                    icon: Icon(Icons.drive_file_rename_outline),
                  ),
                ),
              ),
            ]
          ),
           actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: ()=>Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: ()=>Navigator.of(context).pop(),
            )
          ],
        );
      },
    );    
  }

  void _editnumberAlert(BuildContext context, String titulo, TextInputType tipotext) {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (contex){
        return AlertDialog(
          title: Text('Editar $titulo', style: TextStyle(fontSize: 18.0),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _input('$titulo', tipotext,),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: ()=>Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: ()=>Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  } 

  Widget _input(String titulo, TextInputType tipotext) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      height: 60.0,
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        keyboardType: tipotext,
        style: TextStyle(fontSize: 18.0),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
          labelText: '$titulo',
          icon: Icon(Icons.drive_file_rename_outline),
        ),
      ),
    );
  } 

  void _editFechaAlert(BuildContext context, String titulo) {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (contex){
        return AlertDialog(
          title: Text('Editar $titulo', style: TextStyle(fontSize: 18.0),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _input2('$titulo'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar', style: TextStyle(fontSize: 17.0)),
              onPressed: ()=>Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Guardar', style: TextStyle(fontSize: 17.0)),
              onPressed: ()=>Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  Widget _input2(String titulo,){
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      height: 60.0,
      child: TextField(
        enableInteractiveSelection: false,
        controller: _inputFieldDateController,
        style: TextStyle(fontSize: 20.0),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0)
          ),
          labelText: '$titulo',
          icon: Icon(Icons.calendar_today),
        ),
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDate(context);
        }
      )
    );
  }

  _selectDate(BuildContext context) async{
      DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime.now(),
        lastDate: new DateTime(2050),
      );

      if (picked != null){
        setState((){
        _fecha = DateFormat('dd-MM-yyyy').format(picked);
        _inputFieldDateController.text = _fecha;
        });
      }
    }

  void _editPrecioVentaAlert(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (contex){
        return AlertDialog(
          title: Text('Editar Precio de Venta Sugerido', style: TextStyle(fontSize: 18.0),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 10.0),
                height: 60.0,
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 18.0),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    labelText: 'Cantidad de Unidades',
                    icon: Icon(Icons.drive_file_rename_outline),
                  ),
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
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    labelText: 'Porcentaje de Ganancia',
                    icon: Icon(Icons.drive_file_rename_outline),
                  ),
                ),
              ),
            ]
          ),
           actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: ()=>Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: ()=>Navigator.of(context).pop(),
            )
          ],
        );
      },
    );    
  }
}

      
