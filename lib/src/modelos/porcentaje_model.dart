// To parse this JSON data, do
//
//     final porcentajeModel = porcentajeModelFromJson(jsonString);

import 'dart:convert';

PorcentajeModel porcentajeModelFromJson(String str) => PorcentajeModel.fromJson(json.decode(str));

String porcentajeModelToJson(PorcentajeModel data) => json.encode(data.toJson());

class PorcentajeModel {
    PorcentajeModel({
        this.idPorcentaje,
        this.fk2idModeloReferencia,
        this.fk2idConcepto,
        this.porcentaje,
    });

    int idPorcentaje;
    String fk2idModeloReferencia;
    String fk2idConcepto;
    double porcentaje;

    factory PorcentajeModel.fromJson(Map<String, dynamic> json) => PorcentajeModel(
        idPorcentaje: json["idPorcentaje"],
        fk2idModeloReferencia: json["fk2idModeloReferencia"],
        fk2idConcepto: json["fk2idConcepto"],
        porcentaje: json["porcentaje"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "idPorcentaje": idPorcentaje,
        "fk2idModeloReferencia": fk2idModeloReferencia,
        "fk2idConcepto": fk2idConcepto,
        "porcentaje": porcentaje,
    };
}
