import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrolibreta_v2/src/dataproviders/cultivo_data.dart';

class VerModeloReferencia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final culData = Provider.of<CultivoData>(context, listen: false);
    final conceptos = culData.conceptos;
    final porcentajes = culData.porcentajes;
    final idMr = culData.idMr;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Modelo de referencia: $idMr')),
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.only(
                left: 30.0, right: 30.0, top: 20.0, bottom: 90.0),
            itemCount: conceptos.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(5.0),
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                    Icon(Icons.grass_rounded),
                    SizedBox(width:10.0),
                    Text('${conceptos[index].nombreConcepto}:  ${porcentajes[index].porcentaje} %'),
                    ]
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
