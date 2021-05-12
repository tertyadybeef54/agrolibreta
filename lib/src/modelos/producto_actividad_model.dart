// To parse this JSON data, do
//
//     final productoActividadModel = productoActividadModelFromJson(jsonString);

import 'dart:convert';

ProductoActividadModel productoActividadModelFromJson(String str) =>
    ProductoActividadModel.fromJson(json.decode(str));

String productoActividadModelToJson(ProductoActividadModel data) =>
    json.encode(data.toJson());

class ProductoActividadModel {
  ProductoActividadModel({
    this.idProductoActividad,
    this.fkidConcepto,
    this.fkidUnidadMedida,
    this.nombreProductoActividad,
  });

  int idProductoActividad;
  String fkidConcepto;
  String fkidUnidadMedida;
  String nombreProductoActividad;

  factory ProductoActividadModel.fromJson(Map<String, dynamic> json) =>
      ProductoActividadModel(
        idProductoActividad: json["idProductoActividad"],
        fkidConcepto: json["fkidConcepto"].toString(),
        fkidUnidadMedida: json["fkidUnidadMedida"].toString(),
        nombreProductoActividad: json["nombreProductoActividad"],
      );

  Map<String, dynamic> toJson() => {
        "idProductoActividad": idProductoActividad,
        "fkidConcepto": fkidConcepto,
        "fkidUnidadMedida": fkidUnidadMedida,
        "nombreProductoActividad": nombreProductoActividad,
      };
}
