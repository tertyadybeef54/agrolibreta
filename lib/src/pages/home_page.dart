import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String nombre = '';
  String cultivo ='';
  String fecha = '';
  String ubicacion = '';
  String estado = '';
  double areaSembrada = 0;
  int presupuesto = 0;
  double precioVenta = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Center(child: Text('        Mis Cultivos')),
        actions: <Widget>[
          IconButton(
          iconSize: 40.0,
          icon: new Icon(Icons.account_circle),
          onPressed: ()=> Navigator.pushNamed(context,'perfilUsuario'),
          ),
        ],
      ),
      body: _crearListaDeCultivo(),
      
      floatingActionButton: FloatingActionButton(
      child: Icon(Icons.add),
       onPressed: (){},
      ),
      bottomNavigationBar: _Navegacion(),
    );
  }

  ListView _crearListaDeCultivo() {
    return ListView(
      padding: EdgeInsets.all( 20.0),
      children:
        _crearCards(),
    );
  }

  List <Widget> _crearCards(){

    return [
      Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Row(
          children: <Widget> [
            Image(image:AssetImage('assets/plant.jpg'),
            width: 100.0,
            height: 210.0,
            fit: BoxFit.cover,
            ),
            SizedBox(width:10.0),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0),
                Text('Nombre: $nombre'),
                Text('Cultivo de: $cultivo'),
                Text('Fecha: $fecha'),
                Text('Ubicación: $ubicacion'),
                Text('Estado: $estado'),
                Text('Área Sembrada: $areaSembrada'),
                Text('Presupuesto: $presupuesto'),
                Text('Precio de Venta: $precioVenta'),
                SizedBox(height: 20.0),
                //TextButton(onPressed: () {}, child: Text('Entrar')),
                _botonEntrar(),
              ],
            ),
          ],
        )
      )];
  }
                
  Widget _botonEntrar() {
    
    return TextButton(onPressed: () {}, child: Text('Entrar'));}
  //   return Row(
      
  //     children: [
  //       SizedBox(width: 10.0),
         
      //TextButton(onPressed: () {}, child: Text('Entrar');
        
  //     ],
  //   );
  //}
}



class _Navegacion extends StatefulWidget {
  
  @override
  __NavegacionState createState() => __NavegacionState();
}

class __NavegacionState extends State<_Navegacion> {

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      iconSize: 25,
      currentIndex: _currentIndex,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.dns), label: 'Utilidades'),
        BottomNavigationBarItem(icon: Icon(Icons.collections),label: 'Galeria'),
        BottomNavigationBarItem(icon: Icon(Icons.content_paste_rounded),label:'Informes'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label:'Consultar'),
      ],
      onTap: (index){
        setState((){
          _currentIndex = index;
        });
      },
    );
  }
}
      
