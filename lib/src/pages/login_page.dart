import 'package:flutter/material.dart';

import 'package:agrolibreta_v2/src/utils/utils.dart';
import 'package:agrolibreta_v2/src/providers/usuario_provider.dart';
import 'package:agrolibreta_v2/src/providers/registro_usuarios_provider.dart';

import 'package:agrolibreta_v2/src/blocs/provider.dart';
import 'package:agrolibreta_v2/src/blocs/login_registro_bloc.dart';
import 'package:agrolibreta_v2/src/preferencias_usuario/preferencias_usuario.dart';


class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: Scaffold(
          body: PageView(
        scrollDirection: Axis.vertical,
        children: [
          Page1(),
          Page2(),
        ],
      )),
    );
  }
}

//Front end Primera pagina, la imagen de fonto y los titulos
class Page1 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Background(),
        MainContent(),
      ],
    );
  }
}

class MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double  media = MediaQuery.of(context).size.height;
    return SafeArea(
      bottom: false,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: media*0.3),
            Text('AgroLibreta',
                style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(height: media*0.05),
            Text('Escuela Ingenieria de Sistemas',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.white)),
            Text('Universidad Industrial de Santander',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.white)),
            Expanded(child: Container()),
            Icon(Icons.keyboard_arrow_down, size: 100, color: Colors.white),
          ]),
    );
  }
}

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final circulo = Container(
      width: 80.0,
      height: 80.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.3),
      ),
    );
    return Stack(
      children: [
        Container(
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
            Color(0xff6b9b37),
            Color(0xffcfff95),
          ])),
        ),
        Positioned(top: 50.0, left: 50.0, child: circulo),
        Positioned(top: 40.0, right: -40.0, child: circulo),
        Positioned(top: 100.0, right: 110.0, child: circulo),
        Positioned(top: 220.0, right: 5.0, child: circulo),
        Positioned(top: 260.0, left: 10.0, child: circulo),
        Positioned(bottom: 80.0, left: -20.0, child: circulo),
        Positioned(bottom: 40.0, right: -20.0, child: circulo),
        Positioned(bottom: 100.0, right: 80.0, child: circulo),
        Positioned(bottom: 230.0, right: 5.0, child: circulo),
        Positioned(bottom: 200.0, left: 80.0, child: circulo),
        Positioned(bottom: -10.0, left: 120.0, child: circulo),
      ],
    );
  }
}

//Front end segunda pagina, creacion del fondo y el formulario para el login
class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final usuarioProvider = new UsuarioProvider();
  bool passwordVisible = true;
  final _prefs = new PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      _crearFondo(context),
      _loginForm(context),
    ]));
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final fondoverde = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color(0xff6b9b37),
        Color(0xffcfff95),
      ])),
    );
    final circulo = Container(
      width: 80.0,
      height: 80.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.3),
      ),
    );

    return Stack(
      children: <Widget>[
        fondoverde,
        Positioned(top: 50.0, left: 50.0, child: circulo),
        Positioned(top: 40.0, right: -30.0, child: circulo),
        Positioned(top: 100.0, right: 50.0, child: circulo),
        Positioned(top: 230.0, right: 5.0, child: circulo),
        Positioned(top: 200.0, left: 10.0, child: circulo),
        Positioned(top: -70.0, left: 120.0, child: circulo),
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(children: <Widget>[
            Icon(Icons.account_circle, color: Colors.white, size: 80.0),
            SizedBox(height: 10.0, width: double.infinity),
            Text('AgroLibreta',
                style: TextStyle(color: Colors.white, fontSize: 25.0))
          ]),
        )
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    final bloc = BlocProvider.of(context);
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        SafeArea(
          child: Container(
            height: 180.0,
          ),
        ),
        Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding:
                EdgeInsets.only(left: 0.0, right: 0.0, top: 30.0, bottom: 0.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.brown,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 5.0),
                    spreadRadius: 3.0,
                  )
                ]),
            child: Column(
              children: <Widget>[
                Text('Iniciar Sesión', style: TextStyle(fontSize: 25.0)),
                SizedBox(height: 20.0),
                _crearEmail(bloc),
                SizedBox(height: 30.0),
                _crearPassword(bloc),
                SizedBox(height: 30.0),
                _crearBoton(context, bloc),
                TextButton(
                    onPressed: () {
                      if(_prefs.password != ''){
                        _mostrarSnackbar('Inicie sesión, solo se permite un usuario por dispositivo');
                      }else{
                        Navigator.pushNamed(context, 'registrarUsuario',
                            arguments: bloc);
                      }
                    },
                    child:
                        Text('Registrarse', style: TextStyle(fontSize: 18.0))),
              ],
            )),
/*         TextButton(
            onPressed: () {
              Navigator.pushNamed(context, 'restaurarPassword');
            },
            child: Text('¿Olvido la contraseña?',
                style: TextStyle(fontSize: 18.0))), */
      ],
    ));
  }

  Widget _crearEmail(LoginRegistroBloc bloc) {
    return StreamBuilder(
        stream: bloc.emailStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontSize: 20.0),
              decoration: InputDecoration(
                icon: Icon(Icons.email_outlined, color: Colors.brown),
                hintText: 'ejemplo@correo.com',
                hintStyle: TextStyle(fontSize: 20.0),
                labelText: 'Correo electronico',
                labelStyle: TextStyle(fontSize: 20.0),
                counterText: snapshot.data,
                errorText: snapshot.error,
              ),
              onChanged: (value) => bloc.changeEmail(value),
            ),
          );
        });
  }

  Widget _crearPassword(LoginRegistroBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: passwordVisible,
            style: TextStyle(fontSize: 20.0),
            decoration: InputDecoration(
                icon: Icon(Icons.lock_outline, color: Colors.brown),
                labelText: 'Contraseña',
                labelStyle: TextStyle(fontSize: 20.0),
                counterText: snapshot.data,
                errorText: snapshot.error,
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
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _crearBoton(BuildContext context, LoginRegistroBloc bloc) {
    return StreamBuilder(
        stream: bloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ElevatedButton(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
              child: Text(
                'Ingresar',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            onPressed: snapshot.hasData ? () => _login(context, bloc) : null,
            style: ElevatedButton.styleFrom(primary: Colors.brown),
          );
        });
  }

  _login(BuildContext context, LoginRegistroBloc bloc) async {
    final password = _prefs.password;
    //si el password no esta guardado localmente
    //else compare el passwod con el ingresado
    if (password == '') {
      Map info = await usuarioProvider.login(bloc.email, bloc.password);
      if (info['ok']) {
        _mostrarSnackbar('cargando datos...');
        await SincronizacionProvider().bajarUsuario(bloc.email);
        _prefs.password = bloc.password;
        Navigator.pushReplacementNamed(context, 'taps');
      } else {
        mostrarAlerta(context, info['mensaje']);
      }
      print('Email: ${bloc.email}');
      print('Password: ${bloc.password}');
    } else {
      if (password == bloc.password) {
        Navigator.pushReplacementNamed(context, 'taps');
      } else {
        _mostrarSnackbar(
            'Contraseña incorrecta, el correo no es indispensable si ya ha iniciado sesión antes en este dispositivo.');
      }
    }
  }

  void _mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 2500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
