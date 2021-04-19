// To parse this JSON data, do
//
//     final productoAgricolaModel = productoAgricolaModelFromJson(jsonString);

import 'dart:convert';

ProductoAgricolaModel productoAgricolaModelFromJson(String str) => ProductoAgricolaModel.fromJson(json.decode(str));

String productoAgricolaModelToJson(ProductoAgricolaModel data) => json.encode(data.toJson());

class ProductoAgricolaModel {
    ProductoAgricolaModel({
        this.idProductoAgricola,
        this.nombreProducto,
    });

    int idProductoAgricola;
    String nombreProducto;

    factory ProductoAgricolaModel.fromJson(Map<String, dynamic> json) => ProductoAgricolaModel(
        idProductoAgricola: json["idProductoAgricola"],
        nombreProducto: json["nombreProducto"],
    );

    Map<String, dynamic> toJson() => {
        "idProductoAgricola": idProductoAgricola,
        "nombreProducto": nombreProducto,
    };
}
