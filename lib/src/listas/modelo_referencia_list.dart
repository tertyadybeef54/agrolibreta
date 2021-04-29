import 'package:flutter/material.dart';

class ModeloReferenciaList extends StatelessWidget {

  const ModeloReferenciaList();

   @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('modelosReferencia'),
      ),
      body: _ubicacionTiles(context),
    );
  }
  Widget _ubicacionTiles(BuildContext context){
    final modelosReferencia = [1, 2, 3];
    return ListView.builder(
      itemCount: modelosReferencia.length,
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