import 'dart:convert';

CultivoModel cultivoModelFromJson(String str) =>
    CultivoModel.fromJson(json.decode(str));

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
  String fkidUbicacion;
  String fkidEstado;
  String fkidModeloReferencia;
  String fkidProductoAgricola;
  String nombreDistintivo;
  int areaSembrada;
  String fechaInicio;
  String fechaFinal;
  int presupuesto;
  double precioVentaIdeal;

  factory CultivoModel.fromJson(Map<String, dynamic> json) => CultivoModel(
    idCultivo: json["idCultivo"],
    fkidUbicacion: json["fkidUbicacion"].toString(),
    fkidEstado: json["fkidEstado"].toString(),
    fkidModeloReferencia: json["fkidModeloReferencia"].toString(),
    fkidProductoAgricola: json["fkidProductoAgricola"].toString(),
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
