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
                child: ListTile(
                  leading: Icon(Icons.grass_rounded),
                  onTap: () {},
                  title: Text(
                      '${conceptos[index].nombreConcepto}:  ${porcentajes[index].porcentaje} %'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              );
            },
          ),
          //_sumaBoton(),
        ],
      ),
    );
  }

//###################################################

  //#######################################################
  // widges que muestra la suma restante y el boton
/*   Widget _sumaBoton() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('suma restante: $_resto %'),
          SizedBox(
            height: 10.0,
          ),
          ElevatedButton(onPressed: () {}, child: Text('Finalizar')),
          SizedBox(
            height: 30.0,
          )
        ],
      ),
    );
  } */
}
