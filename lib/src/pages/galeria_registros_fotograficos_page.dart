


//import 'dart:convert';
import 'dart:io';

import 'package:agrolibreta_v2/src/modelos/registro_fotografico_model.dart';
import 'package:flutter/material.dart';
import 'package:agrolibreta_v2/src/dataproviders/registro_fotograficos_data.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';


class GaleriaRegistrosFotograficosPage extends StatefulWidget {

  @override
  _GaleriaRegistrosFotograficosPageState createState() => _GaleriaRegistrosFotograficosPageState();
}

class _GaleriaRegistrosFotograficosPageState extends State<GaleriaRegistrosFotograficosPage> {


  @override
  Widget build(BuildContext context) {

  final regFotData = Provider.of<RegistrosFotograficosData>(context);
    final List<RegistroFotograficoModel> imagenes = regFotData.imagenes;
    imagenes.forEach((element) {
      print(element.pathFoto);
    });
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
      body: Container(
        padding: EdgeInsets.all(10),
        child:_galeria(imagenes),
      ),

      floatingActionButton: FloatingActionButton(
      child: Icon(Icons.add),
       onPressed: ()=>Navigator.pushNamed(context,'nuevoRegistroFoto'),
      ),
      
    );
  }

  Widget _galeria(List<RegistroFotograficoModel> imagenes){

    

    return StaggeredGridView.countBuilder(
    crossAxisCount: 2,
    itemCount: imagenes.length,
    itemBuilder: (BuildContext context, int index){
      
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: index.isEven ? 200 : 240,
          color: Colors.green,
          child:Image.file(File(imagenes[index].pathFoto))
        ),
      );
      
    }, 
    staggeredTileBuilder: (int index) =>
        new StaggeredTile.fit(1),
    mainAxisSpacing: 10,
    crossAxisSpacing: 20,
    );
  }

}
  