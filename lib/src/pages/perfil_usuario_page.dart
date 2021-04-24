
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PerfilUsuarioPage extends StatefulWidget {

  @override
  _PerfilUsuarioPageState createState() => _PerfilUsuarioPageState();
}

class _PerfilUsuarioPageState extends State<PerfilUsuarioPage> {
    final  ultimaSincro ='';
    final  nombres = '';
    final  apellidos ='';
    final  numeroDocumento = 0;
    final  fechaNacimiento ='';
    final  email = '';
    String _fecha = '';

    TextEditingController _inputFieldDateController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text('Perfil de Usuario'),
        ),
      ),
      body:_listaInformacionUsuario(context),
          );
  }

  ListView _listaInformacionUsuario(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(30.0),
       children: <Widget>[
        Icon(Icons.account_circle, size: 80.0),
        SizedBox(height:10.0),
        Column(
          children: [
            Text('Email $email'),
            SizedBox(height:10.0),
            Text('Última sincronización $ultimaSincro'),
            SizedBox(height:10.0),
            _crearBoton(),
          ],
        ),
        SizedBox(height:10.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Divider(height: 10.0),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Text('  Nombres: $nombres'),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: ()=>_editInfoAlert(context, 'Nombres', TextInputType.name),
              )]),
            Divider(height: 10.0),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Text('  Apellidos: $apellidos'),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: ()=>_editInfoAlert(context, 'Apellidos', TextInputType.name),
              )]),
            Divider(height: 10.0),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Text('  Número de Documento: $numeroDocumento'),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: ()=>_editInfoAlert(context, 'Número de documento',TextInputType.number),
              )]),
            Divider(height: 10.0),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Text('  Fecha de Nacimiento: $fechaNacimiento'),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: ()=>_editFechaAlert(context),
              )]),
            Divider(height: 10.0),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Text('  Cambiar Contraseña'),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: ()=>_cambiarPasswordAlert(context),
              )]),
            Divider(height: 10.0),
            Container(
              height: 30.0,
              child: TextButton(
                child:Text('Cerrar Sesion'),
                onPressed:()=> _cerrarSesionAlert(context)),
            ), 
            Divider(height: 10.0),
          ]
        )
      ],
    );
  }

  Widget _crearBoton() {
   return ElevatedButton(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal:30.0, vertical:15.0),
          child: Text('Sincronizar datos', style: TextStyle(fontSize: 18.0),),
        ),
        onPressed: (){},
    );
  }

  void _editInfoAlert(BuildContext context, String titulo, TextInputType tipotext) {
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

  void _editFechaAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (contex){
        return AlertDialog(
          title: Text('Editar Fecha de Nacimiento' , style: TextStyle(fontSize: 18.0)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
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
                    //hintText: 'Fecha de Nacimiento',
                    labelText: 'Fecha de Nacimiento',
                    icon: Icon(Icons.calendar_today),
                  ),
                  onTap: (){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _selectDate(context);
                  }
                ),
              ),
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

  _selectDate(BuildContext context) async{
      DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1910),
        lastDate: new DateTime.now(),
      );

      if (picked != null){
        setState((){
        _fecha = DateFormat('dd-MM-yyyy').format(picked);
        _inputFieldDateController.text = _fecha;
        });
      }
    }

  void _cambiarPasswordAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, 
      builder: (contex){
        return AlertDialog(
          title: Text('Cambiar Contraseña' , style: TextStyle(fontSize: 18.0)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 10.0),
                height: 60.0,
                child: TextField(
                  obscureText: true,
                  style: TextStyle(fontSize: 18.0),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    labelText: 'Contraseña Actual',
                    icon: Icon(Icons.lock_open_outlined),
                  ),
                ),
              ),
              SizedBox(height:10.0),
              Container(
                padding: EdgeInsets.only(bottom: 10.0),
                height: 60.0,
                  child:TextField(
                    obscureText: true,
                    style: TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      labelText: 'Nueva Contraseña',
                      icon: Icon(Icons.lock_outline_rounded),
                    ),
                  ),
              ),
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

  void _cerrarSesionAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (contex){
        return AlertDialog(
          title: Text('Cerrar Sesion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('¿Seguro que desea cerrar sesion?'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: ()=>Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Cerrar Sesion'),
              onPressed: ()=>Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }
}