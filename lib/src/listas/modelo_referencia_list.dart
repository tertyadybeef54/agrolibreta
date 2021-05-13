import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrolibreta_v2/src/modelos/concepto_model.dart';
import 'package:agrolibreta_v2/src/modelos/porcentaje_model.dart';
import 'package:agrolibreta_v2/src/modelos/modelo_referencia_model.dart';

import 'package:agrolibreta_v2/src/dataproviders/modelo_referencia_provider.dart';

class ModeloReferenciaList extends StatefulWidget {
  @override
  _ModeloReferenciaListState createState() => _ModeloReferenciaListState();
}

class _ModeloReferenciaListState extends State<ModeloReferenciaList> {
  @override
  Widget build(BuildContext context) {
    final modelosReferenciaData =
        Provider.of<ModeloReferenciaData>(context, listen: true);

    final List<ModeloReferenciaModel> modelosReferencia =
        modelosReferenciaData.modelosReferencia;
    final List<List<PorcentajeModel>> porcentajesList =
        modelosReferenciaData.porcentajesList;
    final List<List<ConceptoModel>> conceptosList =
        modelosReferenciaData.conceptosList;
    conceptosList.forEach((element) {
      element.forEach((e) {
        print(e.idConcepto);
      });
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Modelos de Referencia')),
      ),
      body: Stack(
        children: [
          _modeloReferenciaTiles(
              context, modelosReferencia, porcentajesList, conceptosList),
          _refrescar(context),
        ],
      ),
      floatingActionButton: _crearMR(context),
    );
  }

  Widget _modeloReferenciaTiles(
      BuildContext context,
      List<ModeloReferenciaModel> modelosReferencia,
      List<List<PorcentajeModel>> porcentajesList,
      List<List<ConceptoModel>> conceptosList) {
    return ListView.builder(
      itemCount: porcentajesList.length,
      itemBuilder: (_, i) => _listTile(modelosReferencia[i].idModeloReferencia,
          porcentajesList[i], conceptosList[i]),
    );
  }

  Widget _listTile(
      int i, List<PorcentajeModel> porcentajes, List<ConceptoModel> conceptos) {
    List<Widget> por = [];
    por.add(Text('$i'));
    if (porcentajes.length != 0) {
      for (int i = 0; i < porcentajes.length; i++) {
        final textTemp = Text(
            '${conceptos[i].nombreConcepto}: ${porcentajes[i].porcentaje} %');
        por.add(textTemp);
      }
    }
    por.add(Divider());
    return Column(
      children: por,
    );
  }

  Widget _crearMR(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        final modelosReferenciaData =
            Provider.of<ModeloReferenciaData>(context, listen: false);
        modelosReferenciaData.anadirModeloReferencia(0);
        Navigator.pushNamed(context, 'crearModeloReferencia');
      },
    );
  }

  Widget _refrescar(BuildContext context) {
    return Positioned(
      top: 10.0,
      right: 10.0,
      child: Ink(
        decoration: const ShapeDecoration(
          color: Colors.lightBlue,
          shape: CircleBorder(),
        ),
        child: IconButton(
          icon: const Icon(Icons.refresh),
          color: Colors.white,
          onPressed: () {
            setState(() {});
          },
        ),
      ),
    );
  }
}
