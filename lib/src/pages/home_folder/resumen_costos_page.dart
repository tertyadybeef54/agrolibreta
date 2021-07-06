import 'package:agrolibreta_v2/src/dataproviders/cultivo_data.dart';
import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrolibreta_v2/src/dataproviders/costos_data_provider.dart';

class ResumencostosPage extends StatefulWidget {
  @override
  _ResumencostosPageState createState() => _ResumencostosPageState();
}

class _ResumencostosPageState extends State<ResumencostosPage> {
  int total = 0;
  @override
  Widget build(BuildContext context) {
    final CultivoModel cultivoArg = ModalRoute.of(context).settings.arguments;

    final nombreCul = cultivoArg.nombreDistintivo;
    final idCul = cultivoArg.idCultivo;

    final cosData = Provider.of<CostosData>(context, listen: true);
    final _sumasAll = cosData.sumasList;
    final _conceptosAll = cosData.conceptosList;
    final _sugeridos = cosData.sugeridosList;
    final culData = Provider.of<CultivoData>(context, listen: false);
    culData.conceptos = [];
    culData.porcentajes = [];
    culData.consultarMR(cultivoArg.fkidModeloReferencia);

    total = 0;
    _sumasAll[idCul - 1].forEach((element) {
      total += element;
    });


    return Scaffold(
      appBar: _appBar(context, nombreCul, idCul),
      body: RefreshIndicator(
        onRefresh: _refrescar,
        child: ListView.builder(
          padding:
              EdgeInsets.only(left: 0.0, right: 0.0, top: 8.0, bottom: 20.0),
          itemCount: 4,
          itemBuilder: (context, i) {
            if (_conceptosAll.length > 0) {
              return _concepto(
                  _conceptosAll[idCul - 1][i].nombreConcepto,
                  _sumasAll[idCul - 1][i],
                  _sugeridos[idCul - 1][i],
                  _conceptosAll[idCul - 1][4 + i].nombreConcepto,
                  _sumasAll[idCul - 1][4 + i],
                  _sugeridos[idCul - 1][4 + i],
                  i + 1);
            } else
              return Center(
                child: Text('Actualizar'),
              );
          },
        ),
      ),
      floatingActionButton: _botonNuevoCosto(context, idCul),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _appBar(BuildContext context, String nombreCul, int idCul) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Column(
        children: [
          Text(nombreCul),
          Text('Total: \$' + total.toString()),
        ],
      ),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          iconSize: 40.0,
          icon: new Icon(Icons.settings),
          onPressed: () =>
              Navigator.pushNamed(context, 'configCultivo', arguments: idCul),
        ),
      ],
    );
  }

  Widget _concepto(String concepto, int totalCosto, int totalCostoSugerido,
      String concepto2, int totalCosto2, int totalCostoSugerido2, int n) {
    //colores, verde si esta bajo el presupuesto y rojo caso contrario
    TextStyle color1;
    TextStyle color2;

    if (totalCosto > totalCostoSugerido) {
      color1 = new TextStyle(color: Colors.red);
    } else {
      color1 = new TextStyle(color: Colors.black);
    }

    if (totalCosto2 > totalCostoSugerido2) {
      color2 = new TextStyle(color: Colors.red);
    } else {
      color2 = new TextStyle(color: Colors.black);
    }
    String img1 = n.toString();
    String img2 = (n + 4).toString();
    double  media = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRect(
          child: Container(
            height: 150.0,
            width: media*0.43,
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.lightGreen.shade200,
                borderRadius: BorderRadius.circular(20.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Image(
                  image: AssetImage('assets/concepto$img1.png'),
                  width: 135.0,
                  height: 85.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 5.0),
                Text(concepto, style: TextStyle(fontWeight: FontWeight.bold)),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Total: \$',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${totalCosto.toString()}', style: color1)
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Límite: \$',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${totalCostoSugerido.toString()}')
                ]),
                SizedBox(height: 5.0)
              ],
            ),
          ),
        ),
        ClipRect(
          child: Container(
            height: 150.0,
            width: media*0.43,
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.lightGreen.shade200,
                borderRadius: BorderRadius.circular(20.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Image(
                  image: AssetImage('assets/concepto$img2.png'),
                  width: 135.0,
                  height: 85.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 5.0),
                Text(concepto2, style: TextStyle(fontWeight: FontWeight.bold)),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Total: \$',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${totalCosto2.toString()}', style: color2)
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Límite: \$',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${totalCostoSugerido2.toString()}')
                ]),
                SizedBox(height: 5.0)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _botonNuevoCosto(BuildContext context, int idCul) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, 'crearCosto',
          arguments: idCul.toString()),
    );
  }

  Future<void> _refrescar() async {
    setState(() {});
  }
}
