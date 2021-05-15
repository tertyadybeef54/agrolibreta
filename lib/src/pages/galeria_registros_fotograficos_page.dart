//import 'dart:convert';
import 'dart:io';

import 'package:agrolibreta_v2/src/modelos/registro_fotografico_model.dart';
import 'package:flutter/material.dart';
import 'package:agrolibreta_v2/src/dataproviders/registro_fotograficos_data.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class GaleriaRegistrosFotograficosPage extends StatefulWidget {
  @override
  _GaleriaRegistrosFotograficosPageState createState() =>
      _GaleriaRegistrosFotograficosPageState();
}

class _GaleriaRegistrosFotograficosPageState
    extends State<GaleriaRegistrosFotograficosPage> {
  ScrollController _scrollController = new ScrollController();
  int _ultimoItem = 0;
  int _max = 5;

  @override
  void initState() {
    super.initState();
    //_agregar1();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_ultimoItem < _max) {
          _agregar1();
        }
      }
      if (_scrollController.position.pixels ==
          _scrollController.position.minScrollExtent) {
        if (_ultimoItem > 0) {
          _quitar1();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final regFotData = Provider.of<RegistrosFotograficosData>(context);
    final List<RegistroFotograficoModel> imagenes = regFotData.imagenes;
    _max = imagenes.length - 5;
    imagenes.forEach((element) {
      print('lo que hay en la abse de datos de las img');
      print(element.pathFoto);
    });
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Column(
          children: [
            Text('Galeria'),
            Text('Registros Fotograficos'),
          ],
        )),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: _galeria(imagenes),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, 'nuevoRegistroFoto'),
      ),
    );
  }

  Widget _galeria(List<RegistroFotograficoModel> imagenes) {
    return StaggeredGridView.countBuilder(
      controller: _scrollController,
      crossAxisCount: 2,
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
              height: index.isEven ? 200 : 240,
              color: Colors.green,
              child: Image.file(File(imagenes[index + _ultimoItem].pathFoto),fit: BoxFit.cover,),
              ),
        );
      },
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
      mainAxisSpacing: 10,
      crossAxisSpacing: 20,
    );
  }

  _agregar1() {
    _ultimoItem++;
    setState(() {});
  }

  _quitar1() {
    _ultimoItem--;
    setState(() {});
  }
}
