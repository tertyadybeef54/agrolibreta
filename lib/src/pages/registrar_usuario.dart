
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegistrarUsuario extends StatefulWidget {

  @override
  _RegistrarUsuarioState createState() => _RegistrarUsuarioState();
}

class _RegistrarUsuarioState extends State<RegistrarUsuario> {

  //Front end del formulario para registrar usuarios
  TextEditingController _inputFieldDateController = new TextEditingController();
  String _fecha = '';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Center(
          child: Text('Registrar Usuario'),
        ) 
      ),
      body:ListView( 
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        children: <Widget> [
            Text('Ingrese sus datos personales:', style: TextStyle(fontSize: 20.0)),
            SizedBox(height:20.0),
            Container(child: _crearNombres(), height: 55.0),
            Divider(),
            Container(child: _crearApellidos(), height: 55.0),
            Divider(),
            Container(child: _crearDocumento(), height: 55.0),
            Divider(),
            Container(child: _crearEmail(), height: 55.0),
            Divider(),
            Container(child: _crearFechaNacimiento(context), height: 55.0),
            Divider(),
            Container(child: _crearPassword(), height:55.0,),
            Divider(),
            Container(child: _confirmarPassword(), height: 55.0),
            SizedBox(height:30.0),
            _crearBoton(),
            
          
        ],

      ),
    );
  }

  Widget _crearNombres(){
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.name,
      style: TextStyle(fontSize: 20.0),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0)
        ),
        hintText: 'Primero y segundo Nombre',
        labelText: 'Nombres',
        icon: Icon(Icons.person_outline),
      ),
    ); 
  }

  Widget _crearApellidos(){
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.name,
      style: TextStyle(fontSize: 20.0),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0)
        ),
        hintText: 'Primero y segundo Apellido',
        labelText: 'Apellidos',
        icon: Icon(Icons.person),
      ),
    ); 
  }

  Widget _crearDocumento(){
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 20.0),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0)
        ),
        hintText: 'Número de documento',
        labelText: 'Documento',
        icon: Icon(Icons.credit_card),
        
      ),
    );
  }

  Widget _crearEmail(){
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 20.0),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0)
        ),
        hintText: 'xxx@email.com',
        labelText: 'Email',
        icon: Icon(Icons.mail_outline),
      ),
    );
  }  

  Widget _crearFechaNacimiento(BuildContext context){
    return TextField(
      enableInteractiveSelection: false,
      controller: _inputFieldDateController,
      style: TextStyle(fontSize: 20.0),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0)
        ),
        hintText: 'Fecha de Nacimiento',
        labelText: 'Fecha de Nacimiento',
        icon: Icon(Icons.calendar_today),
      ),
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context);
      }
    );
  }  

  _selectDate(BuildContext context) async{
      DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1910),
        lastDate: new DateTime(2031),
      );

      if (picked != null){
        setState((){
        _fecha = DateFormat('yyyy-MM-dd').format(picked);
        _inputFieldDateController.text = _fecha;
        });
      }
    }

  Widget _crearPassword(){
    return TextField(
      obscureText: true,
      style: TextStyle(fontSize: 20.0),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0)
        ),
        hintText: 'Contraseña',
        labelText: 'Contraseña',
        icon: Icon(Icons.lock_outline),
      ),
    );
  } 
  Widget _confirmarPassword(){
    return TextField(
      obscureText: true,
      style: TextStyle(fontSize: 20.0),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0)
        ),
        hintText: 'Confirmar Contraseña',
        labelText: 'Confirmar Contraseña',
        icon: Icon(Icons.lock),
      ),
    );
  } 
  Widget _crearBoton(){
     return Container(
       height: 48.0,
       padding: EdgeInsets.symmetric(horizontal: 60),
       child: ElevatedButton(
            child: Text('Registrarse', style: TextStyle(fontSize: 20.0),),
            onPressed: (){},
          
    ),
     );
  }
}