import 'package:agrolibreta_v2/src/pages/crear_cultivo_page.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getAplicationRoutes() {
  return <String, WidgetBuilder>{
    //'home': (BuildContext context) => HomePage(),
    //'cultivos': (BuildContext context) => CultivosPage(),
    // 'gastos': (BuildContext context) => GastosPage(),
    // 'login': (BuildContext context) => LoginPage(),
    // 'soportes': (BuildContext context) => SoportesPage(),
    'crearCultivo': (BuildContext context) => CrearCultivoPage(),
    // 'resumenGastos': (BuildContext context) => ResumenGastosPage(),
    // 'nuevoGasto': (BuildContext context) => NuevoGastoPage(),
    // 'crearUbicacion': (BuildContext context) => CrearUbicacionPage(),
    // 'vModelo': (BuildContext context) => ModeloReferencia(),
  };
}
/*

INSERT INTO Cultivos(idCultivo, idUbicacion, idEstado, idModeloReferencia, idProductoAgricola, idNombreDistintivo, areaSembrada, fechaInicio, fechaFinal, presupuesto) VALUES ('1','1','1','1','1','arveja de la buena','100','09-04-2021','','5000000');
INSERT INTO Cultivos(idCultivo, idUbicacion, idEstado, idModeloReferencia, idProductoAgricola, idNombreDistintivo, areaSembrada, fechaInicio, fechaFinal, presupuesto) VALUES ('2','1','1','1','1','la de abril','100','09-04-2021','','5000000');
INSERT INTO Cultivos(idCultivo, idUbicacion, idEstado, idModeloReferencia, idProductoAgricola, idNombreDistintivo, areaSembrada, fechaInicio, fechaFinal, presupuesto) VALUES ('3','2','1','2','1','la de vender a pedro','100','09-04-2021','','5000000');
INSERT INTO Cultivos(idCultivo, idUbicacion, idEstado, idModeloReferencia, idProductoAgricola, idNombreDistintivo, areaSembrada, fechaInicio, fechaFinal, presupuesto) VALUES ('4','2','1','2','1','la del compadre','100','09-04-2021','','5000000');



INSERT INTO TiposCostos(idTipoCosto, idConcepto, idUnidadMedida, nombreTipoCostoGeneral) VALUES ('1','2','1','abono triple 15');
INSERT INTO TiposCostos(idTipoCosto, idConcepto, idUnidadMedida, nombreTipoCostoGeneral) VALUES ('2','3','2','babosin');
INSERT INTO TiposCostos(idTipoCosto, idConcepto, idUnidadMedida, nombreTipoCostoGeneral) VALUES ('3','4','1','gallinaza');
INSERT INTO TiposCostos(idTipoCosto, idConcepto, idUnidadMedida, nombreTipoCostoGeneral) VALUES ('4','4','3','alambre');
INSERT INTO TiposCostos(idTipoCosto, idConcepto, idUnidadMedida, nombreTipoCostoGeneral) VALUES ('5','4','3','cabuya');
INSERT INTO TiposCostos(idTipoCosto, idConcepto, idUnidadMedida, nombreTipoCostoGeneral) VALUES ('6','3','4','Matarez');
INSERT INTO TiposCostos(idTipoCosto, idConcepto, idUnidadMedida, nombreTipoCostoGeneral) VALUES ('7','1','5','piquinegra');
INSERT INTO TiposCostos(idTipoCosto, idConcepto, idUnidadMedida, nombreTipoCostoGeneral) VALUES ('8','5','6','alquiler tractor');
INSERT INTO TiposCostos(idTipoCosto, idConcepto, idUnidadMedida, nombreTipoCostoGeneral) VALUES ('9','6','7','alambrada');
INSERT INTO TiposCostos(idTipoCosto, idConcepto, idUnidadMedida, nombreTipoCostoGeneral) VALUES ('10','6','7','arada');
INSERT INTO TiposCostos(idTipoCosto, idConcepto, idUnidadMedida, nombreTipoCostoGeneral) VALUES ('11','6','7','colgada');
INSERT INTO TiposCostos(idTipoCosto, idConcepto, idUnidadMedida, nombreTipoCostoGeneral) VALUES ('12','6','7','recoleccion');
INSERT INTO TiposCostos(idTipoCosto, idConcepto, idUnidadMedida, nombreTipoCostoGeneral) VALUES ('13','7','1','flete');
INSERT INTO TiposCostos(idTipoCosto, idConcepto, idUnidadMedida, nombreTipoCostoGeneral) VALUES ('14','8','3','manguera')




INSERT INTO Costos(idCosto,	idTipoCosto,	idCultivo,	idRegistroFotografico,	cantidad, valorUnidad, fecha) VALUES ('1', '1', '1', '1','3', '80000', '01-1-2021');
INSERT INTO Costos(idCosto,	idTipoCosto,	idCultivo,	idRegistroFotografico,	cantidad, valorUnidad, fecha) VALUES ('2', '2', '1', '1''4', '7000', '01-2-2021');
INSERT INTO Costos(idCosto,	idTipoCosto,	idCultivo,	idRegistroFotografico,	cantidad, valorUnidad, fecha) VALUES ('3', '3', '1', '1', '3','50000', '01-3-2021');
INSERT INTO Costos(idCosto,	idTipoCosto,	idCultivo,	idRegistroFotografico,	cantidad, valorUnidad, fecha) VALUES ('4', '4', '1', '1', '3','92000', '01-4-2021');
INSERT INTO Costos(idCosto,	idTipoCosto,	idCultivo,	idRegistroFotografico,	cantidad, valorUnidad, fecha) VALUES ('5', '5', '1', '2', '3','12000', '01-5-2021');
INSERT INTO Costos(idCosto,	idTipoCosto,	idCultivo,	idRegistroFotografico,	cantidad, valorUnidad, fecha) VALUES ('6', '6', '1', '2', '3','7500', '01-6-2021');
INSERT INTO Costos(idCosto,	idTipoCosto,	idCultivo,	idRegistroFotografico,	cantidad, valorUnidad, fecha) VALUES ('7', '7', '1', '2', '5','18000', '01-7-2021');
INSERT INTO Costos(idCosto,	idTipoCosto,	idCultivo,	idRegistroFotografico,	cantidad, valorUnidad, fecha) VALUES ('8', '8', '1', '2', '15','25000', '01-8-2021');
INSERT INTO Costos(idCosto,	idTipoCosto,	idCultivo,	idRegistroFotografico,	cantidad, valorUnidad, fecha) VALUES ('9', '9', '1', '2', '10','25000', '01-9-2021');
INSERT INTO Costos(idCosto,	idTipoCosto,	idCultivo,	idRegistroFotografico,	cantidad, valorUnidad, fecha) VALUES ('10', '10', '1', '3', '5','25000', '01-10-2021');
INSERT INTO Costos(idCosto,	idTipoCosto,	idCultivo,	idRegistroFotografico,	cantidad, valorUnidad, fecha) VALUES ('11', '11', '1', '3', '15','25000', '01-11-2021');
INSERT INTO Costos(idCosto,	idTipoCosto,	idCultivo,	idRegistroFotografico,	cantidad, valorUnidad, fecha) VALUES ('12', '12', '1', '3', '40','25000', '01-12-2021');
INSERT INTO Costos(idCosto,	idTipoCosto,	idCultivo,	idRegistroFotografico,	cantidad, valorUnidad, fecha) VALUES ('12', '13', '1', '4', '300','5000', '01-12-2021');
INSERT INTO Costos(idCosto,	idTipoCosto,	idCultivo,	idRegistroFotografico,	cantidad, valorUnidad, fecha) VALUES ('12', '14', '1', '4', '3','55000', '01-12-2021');

INSERT INTO Usuario(	idUsuario, documento, password, nombres,	apellidos, correo, fechaNacimiento) VALUES ('1', '1234', 'andres javier', 'cuadros sanabria', 'andresjavier551@gmail.com', '12-03-1997');



*/
