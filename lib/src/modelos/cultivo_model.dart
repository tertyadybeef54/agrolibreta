// To parse this JSON data, do
//
//     final productoModel = productoModelFromJson(jsonString);

import 'dart:convert';

CultivoModel cultivoModelFromJson(String str) =>
    CultivoModel.fromJson(json.decode(str));

String cultivoModelToJson(CultivoModel data) => json.encode(data.toJson());

class CultivoModel {
  CultivoModel({
    this.idCultivo,
    this.idUbicacion,
    this.nombreCultivo,
    this.areaSembrada,
    this.fechaInicioActividades,
    this.activo,
  });

  int idCultivo;
  int idUbicacion;
  String nombreCultivo;
  double areaSembrada;
  DateTime fechaInicioActividades;
  bool activo;

  factory CultivoModel.fromJson(Map<String, dynamic> json) => CultivoModel(
        idCultivo: json["idCultivo"],
        idUbicacion: json["idUbicacion"],
        nombreCultivo: json["nombreCultivo"],
        areaSembrada: json["areaSembrada"].toDouble(),
        fechaInicioActividades: json["fechaInicioActividades"],
        activo: json["activo"],
      );

  Map<String, dynamic> toJson() => {
        "idCultivo": idCultivo,
        "idUbicacionCultivo": idUbicacion,
        "nombreCultivo": nombreCultivo,
        "areaSembrada": areaSembrada,
        "fechaInicioActividades": fechaInicioActividades,
        "activo": activo,
      };
}
