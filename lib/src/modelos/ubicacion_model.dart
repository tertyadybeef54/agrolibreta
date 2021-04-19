// To parse this JSON data, do
//
//     final productoModel = productoModelFromJson(jsonString);

import 'dart:convert';

//import 'package:flutter/cupertino.dart';

UbicacionModel ubicacionModelFromJson(String str) =>
    UbicacionModel.fromJson(json.decode(str));

String ubicacionModelToJson(UbicacionModel data) => json.encode(data.toJson());

class UbicacionModel {
  UbicacionModel({
    this.idUbicacion,
    this.nombreUbicacion,
    this.descripcion,
    this.estado,
  });

  int idUbicacion;
  String nombreUbicacion;
  String descripcion;
  int estado;

  factory UbicacionModel.fromJson(Map<String, dynamic> json) => UbicacionModel(
        idUbicacion: json["idUbicacion"],
        nombreUbicacion: json["nombreUbicacion"],
        descripcion: json["descripcion"],
        estado: json["estado"],
      );

  Map<String, dynamic> toJson() => {
        "idUbicacion": idUbicacion,
        "nombreUbicacion": nombreUbicacion,
        "descripcion": descripcion,
        "estado": estado,
      };
}
