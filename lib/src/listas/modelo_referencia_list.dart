import 'package:flutter/material.dart';

class ModeloReferenciaList extends StatelessWidget {
  const ModeloReferenciaList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Modelos de Referencia')),
      ),
      body: _modeloReferenciaTiles(context),
      floatingActionButton: _crearMR(),
    );
  }

  Widget _modeloReferenciaTiles(BuildContext context) {
    final ubicaciones = [1, 2, 3];
    return ListView.builder(
      itemCount: ubicaciones.length,
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

  Widget _crearMR() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {});
  }
}
