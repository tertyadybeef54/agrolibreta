import 'package:flutter/material.dart';

class UnidadMedidaList extends StatelessWidget {

  const UnidadMedidaList();

  @override
  Widget build(BuildContext context) {

    final ubicaciones = [1, 2, 3]; 

    return ListView.builder(
      itemCount: ubicaciones.length,
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
