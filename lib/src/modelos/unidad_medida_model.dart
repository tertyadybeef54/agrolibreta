// To parse this JSON data, do
//
//     final unidadMedidaModel = unidadMedidaModelFromJson(jsonString);

import 'dart:convert';

UnidadMedidaModel unidadMedidaModelFromJson(String str) => UnidadMedidaModel.fromJson(json.decode(str));

String unidadMedidaModelToJson(UnidadMedidaModel data) => json.encode(data.toJson());

class UnidadMedidaModel {
    UnidadMedidaModel({
        this.idUnidadMedida,
        this.nombreUnidadMedida,
        this.descripcion,
    });

    int idUnidadMedida;
    String nombreUnidadMedida;
    String descripcion;

    factory UnidadMedidaModel.fromJson(Map<String, dynamic> json) => UnidadMedidaModel(
        idUnidadMedida: json["idUnidadMedida"],
        nombreUnidadMedida: json["nombreUnidadMedida"],
        descripcion: json["descripcion"],
    );

    Map<String, dynamic> toJson() => {
        "idUnidadMedida": idUnidadMedida,
        "nombreUnidadMedida": nombreUnidadMedida,
        "descripcion": descripcion,
    };
}
