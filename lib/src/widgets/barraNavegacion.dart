import 'package:flutter/material.dart';

class Navegacion extends StatefulWidget {
  
  @override
  _NavegacionState createState() => _NavegacionState();
}

class _NavegacionState extends State<Navegacion> {

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