import 'package:agrolibreta_v2/src/data/costo_operations.dart';
import 'package:agrolibreta_v2/src/data/producto_actividad_operations.dart';
import 'package:agrolibreta_v2/src/data/registro_fotografico_operations.dart';
import 'package:agrolibreta_v2/src/dataproviders/registro_fotograficos_data.dart';
import 'package:agrolibreta_v2/src/modelos/costo_model.dart';
import 'package:agrolibreta_v2/src/modelos/registro_fotografico_model.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetalleRegistroFotograficoPage extends StatefulWidget {
  @override
  _DetalleRegistroFotograficoPageState createState() =>
      _DetalleRegistroFotograficoPageState();
}

class _DetalleRegistroFotograficoPageState
    extends State<DetalleRegistroFotograficoPage> {
  final ProductoActividadOperations _proActOper =
      new ProductoActividadOperations();

  final CostoOperations _cosOper = new CostoOperations();
  List<CostoModel> _costosunSelecteds = [];
  final RegistroFotograficoOperations _regOper =
      new RegistroFotograficoOperations();

  int _idReg;
  int i = 0;
  //una imagen no podrá tener mas de 10 items asociados.
  List<bool> _bloquear = [
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true
  ];

  @override
  Widget build(BuildContext context) {
    final RegistroFotograficoModel imagen =
        ModalRoute.of(context).settings.arguments;
    _idReg = imagen.idRegistroFotografico;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Column(
            children: [
              Text('Detalle'),
              Text('Registro Fotografico'),
            ],
          ),
        ),
      ),
      body: futureCostos(imagen),
    );
  }

  Widget futureCostos(RegistroFotograficoModel imagen) {
    final id = imagen.idRegistroFotografico.toString();
    return FutureBuilder<List<CostoModel>>(
        future: _cosOper.costosByRegisto(id),
        builder:
            (BuildContext context, AsyncSnapshot<List<CostoModel>> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            //print(snapshot.data);
            child = page(context, imagen, snapshot.data);
          } else if (snapshot.hasError) {
            child = Text(snapshot.error);
          } else {
            child = SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
              ),
              width: 200,
              height: 200, //
            );
          }
          return child;
        });
  }

  Widget page(BuildContext context, RegistroFotograficoModel imagen,
      List<CostoModel> costos) {
    return RefreshIndicator(
      onRefresh: _refrescar,
      child: ListView(
        children: armarWidgets(context, costos, imagen),
      ),
    );
  }

  List<Widget> armarWidgets(BuildContext context, List<CostoModel> costos,
      RegistroFotograficoModel imagen) {
    List<Widget> listado = [];
    listado.add(_heroimg(imagen));
    listado.add(_botones(context, imagen));
    listado.add(_titulos(context));
    i = 0;
    costos.forEach((costo) {
      listado.add(_costo(context, costo, i));
      i++;
    });
    return listado;
  }

  Widget _heroimg(RegistroFotograficoModel imagen) {
    return Container(
      padding: EdgeInsets.only(top: 5.0, left: 8.0, right: 8.0),
      child: Hero(
        tag: imagen.pathFoto,
        child: ClipRRect(
          child: Container(
              width: double.infinity,
              height: 400.0,
              color: Colors.white,
              child: Image.file(
                File(imagen.pathFoto),
              ) //fit: BoxFit.cover),
              ),
        ),
      ),
    );
  }

  Widget _botones(BuildContext context, RegistroFotograficoModel imagen) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              child: Text(
                'Eliminar foto',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () => _confirmacion(context)),
          SizedBox(
            width: 20.0,
          ),
          TextButton(
              child: Text(
                'Añadir',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () {
                Navigator.pushNamed(context, 'editarRegistro',
                    arguments: imagen);
              }),
          SizedBox(
            width: 20.0,
          ),
          _botonGuardar(),
        ],
      ),
    );
  }

  void _confirmacion(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text('¿Quiere eliminar la foto?'),
          //content: Column(),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
            SizedBox(
              width: 20.0,
            ),
            TextButton(
              onPressed: () => _eliminar(context),
              child: Text('Sí'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _eliminar(BuildContext context) async {
    await _cosOper.updateCostobyImg(_idReg);
    await _regOper.deleteRegistroFotografico(_idReg);
    Navigator.pop(context);
    Navigator.pop(context);
    final regData =
        Provider.of<RegistrosFotograficosData>(context, listen: false);
    regData.getRegFotograficos();
  }

  //boton para guardar los cambios
  Widget _botonGuardar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          child: Text(
            'Guardar',
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: _actualizarCostos,
        ),
      ],
    );
  }

  void _actualizarCostos() async {
    final regFotData =
        Provider.of<RegistrosFotograficosData>(context, listen: false);
    regFotData.actCosDESAso(_costosunSelecteds);
    mostrarSnackbar2('Actualizados');
    Navigator.pop(context);
  }

  //metodo para crear el aviso
  void mostrarSnackbar2(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 2500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

//#########################################

  Widget _titulos(BuildContext context) {
    //estas variables permiten obtener el ancho para ser asignado a cada criterio
    final double ancho = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 5.0,
        ),
        criterio('Fecha', ancho * 0.15),
        criterio('Cant', ancho * 0.1),
        criterio('Nombre', ancho * 0.34),
        criterio('V.und', ancho * 0.20),
        _imgIcon(ancho * 0.12),
        SizedBox(
          width: 5.0,
        )
      ],
    );
  }

  //bloques que conforman la fila d cda costo
  Widget criterio(String valor, double ancho) {
    return Container(
      height: 25.0,
      width: ancho,
      margin: EdgeInsets.all(1.0),
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(3.0)),
      child: Center(child: Text(valor)),
    );
  }

  Widget _imgIcon(double ancho) {
    final widge = Container(
      height: 25.0,
      width: ancho,
      margin: EdgeInsets.all(1.0),
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(3.0)),
      child: Center(child: Icon(Icons.image)),
    );
    return widge;
  }

//##############################################################
//listado de costos representados en filas
  Widget _costo(BuildContext context, CostoModel costo, int i) {
    //ancho del cuadro y formato de la fecha
    final double ancho = MediaQuery.of(context).size.width;
    final fecha = costo.fecha.toString();
    final fechaDate = DateTime.tryParse(fecha);
    final fechaFormatted = DateFormat('dd-MM-yy').format(fechaDate);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 5.0,
        ),
        criterio(fechaFormatted, ancho * 0.15), //fecha
        criterio(costo.cantidad.toString(), ancho * 0.1), //cantidad
        criterioFuture(costo.fkidProductoActividad, ancho * 0.34),
        criterio(costo.valorUnidad.toString(), ancho * 0.2),
        _check(costo, ancho * 0.12, i),
        //valor unidad
        SizedBox(
          width: 5.0,
        )
      ],
    );
  }

  Widget criterioFuture(String fk, double ancho) {
    return FutureBuilder<String>(
        future: _proActOper.consultarNombre(fk),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            child = Text(snapshot.data);
          } else if (snapshot.hasError) {
            child = Text('nn');
          } else {
            child = SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
              width: 10,
              height: 10, //
            );
          }
          return Container(
            height: 25.0,
            width: ancho,
            margin: EdgeInsets.all(1.0),
            decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(3.0)),
            child: Center(child: child),
          );
        });
  }

  Widget _check(CostoModel costo, double ancho, int i) {
    final temp = Checkbox(
        value: _bloquear[i],
        onChanged: (value) {
          setState(() {
            _bloquear[i] = _bloquear[i] ? false : true;
            if (_bloquear[i]) {
              _costosunSelecteds.removeWhere((e) => e.idCosto == costo.idCosto);
            } else {
              _costosunSelecteds.add(costo);
            }
          });
        });
    final widge = Container(
      height: 25.0,
      width: ancho,
      margin: EdgeInsets.all(1.0),
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(3.0)),
      child: Center(child: temp),
    );
    return widge;
  }

  Future<void> _refrescar() async {
    setState(() {});
  }
}
