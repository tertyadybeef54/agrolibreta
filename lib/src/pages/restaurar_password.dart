import 'package:flutter/material.dart';

class RestaurarPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: 
        Page2()
      
    );
  }
}
//Front end segunda pagina, creacion del fondo y el formulario para el login
class Page2 extends StatelessWidget {
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

    final fondoMarron = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(48, 33, 17, 1.0),
        Color.fromRGBO(92, 73, 52, 1.0),
      ])),
    );
    final circulo = Container(
      width: 80.0,
      height: 80.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );

    return Stack(
      children: <Widget>[
        fondoMarron,
        Positioned(top: 50.0, left: 50.0, child: circulo),
        Positioned(top: 40.0, right: -30.0, child: circulo),
        Positioned(top: 100.0, right: 50.0, child: circulo),
        Positioned(top: 230.0, right: 5.0, child: circulo),
        Positioned(top: 240.0, left: 10.0, child: circulo),
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
//formulario de login, solicita corrreo y contraseña
  Widget _loginForm(BuildContext context) {
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
            padding: EdgeInsets.symmetric(vertical: 30.0),
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
                Text(
                  'Ingrese su correo',
                  style: TextStyle(fontSize: 25.0),
                ),
                SizedBox(height: 20.0),
                _crearEmail(),
                SizedBox(height: 30.0),
                _crearBoton(context),
              ],
            )),
            Text('Al correo se enviará su nuevo password'),
        SizedBox(height: 100.0),
      ],
    ));
  }
//input del correo
  Widget _crearEmail() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(fontSize: 20.0),
        decoration: InputDecoration(
          icon: Icon(Icons.email_outlined, color: Colors.brown),
          hintText: 'ejemplo@correo.com',
          hintStyle: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
//boton de ingrsar
  Widget _crearBoton(BuildContext context) {
    return ElevatedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
        child: Text(
          'Restaurar',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(primary: Colors.brown),
    );
  }
}
