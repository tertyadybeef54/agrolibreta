// To parse this JSON data, do
//
//     final costoModel = costoModelFromJson(jsonString);

import 'dart:convert';

CostoModel costoModelFromJson(String str) => CostoModel.fromJson(json.decode(str));

String costoModelToJson(CostoModel data) => json.encode(data.toJson());

class CostoModel {
    CostoModel({
        this.idCosto,
        this.fkidProductoActividad,
        this.fkidCultivo,
        this.fkidRegistroFotografico,
        this.cantidad,
        this.valorUnidad,
        this.fecha,
    });

    int idCosto;
    int fkidProductoActividad;
    int fkidCultivo;
    int fkidRegistroFotografico;
    double cantidad;
    double valorUnidad;
    String fecha;

    factory CostoModel.fromJson(Map<String, dynamic> json) => CostoModel(
        idCosto: json["idCosto"],
        fkidProductoActividad: json["fkidProductoActividad"],
        fkidCultivo: json["fkidCultivo"],
        fkidRegistroFotografico: json["fkidRegistroFotografico"],
        cantidad: json["cantidad"],
        valorUnidad: json["valorUnidad"].toDouble(),
        fecha: json["fecha"],
    );

    Map<String, dynamic> toJson() => {
        "idCosto": idCosto,
        "fkidProductoActividad": fkidProductoActividad,
        "fkidCultivo": fkidCultivo,
        "fkidRegistroFotografico": fkidRegistroFotografico,
        "cantidad": cantidad,
        "valorUnidad": valorUnidad,
        "fecha": fecha,
    };
}
