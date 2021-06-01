import 'package:flutter/material.dart';

import 'package:agrolibreta_v2/src/data/cultivo_operations.dart';
import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';

import 'package:agrolibreta_v2/src/modelos/costo_model.dart';
import 'package:agrolibreta_v2/src/data/costo_operations.dart';
import 'package:agrolibreta_v2/src/modelos/concepto_model.dart';
import 'package:agrolibreta_v2/src/data/concepto_operations.dart';
import 'package:agrolibreta_v2/src/data/porcentaje_operations.dart';

final CostoOperations _cosOper = new CostoOperations();
final ConceptoOperations _conOper = new ConceptoOperations();
final CultivoOperations _culOper = new CultivoOperations();
final PorcentajeOperations _porOper = new PorcentajeOperations();

//provider para manejar los datos relacionados a los costos
class CostosData with ChangeNotifier {
  
  List<List<double>> sumasList = [];
  List<List<ConceptoModel>> conceptosList = [];
  List<List<double>> sugeridosList = [];

  List<CultivoModel> cultivos = [];
  List<CostoModel> costos = [];
  List<ConceptoModel> conceptos = [];

  CostosData() {
    this.getCostos();
    //this.getModelosReferencia();
  }
  getCostos() async {
    final resp = await _cosOper.consultarCostos();
    this.costos = [...resp];
    final res = await _conOper.consultarConceptos();
    this.conceptos = [...res];
    final cul = await _culOper.consultarCultivos();
    this.cultivos = [...cul];

    notifyListeners();
  }

  anadirCultivo(
      String fkidUbicacion,
      String fkidModeloReferencia,
      String nombreDistintivo,
      double areaSembrada,
      String fechaInicio,
      int presupuesto) async {
    final CultivoModel cultivo = new CultivoModel(
        fkidUbicacion: fkidUbicacion,
        fkidEstado: '1',
        fkidModeloReferencia: fkidModeloReferencia,
        fkidProductoAgricola: '1',
        nombreDistintivo: nombreDistintivo,
        areaSembrada: areaSembrada,
        fechaInicio: fechaInicio,
        fechaFinal: 'Sin especificar',
        presupuesto: presupuesto,
        precioVentaIdeal: 0);
    final resp = await _culOper.nuevoCultivo(cultivo);
    cultivo.idCultivo = resp;
    cultivos.add(cultivo);
    notifyListeners();
  }

//se obtiene una lista con todos los concepto, se consultan todos los costos para cada concepto
//en aquel concepto donde no tenga costos se asigna un "-1 " a su suma para diferenciarlo
//y removerlo.

  obtenerCostosByConceptos() {
    if (conceptosList.length == 0) {
      if (cultivos.length > 0) {
        this.cultivos.forEach((e) {
          //print(e.nombreDistintivo);

          final List<double> sumTemp = [];
          final List<ConceptoModel> conTemp = [];
          final List<double> sugTemp = [];

          this.conceptos.forEach((e2) async {
            final double resp = await _cosOper.sumaCostosByConcepto(
                e.idCultivo, e2.idConcepto.toString());
            //if (resp != -1.0) {}//aca se puede aplicar condicional para modelos de referencia con cantidad de conceptos variable, para este prototipo siempre seran 8 conceptos fijos
            //print('entró al if');
            final double sug = await _porOper.getPorcenByMRyConcep(
                e.fkidModeloReferencia,
                e2.idConcepto.toString(),
                e.presupuesto);

            sumTemp.add(resp);
            conTemp.add(e2);
            
            sugTemp.add(sug);

            //print(              ' ${e2.nombreConcepto}: ${resp.toString()} sugerido: ${sug.toString()}');
          });
          /* if (sumTemp != []) {
          } */
          this.conceptosList.add(conTemp);
          
          this.sumasList.add(sumTemp);
          this.sugeridosList.add(sugTemp);
        });
      }
    }
    print('provider costos data, carga data');
  }

  actualizarCultivos() async {
    print('provider costos actualizar cultivo');
    this.cultivos = [];
    final cul = await _culOper.consultarCultivos();
    this.cultivos = [...cul];
    notifyListeners();
  }

/* 
  List<ModeloReferenciaModel> modelosReferencia = []; //se almacenan MRs
  //List<ConceptoModel> conceptos = [];  // almacena conceptos
  List<List<PorcentajeModel>> porcentajesList =
      []; //almacena listas de porcentajes
  int id; //para controlar el ultimo modelo de referencia creado

  getModelosReferencia() async {
    final _resp = await _modOper.consultarModelosReferencia();
    this.modelosReferencia = [..._resp];
    notifyListeners();
  } */

  /*  anadirModeloReferencia(double sum) async {
    final nuevoMR = new ModeloReferenciaModel(suma: sum);
    final _id = await _modOper.nuevoModeloReferencia(nuevoMR);
    //asignar el id de la base de datos al modelo
    nuevoMR.idModeloReferencia = _id;
    this.modelosReferencia.add(nuevoMR);
    this.id = _id;
    notifyListeners();
  } */

/* //obtiene una lista de porcentajes y una lista de conceptos por cada modelo de referencia.
  obtenerByID() {
    this.modelosReferencia.forEach(
      (modelo) async {
        final _resp = await _porOper.consultarPorcentajesbyModeloReferencia(
            modelo.idModeloReferencia.toString());

        List<ConceptoModel> conceptos = []; //lista temporal de conceptos
        _resp.forEach((porcentaje) async {
          final _resp2 = await _conOper
              .getConceptoById(int.parse(porcentaje.fk2idConcepto));
          conceptos.add(_resp2);
        });
        this.conceptosList.add(conceptos); //se añade la lista de conceptos
        this.porcentajesList.add(_resp); //añade la lista de porcentajes
      },
    );
  }

  nuevoConPorList(
      List<ConceptoModel> conceptos, List<PorcentajeModel> porcentajes) {
    this.conceptosList.add(conceptos); //se añade la lista de conceptos
    this.porcentajesList.add(porcentajes); //añade la lista de porcentajes
    notifyListeners();
  }

  refrescar() {
    notifyListeners();
  } */
}
