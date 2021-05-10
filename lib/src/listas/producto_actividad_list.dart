import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrolibreta_v2/src/modelos/producto_actividad_model.dart';
import 'package:agrolibreta_v2/src/dataproviders/productos_actividades_data_provider.dart';

class ProductoActividadList extends StatelessWidget {

  const ProductoActividadList();

 @override
  Widget build(BuildContext context) {
    //provider de datos
    final productoActividadData =
        Provider.of<ProductoActividadData>(context, listen: false);
    final List<ProductoActividadModel> productosActividades =
        productoActividadData.productosActividades; 


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Productos y actividades')),
      ),
      body: _unidadesMedidaTiles(productosActividades),
    );
  }
  Widget _unidadesMedidaTiles(List<ProductoActividadModel> productosActividades){
    return ListView.builder(
      itemCount: productosActividades.length,
      itemBuilder: (_, i) => _listTile(productosActividades[i]),
    );
  }
  Widget _listTile(ProductoActividadModel productoActividad) {
      return Column(
        children: [
          ListTile(
          title: Text('${productoActividad.idProductoActividad.toString()}. ${productoActividad.nombreProductoActividad}'),
          subtitle: Text('${productoActividad.fkidUnidadMedida}'),
             //onTap: () {},
           ),
          Divider(),
        ],
      );
  }
}