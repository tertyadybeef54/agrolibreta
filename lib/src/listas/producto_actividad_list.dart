import 'package:flutter/material.dart';

class ProductoActividadList extends StatelessWidget {

  const ProductoActividadList();

 @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Productos y Actividades')),
      ),
      body: _productoActividadTiles(context),
    );
  }
  Widget _productoActividadTiles(BuildContext context){
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
             title: Text('$i. nombre: triple 15'),
             subtitle: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text('concepto: fertilizantes'),
                 Text('unidad: kg'),
               ],
             ),
             onTap: () {},
           ),
           
          Divider(),
        ],
      );
  }
}
