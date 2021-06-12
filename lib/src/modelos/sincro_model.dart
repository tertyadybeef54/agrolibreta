// To parse this JSON data, do
//
//     final usersModel = usersModelFromJson(jsonString);

import 'dart:convert';

import 'package:agrolibreta_v2/src/modelos/estado_model.dart';
import 'package:agrolibreta_v2/src/modelos/registro_fotografico_model.dart';

UsersModel usersModelFromJson(String str) => UsersModel.fromJson(json.decode(str));

String usersModelToJson(UsersModel data) => json.encode(data.toJson());

class UsersModel {
    UsersModel({
        this.registrosFotograficos,
        this.estados,
    });

    List<RegistroFotograficoModel> registrosFotograficos;
    List<EstadoModel> estados;

    factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
      
        registrosFotograficos: List<RegistroFotograficoModel>.from(json["RegistrosFotograficos"].json((x) => RegistroFotograficoModel.fromJson(x))),

        estados: List<EstadoModel>.from(json["Estados"].json((x) => EstadoModel.fromJson(x))),

    );

    Map<String, dynamic> toJson() => {
        "RegistrosFotograficos": List<dynamic>.from(registrosFotograficos.map((x) => x.toJson())),
        "Estados": List<dynamic>.from(estados.map((x) => x.toJson())),
    };
}



