

import 'package:flutter/material.dart';


class GaleriaRegistrosFotograficosPage extends StatefulWidget {

  @override
  _GaleriaRegistrosFotograficosPageState createState() => _GaleriaRegistrosFotograficosPageState();
}

class _GaleriaRegistrosFotograficosPageState extends State<GaleriaRegistrosFotograficosPage> {

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Center(
          child: Column( 
            children: [
              Text('Galeria'),
              Text('Registros Fotograficos'),
            ],
          ) 
        ),
        
      ),
      floatingActionButton: FloatingActionButton(
      child: Icon(Icons.add),
       onPressed: ()=>Navigator.pushNamed(context,'nuevoRegistroFoto'),
      ),
      
    );
  }

}
  