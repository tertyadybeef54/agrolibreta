import 'package:agrolibreta_v2/src/dataproviders/porcentajes_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrolibreta_v2/src/modelos/modelo_referencia_model.dart';
import 'package:agrolibreta_v2/src/dataproviders/modelo_referencia_provider.dart';

class ModeloReferenciaList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final modelosReferenciaData = Provider.of<ModeloReferenciaData>(context);
    final List<ModeloReferenciaModel> modelosReferencia =
        modelosReferenciaData.modelosReferencia;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Modelos de Referencia')),
      ),
      body: _modeloReferenciaTiles(context, modelosReferencia),
      floatingActionButton: _crearMR(context),
    );
  }

  Widget _modeloReferenciaTiles(
      BuildContext context, List<ModeloReferenciaModel> modelosReferencia) {
    return ListView.builder(
      itemCount: modelosReferencia.length,
      itemBuilder: (_, i) => _listTile(i + 1),
    );
  }

  Widget _listTile(int i) {
    return Column(
      children: [
        ListTile(
          title: Text('MR: $i'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fertilizantes: 40%'),
              Text('Mano de obra: 60%'),
            ],
          ),
          onTap: () {},
        ),
        Divider(),
      ],
    );
  }

  Widget _crearMR(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        final porcentajesData =
            Provider.of<PorcentajeData>(context, listen: false);
        final modelosReferenciaData =
            Provider.of<ModeloReferenciaData>(context, listen: false);
        final modTemp = new ModeloReferenciaModel(
          suma: 0,
        );
        porcentajesData.idModeloReferencia =
            modelosReferenciaData.id.toString();
        modelosReferenciaData.anadirModeloReferencia(modTemp);
        Navigator.pushNamed(context, 'crearModeloReferencia');
      },
    );
  }
}
