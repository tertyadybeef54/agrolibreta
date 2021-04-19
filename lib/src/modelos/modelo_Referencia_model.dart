// To parse this JSON data, do
//
//     final modeloReferenciaModel = modeloReferenciaModelFromJson(jsonString);

import 'dart:convert';

ModeloReferenciaModel modeloReferenciaModelFromJson(String str) => ModeloReferenciaModel.fromJson(json.decode(str));

String modeloReferenciaModelToJson(ModeloReferenciaModel data) => json.encode(data.toJson());

class ModeloReferenciaModel {
    ModeloReferenciaModel({
        this.idModeloReferencia,
        this.suma,
    });

    int idModeloReferencia;
    double suma;

    factory ModeloReferenciaModel.fromJson(Map<String, dynamic> json) => ModeloReferenciaModel(
        idModeloReferencia: json["idModeloReferencia"],
        suma: json["suma"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "idModeloReferencia": idModeloReferencia,
        "suma": suma,
    };
}
