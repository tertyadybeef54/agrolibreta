import 'package:agrolibreta_v2/src/dataproviders/unidades_medida_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:agrolibreta_v2/src/modelos/unidad_medida_model.dart';
import 'package:provider/provider.dart';

class UnidadMedidaList extends StatelessWidget {

  const UnidadMedidaList();

 @override
  Widget build(BuildContext context) {
    //provider de las unidades de medida
    final unidadMedidaData =
        Provider.of<UnidadesMedidaData>(context, listen: false);
    final List<UnidadMedidaModel> unidadesMedida =
        unidadMedidaData.unidadesMedida; //lista de ubicaciones


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Unidades de Medida')),
      ),
      body: _unidadesMedidaTiles(unidadesMedida),
    );
  }
  Widget _unidadesMedidaTiles(List<UnidadMedidaModel> unidadesMedida){
    return ListView.builder(
      itemCount: unidadesMedida.length,
      itemBuilder: (_, i) => _listTile(unidadesMedida[i]),
    );
  }
  Widget _listTile(UnidadMedidaModel unidadMedida)  {
      return Column(
        children: [
          ListTile(
          leading: Icon(Icons.square_foot),
          title: Text('${unidadMedida.idUnidadMedida.toString()}. ${unidadMedida.nombreUnidadMedida}'),
          subtitle: Text('${unidadMedida.descripcion}'),
          ),
          Divider(),
        ],
      );
  }
}