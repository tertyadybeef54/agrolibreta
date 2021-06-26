import 'package:agrolibreta_v2/src/data/usuario_operations.dart';
import 'package:agrolibreta_v2/src/providers/usuario_provider.dart';
import 'package:agrolibreta_v2/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:agrolibreta_v2/src/utils/utils.dart' as utils;
import 'package:agrolibreta_v2/src/modelos/usuario_model.dart';
import 'package:agrolibreta_v2/src/providers/registro_usuarios_provider.dart';
import 'package:agrolibreta_v2/src/blocs/provider.dart';
//import 'package:agrolibreta_v2/src/providers/usuario_provider.dart';

class RegistrarUsuario extends StatefulWidget {
  @override
  _RegistrarUsuarioState createState() => _RegistrarUsuarioState();
}

class _RegistrarUsuarioState extends State<RegistrarUsuario> {
  //final usuarioProvider = new UsuarioProvider();

  TextEditingController _inputFieldDateController =
      new TextEditingController(); //para crear fecha
  String _fecha = ''; //variable para crear fecha
  String confirmPass = ''; // variable para confirmar el password
  final formKey = GlobalKey<FormState>(); // variable para validar formulario
  final scaffolKey = GlobalKey<ScaffoldState>();
  final UsuarioOperations _usuOper = UsuarioOperations();
  RegistroUsuariosModel registro =
      RegistroUsuariosModel(); // crear instancia para el modelo de registro a usuarios
  final registroUsuariosProvider =
      new SincronizacionProvider(); // crear instancia para el provider de registro a usuarios
  bool passwordVisible = true; //variable para hacer el password visible
  bool _error = true;
  //bloc
  final usuarioProvider = new UsuarioProvider();

  //Para realizar el registro de usuarios utilizamos dos metodos el bloc (con un inheritedWidget lladado 'provider',
  //un archivo validator y un archivo llamado 'login_registro_bloc para los sinck y streams del bloc) para guardar el correo y
  //contraseña en la autenticacion.
  //y el provider para validar los campos del fomrulario y guardarlos en la tabla usuarios

  @override
  Widget build(BuildContext context) {
    final bloc = ModalRoute.of(context).settings.arguments;
    //final bloc = BlocProvider.of(context);

    return Scaffold(
      key: scaffolKey,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Text('Registrar Usuario'),
          )),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        children: <Widget>[
          Text('Ingrese sus datos personales:',
              style: TextStyle(fontSize: 20.0)),
          Form(
              key: formKey,
              child: Column(children: <Widget>[
                SizedBox(height: 20.0),
                Container(child: _crearNombres(), height: 55.0),
                Divider(),
                Container(child: _crearApellidos(), height: 55.0),
                Divider(),
                Container(child: _crearDocumento(), height: 55.0),
                Divider(),
                Container(child: _crearFechaNacimiento(context), height: 55.0),
                Divider(),
                Container(child: _crearEmail(bloc), height: 55.0),
                Divider(),
                Container(
                  child: _crearPassword(bloc),
                  height: 55.0,
                ),
                Divider(),
                Container(child: _confirmarPassword(bloc), height: 55.0),
                SizedBox(height: 30.0),
                _crearBoton(bloc),
              ]))
        ],
      ),
    );
  }

//input para el nombre
  Widget _crearNombres() {
    return TextFormField(
        textCapitalization: TextCapitalization.words,
        keyboardType: TextInputType.name,
        style: TextStyle(fontSize: 20.0),
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          hintText: 'Primero y segundo Nombre',
          labelText: 'Nombres',
          icon: Icon(Icons.person_outline),
        ),
        onSaved: (value) => registro.nombres = value,
        onChanged: (value) => registro.nombres = value,
        validator: (String value) {
          if (value.length < 3) {
            return 'Ingrese sus nombres completos';
          } else {
            return null;
          }
        });
  }

//input para el apellido
  Widget _crearApellidos() {
    return TextFormField(
        textCapitalization: TextCapitalization.words,
        textAlignVertical: TextAlignVertical.bottom,
        keyboardType: TextInputType.name,
        style: TextStyle(fontSize: 20.0),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          hintText: 'Primero y segundo Apellido',
          labelText: 'Apellidos',
          icon: Icon(Icons.person),
        ),
        onSaved: (value) => registro.apellidos = value,
        onChanged: (value) => registro.apellidos = value,
        validator: (String value) {
          if (value.length < 5) {
            return 'Ingrese sus apellidos completos';
          } else {
            return null;
          }
        });
  }

//input para el numero de documento
  Widget _crearDocumento() {
    return TextFormField(
        keyboardType: TextInputType.number,
        textAlignVertical: TextAlignVertical.bottom,
        style: TextStyle(fontSize: 20.0),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          hintText: 'Número de documento',
          labelText: 'Documento',
          icon: Icon(Icons.credit_card),
        ),
        onSaved: (value) => registro.documento = int.parse(value),
        onChanged: (value) => registro.documento = int.parse(value),
        validator: (String value) {
          if (utils.isNumeric(value) && value.length > 5) {
            return null;
          } else {
            return 'ingrese su número de documento';
          }
        });
  }

//input para la fecha de nacimiento
  Widget _crearFechaNacimiento(BuildContext context) {
    return TextFormField(
        enableInteractiveSelection: false,
        textAlignVertical: TextAlignVertical.bottom,
        controller: _inputFieldDateController,
        style: TextStyle(fontSize: 20.0),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          hintText: 'Fecha de Nacimiento',
          labelText: 'Fecha de Nacimiento',
          icon: Icon(Icons.calendar_today),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDate(context);
        },
        onSaved: (value) => registro.fechaNacimiento = value,
        validator: (String value) {
          if (value.length < 3) {
            return 'Ingrese su fecha de nacimiento';
          } else {
            return null;
          }
        });
  }

  _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1910),
      lastDate: new DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xff6b9b37),// header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black,
            ),
          ),
          child: child,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _fecha = DateFormat('dd-MM-yyyy').format(picked);
        _inputFieldDateController.text = _fecha;
        registro.fechaNacimiento = _fecha;
      });
    }
  }

//input para el email con el metodo bloc
  Widget _crearEmail(LoginRegistroBloc bloc) {
    return StreamBuilder(
        stream: bloc.emailStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextFormField(
            keyboardType: TextInputType.emailAddress,
            textAlignVertical: TextAlignVertical.bottom,
            style: TextStyle(fontSize: 15.0),
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
              hintText: 'xxx@email.com',
              labelText: 'Email',
              //counterText: snapshot.data,
              errorText: snapshot.error,
              icon: Icon(Icons.mail_outline),
            ),
            onSaved: (value) => registro.email = value,
            onChanged: bloc.changeEmail,
          );
        });
  }

  //input para el password
  Widget _crearPassword(LoginRegistroBloc bloc) {
    return StreamBuilder(
        stream: bloc.passwordStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextFormField(
            obscureText: passwordVisible,
            style: TextStyle(fontSize: 20.0),
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                hintText: 'Contraseña',
                labelText: 'Contraseña',
                //counterText: snapshot.data,
                errorText: snapshot.error,
                icon: Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                    icon: Icon(passwordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                        print(passwordVisible);
                      });
                    })),
            onSaved: (value) => registro.password = value,
            onChanged: bloc.changePassword,
          );
        });
  }

//input para confirmar el password
  Widget _confirmarPassword(LoginRegistroBloc bloc) {
    return TextFormField(
      obscureText: passwordVisible,
      style: TextStyle(fontSize: 20.0),
      textAlignVertical: TextAlignVertical.bottom,
      decoration: InputDecoration(
        errorText: !_error?'no coinciden':null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        hintText: 'Confirmar Contraseña',
        labelText: 'Confirmar Contraseña',
        icon: Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(passwordVisible ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(
              () {
                passwordVisible = !passwordVisible;
                print(passwordVisible);
              },
            );
          },
        ),
      ),
      onChanged: (value) {
        if (value == bloc.password) {
          _error = true;
        } else {
          _error = false;
        }
        setState(() {
          
        });
      },
    );
  }

// widget para el boton
  Widget _crearBoton(LoginRegistroBloc bloc) {
    return StreamBuilder(
        stream: bloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            height: 48.0,
            padding: EdgeInsets.symmetric(horizontal: 60),
            child: ElevatedButton(
                child: Text(
                  'Registrarse',
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: snapshot.hasData
                    ? () {
                      _registrer(bloc, context);
                    }
                    : null),
          );
        });
  }

// metodo para crear el aviso de 'usuario guardado'
  void _mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 2500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void _registrer(LoginRegistroBloc bloc, BuildContext context) async {
    registro.email = bloc.email;
    registro.password = bloc.password;
    await _usuOper.nuevoUsuario(registro);
    Map info = await usuarioProvider.nuevoUsuario(bloc.email, bloc.password);
    
    if (info['ok']) {
      SincronizacionProvider().subirUser(registro.email);
      _mostrarSnackbar('Usuario registrado');
      Navigator.pop(context);
    } else {
      mostrarAlerta(context, info['mensaje']);
    }
    print('Email: ${bloc.email}');
    print('Password: ${bloc.password}');
  }
}
