// To parse this JSON data, do
//
//     final estadoModel = estadoModelFromJson(jsonString);

import 'dart:convert';

EstadoModel estadoModelFromJson(String str) => EstadoModel.fromJson(json.decode(str));

String estadoModelToJson(EstadoModel data) => json.encode(data.toJson());

class EstadoModel {
    EstadoModel({
        this.idEstado,
        this.nombreEstado,
    });

    int idEstado;
    String nombreEstado;

    factory EstadoModel.fromJson(Map<String, dynamic> json) => EstadoModel(
        idEstado: json["idEstado"],
        nombreEstado: json["nombreEstado"],
    );

    Map<String, dynamic> toJson() => {
        "idEstado": idEstado,
        "nombreEstado": nombreEstado,
    };
}
