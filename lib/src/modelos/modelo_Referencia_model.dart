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
//atributos del modelo
    int idModeloReferencia;
    double suma;
//función que convierte un JSON en un modelo
    factory ModeloReferenciaModel.fromJson(Map<String, dynamic> json) => ModeloReferenciaModel(
        idModeloReferencia: json["idModeloReferencia"],
        suma: json["suma"].toDouble(),
    );
//función que convierte el modelo en mapa
    Map<String, dynamic> toJson() => {
        "idModeloReferencia": idModeloReferencia,
        "suma": suma,
    };
}
