// To parse this JSON data, do
//
//     final cultivoModel = cultivoModelFromJson(jsonString);

import 'dart:convert';

CultivoModel cultivoModelFromJson(String str) => CultivoModel.fromJson(json.decode(str));

String cultivoModelToJson(CultivoModel data) => json.encode(data.toJson());

class CultivoModel {
    CultivoModel({
        this.idCultivo,
        this.fkidUbicacion,
        this.fkidEstado,
        this.fkidModeloReferencia,
        this.fkidProductoAgricola,
        this.nombreDistintivo,
        this.areaSembrada,
        this.fechaInicio,
        this.fechaFinal,
        this.presupuesto,
        this.precioVentaIdeal,
    });

    int idCultivo;
    int fkidUbicacion;
    int fkidEstado;
    int fkidModeloReferencia;
    int fkidProductoAgricola;
    String nombreDistintivo;
    int areaSembrada;
    String fechaInicio;
    String fechaFinal;
    int presupuesto;
    int precioVentaIdeal;

    factory CultivoModel.fromJson(Map<String, dynamic> json) => CultivoModel(
        idCultivo: json["idCultivo"],
        fkidUbicacion: json["fkidUbicacion"],
        fkidEstado: json["fkidEstado"],
        fkidModeloReferencia: json["fkidModeloReferencia"],
        fkidProductoAgricola: json["fkidProductoAgricola"],
        nombreDistintivo: json["nombreDistintivo"],
        areaSembrada: json["areaSembrada"],
        fechaInicio: json["fechaInicio"],
        fechaFinal: json["fechaFinal"],
        presupuesto: json["presupuesto"],
        precioVentaIdeal: json["precioVentaIdeal"],
    );

    Map<String, dynamic> toJson() => {
        "idCultivo": idCultivo,
        "fkidUbicacion": fkidUbicacion,
        "fkidEstado": fkidEstado,
        "fkidModeloReferencia": fkidModeloReferencia,
        "fkidProductoAgricola": fkidProductoAgricola,
        "nombreDistintivo": nombreDistintivo,
        "areaSembrada": areaSembrada,
        "fechaInicio": fechaInicio,
        "fechaFinal": fechaFinal,
        "presupuesto": presupuesto,
        "precioVentaIdeal": precioVentaIdeal,
    };
}
