// To parse this JSON data, do
//
//     final registroFotograficoModel = registroFotograficoModelFromJson(jsonString);

import 'dart:convert';

RegistroFotograficoModel registroFotograficoModelFromJson(String str) => RegistroFotograficoModel.fromJson(json.decode(str));

String registroFotograficoModelToJson(RegistroFotograficoModel data) => json.encode(data.toJson());

class RegistroFotograficoModel {
    RegistroFotograficoModel({
        this.idRegistroFotografico,
        this.pathFoto,
    });

    int idRegistroFotografico;
    String pathFoto;

    factory RegistroFotograficoModel.fromJson(Map<String, dynamic> json) => RegistroFotograficoModel(
        idRegistroFotografico: json["idRegistroFotografico"],
        pathFoto: json["pathFoto"],
    );

    Map<String, dynamic> toJson() => {
        "idRegistroFotografico": idRegistroFotografico,
        "pathFoto": pathFoto,
    };
}
