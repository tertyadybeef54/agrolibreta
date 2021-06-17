import 'package:agrolibreta_v2/src/data/unidad_medida_operations.dart';
import 'package:agrolibreta_v2/src/modelos/unidad_medida_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrolibreta_v2/src/modelos/producto_actividad_model.dart';
import 'package:agrolibreta_v2/src/dataproviders/productos_actividades_data_provider.dart';
//vista donde se  listan todos los productos y actividades que existen
//está pendiente la implementacion para eliminarlos.
class ProductoActividadList extends StatelessWidget {
  final UnidadMedidaOperations _uniOper = new UnidadMedidaOperations();
  @override
  Widget build(BuildContext context) {
    //provider de datos
    final productoActividadData =
        Provider.of<ProductoActividadData>(context);
    final List<ProductoActividadModel> productosActividades =
        productoActividadData.productosActividades;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Productos y actividades')),
      ),
      body: RefreshIndicator(
        onRefresh:() => Provider.of<ProductoActividadData>(context, listen: false).getProductoActividad(),
        child: _unidadesMedidaTiles(productosActividades)),
    );
  }

  Widget _unidadesMedidaTiles(
      List<ProductoActividadModel> productosActividades) {
    return ListView.builder(
      itemCount: productosActividades.length,
      itemBuilder: (_, i) => _listTile(productosActividades[i]),
    );
  }
//items
  Widget _listTile(ProductoActividadModel productoActividad) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.label_important),
          title: Text(
              '${productoActividad.nombreProductoActividad}'),
          subtitle: unidadMedida(productoActividad.fkidUnidadMedida),
          //onTap: () {},
        ),
        Divider(),
      ],
    );
  }

//tengo la llave foranea del id de la unidad de medida
  Widget unidadMedida(String fkunidad) {
    return FutureBuilder<UnidadMedidaModel>(
        future: _uniOper.getUnidadMedidaById(int.parse(fkunidad)),
        builder:
            (BuildContext context, AsyncSnapshot<UnidadMedidaModel> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            child = Text('Unidad de Medida: ${snapshot.data.nombreUnidadMedida}');
          } else if (snapshot.hasError) {
            child = Text('Unidad de medida: generica');
          } else {
            child = SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
              width: 10,
              height: 10, //
            );
          }
          return child;
        });
  }
}
