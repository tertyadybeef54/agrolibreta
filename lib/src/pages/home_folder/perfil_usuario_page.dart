import 'package:agrolibreta_v2/src/dataproviders/costos_data_provider.dart';
import 'package:agrolibreta_v2/src/dataproviders/usuario_data_provider.dart';
import 'package:agrolibreta_v2/src/modelos/usuario_model.dart';
import 'package:agrolibreta_v2/src/providers/registro_usuarios_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PerfilUsuarioPage extends StatefulWidget {
  @override
  _PerfilUsuarioPageState createState() => _PerfilUsuarioPageState();
}

class _PerfilUsuarioPageState extends State<PerfilUsuarioPage> {
  RegistroUsuariosModel usuario =
      new RegistroUsuariosModel(nombres: 'espere en home mientras se cargan');
  bool passOk = false;
  String nuevoPassword;
  TextEditingController _inputFieldDateController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final usuarioData = Provider.of<UsuarioProvider>(context, listen: false);
    if (usuarioData.usuarios.isNotEmpty) {
      usuario = usuarioData.usuarios[0];
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Perfil de Usuario'),
        centerTitle: true,
      ),
      body: _listaInformacionUsuario(context),
    );
  }

  ListView _listaInformacionUsuario(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(30.0),
      children: <Widget>[
        Icon(Icons.account_circle, size: 80.0),
        SizedBox(height: 10.0),
        Column(
          children: [
            Text('Email: ${usuario.email}'),
            SizedBox(height: 10.0),
            Text('Última sincronización: ${usuario.fechaUltimaSincro}'),
            SizedBox(height: 10.0),
            _crearBoton(),
          ],
        ),
        SizedBox(height: 10.0),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Divider(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('  Nombres: ${usuario.nombres}'),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () =>
                  _editInfoAlert(context, 'Nombres', TextInputType.name, 1),
            )
          ]),
          Divider(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('  Apellidos: ${usuario.apellidos}'),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () =>
                  _editInfoAlert(context, 'Apellidos', TextInputType.name, 2),
            )
          ]),
          Divider(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('  Número de Documento: ${usuario.documento}'),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _editInfoAlert(
                  context, 'Número de documento', TextInputType.number, 3),
            )
          ]),
          Divider(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('  Fecha de Nacimiento: ${usuario.fechaNacimiento}'),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _editFechaAlert(context),
            )
          ]),
          Divider(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('  Cambiar password'),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _cambiarPasswordAlert(context),
            )
          ]),
          Divider(height: 10.0),
          Container(
            height: 30.0,
            child: TextButton(
                child: Text('Cerrar Sesion'),
                onPressed: () => _cerrarSesionAlert(context)),
          ),
          Divider(height: 10.0),
        ])
      ],
    );
  }

//funcion que actualiza
  void _actualizar() {
    setState(() {
      final usuarioData = Provider.of<UsuarioProvider>(context, listen: false);
      usuarioData.actualizarData(usuario);
      Navigator.of(context).pop();
    });
  }

  Widget _crearBoton() {
    return ElevatedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
        child: Text(
          'Sincronizar datos',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
      onPressed: () => _alerta(context),
    );
  }

  Future<bool> _sincronizar() async {
    await SincronizacionProvider().subirDatos(usuario.email);
    return SincronizacionProvider().bajarDatos(usuario.email);
  }

  void _alerta(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return FutureBuilder<bool>(
            future: _sincronizar(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                children = <Widget>[
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Terminado, sus datos han sido cargados'),
                  )
                ];
                Provider.of<CostosData>(context, listen: false).getCostos();
              } else if (snapshot.hasError) {
                children = <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  )
                ];
              } else {
                children = const <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                        'Sincronizando sus Datos, por favor espere a que termine...'),
                  )
                ];
              }
              return AlertDialog(
                content: Container(
                  width: 300.0,
                  height: 400.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                ),
              );
            },
          );
        });
  }

  void _editInfoAlert(
      BuildContext context, String titulo, TextInputType tipotext, int n) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (contex) {
        return AlertDialog(
          title: Text(
            'Editar $titulo',
            style: TextStyle(fontSize: 18.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _input('$titulo', tipotext, n),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () => _actualizar(),
            )
          ],
        );
      },
    );
  }

  Widget _input(String titulo, TextInputType tipotext, int n) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      height: 60.0,
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        keyboardType: tipotext,
        style: TextStyle(fontSize: 18.0),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          labelText: '$titulo',
          icon: Icon(Icons.drive_file_rename_outline),
        ),
        onChanged: (value) {
          if (n == 1) {
            usuario.nombres = value;
          }
          if (n == 2) {
            usuario.apellidos = value;
          }
          if (n == 3) {
            usuario.documento = int.parse(value);
          }
          setState(() {});
        },
      ),
    );
  }

//editar fecha de nacimiento
  void _editFechaAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (contex) {
        return AlertDialog(
          title: Text('Editar Fecha de Nacimiento',
              style: TextStyle(fontSize: 18.0)),
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
                          borderRadius: BorderRadius.circular(15.0)),
                      //hintText: 'Fecha de Nacimiento',
                      labelText: 'Fecha de Nacimiento',
                      icon: Icon(Icons.calendar_today),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      _selectDate(context);
                    }),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar', style: TextStyle(fontSize: 17.0)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Guardar', style: TextStyle(fontSize: 17.0)),
              onPressed: () => _actualizar(),
            )
          ],
        );
      },
    );
  }

  _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1910),
      lastDate: new DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        final DateTime datehoy = DateTime.now();
        var local = datehoy.add(const Duration(hours: -6));
        print(local.toString());
        usuario.fechaNacimiento = DateFormat('dd-MM-yyyy').format(picked);
        _inputFieldDateController.text = usuario.fechaNacimiento;
      });
    }
  }

  void _cambiarPasswordAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (contex) {
        return AlertDialog(
          title: Text('Cambiar password', style: TextStyle(fontSize: 18.0)),
          content: Container(
            height: 150,
            child: ListView(
              //mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 8.0),
                  height: 50.0,
                  child: TextField(
                    obscureText: true,
                    style: TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      labelText: 'password Actual',
                      icon: Icon(Icons.lock_open_outlined),
                    ),
                    onChanged: (value) {
                      if ('${usuario.password}' == value) {
                        passOk = true;
                      }
                    },
                  ),
                ),
                SizedBox(height: 5.0),
                Container(
                  padding: EdgeInsets.only(bottom: 10.0),
                  height: 60.0,
                  child: TextField(
                    obscureText: true,
                    style: TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      labelText: 'Nuevo password',
                      icon: Icon(Icons.lock_outline_rounded),
                    ),
                    onChanged: (value) {
                      nuevoPassword = value;
                    },
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  padding: EdgeInsets.only(bottom: 10.0),
                  height: 60.0,
                  child: TextField(
                    obscureText: true,
                    style: TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      labelText: 'Repetir password',
                      icon: Icon(Icons.lock_outline_rounded),
                    ),
                    onChanged: (value) {
                      if (value == nuevoPassword && passOk == true) {
                        usuario.password = int.parse(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar', style: TextStyle(fontSize: 17.0)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Guardar', style: TextStyle(fontSize: 17.0)),
              onPressed: () => _actualizar(),
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
      builder: (contex) {
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
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Cerrar Sesion'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }
}
