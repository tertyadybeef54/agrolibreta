import 'package:flutter/material.dart';

class ProductoActividadList extends StatelessWidget {

  const ProductoActividadList();

 @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('productosActividades'),
      ),
      body: _ubicacionTiles(context),
    );
  }
  Widget _ubicacionTiles(BuildContext context){
    final productosActividades = [1, 2, 3];
    return ListView.builder(
      itemCount: productosActividades.length,
      itemBuilder: (_, i) => Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        child: ListTile(
          leading: Icon(
            Icons.home_outlined,
            color: Theme.of(context).primaryColor),
          title: Text('1'),
          subtitle: Text('1'),
          onTap: () {},
        ),
      ),
    );
  }
}
