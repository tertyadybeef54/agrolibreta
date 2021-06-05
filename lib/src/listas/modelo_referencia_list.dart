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
    final modelosReferenciaData = Provider.of<ModeloReferenciaData>(context);

    final List<ModeloReferenciaModel> modelosReferencia =
        modelosReferenciaData.modelosReferencia;
    final List<List<PorcentajeModel>> porcentajesList =
        modelosReferenciaData.porcentajesList;
    final List<List<ConceptoModel>> conceptosList =
        modelosReferenciaData.conceptosList;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Modelos de Referencia')),
      ),
      body: _modeloReferenciaTiles(
          context, modelosReferencia, porcentajesList, conceptosList),
      floatingActionButton: _crearMR(context),
    );
  }

  Widget _modeloReferenciaTiles(
      BuildContext context,
      List<ModeloReferenciaModel> modelosReferencia,
      List<List<PorcentajeModel>> porcentajesList,
      List<List<ConceptoModel>> conceptosList) {
    return RefreshIndicator(
      onRefresh: _refrescar,
      child: ListView.builder(
        itemCount: modelosReferencia.length,
        itemBuilder: (_, i) => Dismissible(
          key: UniqueKey(),
          background: Container(
            color: Colors.red,
          ),
          onDismissed: (direction) {
            if(modelosReferencia[i].idModeloReferencia!=1){
              Provider.of<ModeloReferenciaData>(context, listen: false)
                  .eliminarModelo(modelosReferencia[i].idModeloReferencia);
            }
          },
          child: _card(modelosReferencia[i].idModeloReferencia,
              porcentajesList[i], conceptosList[i]),
        ),
      ),
    );
  }

  Widget _card(
      int i, List<PorcentajeModel> porcentajes, List<ConceptoModel> conceptos) {
    List<Widget> hijos = [];
    hijos.add(SizedBox(
      height: 13.0,
    ));
    hijos.add(Text(
      'MR: $i',
      style: TextStyle(fontWeight: FontWeight.bold),
    ));
    //hijos.add(Divider(color: Colors.black, height: 2.0,));
    if (porcentajes.length != 0) {
      for (int i = 0; i < porcentajes.length; i++) {
        final Row row = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 12.0,
                ),
                Icon(Icons.grass),
                Text('   ${conceptos[i].nombreConcepto}'),
              ],
            ),
            Text('${porcentajes[i].porcentaje} %           '),
          ],
        );
        hijos.add(row);
        hijos.add(Divider());
      }
    }

    final tarjeta = Card(
      margin: EdgeInsets.all(15.0),
      clipBehavior: Clip.antiAlias,
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        children: hijos,
      ),
    );
    return tarjeta;
  }

  Widget _crearMR(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        final modelosReferenciaData =
            Provider.of<ModeloReferenciaData>(context, listen: false);
        modelosReferenciaData
            .anadirModeloReferencia(0); //crea modelo de referencia
        Navigator.pushNamed(context, 'crearModeloReferencia');
      },
    );
  }

  Future<void> _refrescar() async {
    setState(() {});
  }
}
