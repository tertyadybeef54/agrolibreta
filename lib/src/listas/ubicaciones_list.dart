import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrolibreta_v2/src/modelos/ubicacion_model.dart';
import 'package:agrolibreta_v2/src/dataproviders/ubicaciones_data.dart';

class UbicacionList extends StatelessWidget {
  const UbicacionList();

  @override
  Widget build(BuildContext context) {
    //provider de las ubicaciones
    final ubicacionesData =
        Provider.of<UbicacionesData>(context, listen: false);
    final List<UbicacionModel> ubicaciones =
        ubicacionesData.ubicaciones; //lista de ubicaciones

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Ubicaciones')),
      ),
      body: _ubicacionTiles(context, ubicaciones),
    );
  }

  Widget _ubicacionTiles(
      BuildContext context, List<UbicacionModel> ubicaciones) {
    return ListView.builder(
      itemCount: ubicaciones.length,
      itemBuilder: (_, i) => _listTile(ubicaciones[i]),
    );
  }

  Widget _listTile(UbicacionModel ubicacion) {
    final Widget temp = Column(
      children: [
        ListTile(
          title: Text('${ubicacion.idUbicacion.toString()}. ${ubicacion.nombreUbicacion}'),
          subtitle: Text('${ubicacion.descripcion}, estado: ${ubicacion.estado}'),
          //onTap: () {},
        ),
        Divider(),
      ],
    );
    return temp;
  }
}
