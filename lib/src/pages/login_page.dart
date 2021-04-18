import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:PageView(
        scrollDirection: Axis.vertical,
        children:[
          Page1(),
          Page2(),
        ],
      )
    );  
  }
}
//Front end Primera pagina, la imagen de fonto y los titulos 
class Page1 extends StatelessWidget {

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
    
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          SizedBox(height:280),
          Text('AgroLibreta', style:TextStyle(fontSize:60, fontWeight:FontWeight.bold, color: Colors.white)),
          SizedBox(height:100),
          Text('Escuela Ingenieria de Sistemas', style:TextStyle(fontSize:20, fontWeight:FontWeight.normal, color: Colors.white)),
          Text('Universidad Industrial de Santander', style:TextStyle(fontSize:20, fontWeight:FontWeight.normal, color: Colors.white)),
          Expanded(child: Container()),
          Icon(Icons.keyboard_arrow_down, size:100, color:Colors.white),
        ]
      ),
    );
  }
}

class Background extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset('assets/login.jpg'),
      height:double.infinity,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color.fromRGBO(48, 33, 17, 1.0),
            Color.fromRGBO(92, 73, 52, 1.0),
          ]
        )
      ),
    );
  }
}

//Front end segunda pagina, creacion del fondo y el formulario para el login
class Page2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
        children: <Widget> [
          _crearFondo(context),
          _loginForm(context),
        ]
      )
    );
  }

  Widget _crearFondo(BuildContext context){
    
    final size = MediaQuery.of (context).size;
  
    final fondoMarron = Container(
      height: size.height * 0.4,
      width: double.infinity, 
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color.fromRGBO(48, 33, 17, 1.0),
            Color.fromRGBO(92, 73, 52, 1.0),
          ]
        )
      ),
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
      children:<Widget>[
        fondoMarron,
        Positioned(top:50.0, left:50.0, child:circulo),
        Positioned(top:40.0, right:-30.0, child:circulo),
        Positioned(top:100.0, right:50.0, child:circulo),
        Positioned(top:230.0, right:5.0, child:circulo),
        Positioned(top:240.0, left:10.0, child:circulo),

        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children:<Widget>[
              Icon(Icons.account_circle, color:Colors.white, size:80.0),
              SizedBox(height:10.0, width: double.infinity),
              Text('AgroLibreta', style:TextStyle( color: Colors.white, fontSize: 25.0))
            ]
          ),)
      ],
    );
  }

  Widget _loginForm(BuildContext context){

    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child:Column(
        children: <Widget>[

          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ), 

          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical:30.0),
            padding: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.brown,
                  blurRadius: 3.0,
                  offset: Offset(0.0,5.0),
                  spreadRadius: 3.0,
                )
              ]
            ),
            child:Column(
              children: <Widget> [
                Text('Iniciar Sesión', style: TextStyle(fontSize: 25.0),),
                SizedBox(height:20.0),
                _crearEmail(),
                SizedBox(height:30.0),
                _crearPassword(),
                SizedBox(height:30.0),
                _crearBoton(),
              ],
            )
          )
        ],
      )
    );
  }
  Widget _crearEmail(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal:20.0),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(fontSize: 20.0),
        decoration: InputDecoration(
          icon: Icon(Icons.email_outlined, color: Colors.brown),
          hintText: 'ejemplo@correo.com',
          hintStyle: TextStyle(fontSize: 20.0),
          labelText: 'Correo electronico',
          labelStyle: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
  Widget _crearPassword(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal:20.0),
      child: TextField(
        obscureText: true,
        style: TextStyle(fontSize: 20.0),
        decoration: InputDecoration(
          icon: Icon(Icons.lock_outline, color: Colors.brown),
          labelText: 'Contraseña',
          labelStyle: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
  Widget _crearBoton(){
    
    return ElevatedButton(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal:30.0, vertical:15.0),
          child: Text('Ingresar', style: TextStyle(fontSize: 20.0),),
          
        ),
        onPressed: (){},
        style: ElevatedButton.styleFrom(primary: Colors.brown),
    );
  }

 
}