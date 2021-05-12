// To parse this JSON data, do
//
//     final registroUsuariosModel = registroUsuariosModelFromJson(jsonString);

import 'dart:convert';

RegistroUsuariosModel registroUsuariosModelFromJson(String str) => RegistroUsuariosModel.fromJson(json.decode(str));

String registroUsuariosModelToJson(RegistroUsuariosModel data) => json.encode(data.toJson());

class RegistroUsuariosModel {
    RegistroUsuariosModel({
        this.id,
        this.nombres   = '',
        this.apellidos = '',
        this.documento =123,     
        this.email     = '',
        this.fechaNacimiento = '00-00-0000',
        this.password  = '',
    });

    String id;
    String nombres;
    String apellidos;
    int documento;
    String email;
    String fechaNacimiento;
    String password;

    factory RegistroUsuariosModel.fromJson(Map<String, dynamic> json) => RegistroUsuariosModel(
        id               : json["id"],
        nombres          : json["nombres"],
        apellidos        : json["apellidos"],
        documento        : json["documento"],
        email            : json["email"],
        fechaNacimiento  : json["fechaNacimiento"],
        password         : json["password"],
    );

    Map<String, dynamic> toJson() => {
        "id"              : id,
        "nombres"         : nombres,
        "apellidos"       : apellidos,
        "documento"       : documento,
        "email"           : email,
        "fechaNacimiento" : fechaNacimiento,
        "password"        : password,
    };
}
