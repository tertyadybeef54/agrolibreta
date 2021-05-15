import 'package:agrolibreta_v2/src/data/registro_fotografico_operations.dart';
import 'package:flutter/material.dart';

import 'package:agrolibreta_v2/src/modelos/registro_fotografico_model.dart';


RegistroFotograficoOperations _regFotOper = RegistroFotograficoOperations();

class RegistrosFotograficosData with ChangeNotifier{
  
  List<RegistroFotograficoModel> imagenes = [];

   RegistrosFotograficosData(){
    this.getRegFotograficos();
   }
  getRegFotograficos()async{
    final resp = await _regFotOper.consultarRegistrosFotograficos();
    this.imagenes = [...resp];
    print('provider de las fotos ');
    notifyListeners();
  }
  nuevoRegFotografico(String imagenRuta) async{
    final nuevoRegFot = new RegistroFotograficoModel(pathFoto: imagenRuta);
    final _id = await _regFotOper.nuevoRegistroFotografico(nuevoRegFot);
    //asignar el id de la base de datos al local
    nuevoRegFot.idRegistroFotografico = _id;
    this.imagenes.add(nuevoRegFot);
    notifyListeners();
  }
}