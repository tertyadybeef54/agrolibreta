

import 'package:agrolibreta_v2/src/modelos/registro_fotografico_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class GaleriaRegistrosFotograficosPage extends StatefulWidget {

  @override
  _GaleriaRegistrosFotograficosPageState createState() => _GaleriaRegistrosFotograficosPageState();
}

class _GaleriaRegistrosFotograficosPageState extends State<GaleriaRegistrosFotograficosPage> {

  List<RegistroFotograficoModel> imagenes = [];

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
      body: Container(
        padding: EdgeInsets.all(10),
        child:_galeria(),
      ),

      floatingActionButton: FloatingActionButton(
      child: Icon(Icons.add),
       onPressed: ()=>Navigator.pushNamed(context,'nuevoRegistroFoto'),
      ),
      
    );
  }

  Widget _galeria(){
    return StaggeredGridView.countBuilder(
    crossAxisCount: 2,
    itemCount: 8,
    itemBuilder: (BuildContext context, int index){
      
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: index.isEven ? 200 : 240,
          color: Colors.green,
          child:Center(
            child: Text(index.toString()),
          ),
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
  