// To parse this JSON data, do
//
//     final conceptoModel = conceptoModelFromJson(jsonString);

import 'dart:convert';

ConceptoModel conceptoModelFromJson(String str) => ConceptoModel.fromJson(json.decode(str));

String conceptoModelToJson(ConceptoModel data) => json.encode(data.toJson());

class ConceptoModel {
  ConceptoModel({
      this.idConcepto,
      this.nombreConcepto,
  });

  int idConcepto;
  String nombreConcepto;

  factory ConceptoModel.fromJson(Map<String, dynamic> json) => ConceptoModel(
      idConcepto: json["idConcepto"],
      nombreConcepto: json["nombreConcepto"],
  );

  Map<String, dynamic> toJson() => {
      "idConcepto": idConcepto,
      "nombreConcepto": nombreConcepto,
  };
}
