import 'package:flutter/material.dart';

class UnidadMedidaList extends StatelessWidget {

  const UnidadMedidaList();

 @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Unidades de Medida')),
      ),
      body: _unidadesMedidaTiles(context),
    );
  }
  Widget _unidadesMedidaTiles(BuildContext context){
    final ubicaciones = [1, 2, 3];
    return ListView.builder(
      itemCount: ubicaciones.length,
      itemBuilder: (_, i) => _listTile(i+1),
    );
  }
  Widget _listTile(int i)  {
      return Column(
        children: [
          ListTile(
             title: Text('$i nombre'),
             subtitle: Text('descripcion'),
             onTap: () {},
           ),
          Divider(),
        ],
      );
  }
}