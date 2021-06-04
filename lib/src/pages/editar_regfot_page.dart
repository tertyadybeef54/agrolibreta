import 'package:agrolibreta_v2/src/data/producto_actividad_operations.dart';
import 'package:agrolibreta_v2/src/dataproviders/filtros_costos_data_provider.dart';
import 'package:agrolibreta_v2/src/modelos/costo_model.dart';
import 'package:agrolibreta_v2/src/modelos/registro_fotografico_model.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:agrolibreta_v2/src/widgets/cultivo_dropdown.dart';
import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';
import 'package:agrolibreta_v2/src/dataproviders/registro_fotograficos_data.dart';
import 'package:agrolibreta_v2/src/data/cultivo_operations.dart';

class EditarRegFotPage extends StatefulWidget {
  @override
  _EditarRegFotPageState createState() => _EditarRegFotPageState();
}

class _EditarRegFotPageState extends State<EditarRegFotPage> {
  ProductoActividadOperations _proActOper = new ProductoActividadOperations();
  String imagenRuta = '';
  CultivoOperations culOper = new CultivoOperations();
  List<Widget> listado;
  List<bool> _bloquear = [];
  List<CostoModel> _costosSelecteds = [];
  String
      _idRegFot; //para guardar el id del registro fotografico el cual será enviado al metodo guardar para actualizar el compo fkregis de los cosotos seleccionados.
  CultivoModel _selectedCultivo;
  callback2(selectedCultivo) {
    setState(() {
      _selectedCultivo = selectedCultivo;
    });
  }

  @override
  Widget build(BuildContext context) {
    final RegistroFotograficoModel imagen =
        ModalRoute.of(context).settings.arguments;
    final filData = Provider.of<FiltrosCostosData>(context, listen: true);
    _idRegFot = imagen.idRegistroFotografico.toString();
    final costosByCul = filData.costosbyCul;
    if (_bloquear.length < costosByCul.length) {
      for (var i = 0; i < costosByCul.length; i++) {
        _bloquear.add(false);
        //print(i);
      }
    }
    armarWidgets(context, costosByCul, imagen);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
            child: Column(
          children: [
            Text('Asociar'),
            Text('mas costos'),
          ],
        )),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
        itemCount: costosByCul.length + 3,
        itemBuilder: (context, index) {
          return listado[index];
        },
      ),
    );
  }

  void armarWidgets(BuildContext context, List<CostoModel> costos,
      RegistroFotograficoModel imagen) {
    listado = [];
    listado.add(imgDrop(imagen));
    listado.add(_crearBoton());
    listado.add(_titulos(context));
    int cont = 0;
    costos.forEach((costo) {
      listado.add(_costo(context, costo, cont));
      cont++;
    });
  }

  Widget imgDrop(RegistroFotograficoModel imagen) {
    final Widget body1 = Column(children: [
      Container(
          width: double.infinity,
          height: 274.0,
          color: Colors.white,
          child: imagen == null
              ? Image.asset('assets/no-image.png', height: 300.0)
              : Image.file(
                  File(imagen.pathFoto),
                )),
      SizedBox(height: 20),
      Text('Seleccione los costos asociados a esta imagen'),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Cultivo: '),
          _seleccioneCultivo(),
        ],
      ),
    ]);
    return body1;
  }

  Widget _seleccioneCultivo() {
    return Row(
      children: [
        SizedBox(width: 5.0),
        FutureBuilder<List<CultivoModel>>(
          future: culOper.consultarCultivos(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? CultivoDropdown(snapshot.data, callback2)
                : Text('sin conceptos');
          },
        ),
        SizedBox(width: 5.0),
        _botonFiltrar(context)
      ],
    );
  }

  Widget _botonFiltrar(BuildContext context) {
    final filData = Provider.of<FiltrosCostosData>(context, listen: false);
    String _idCul = '0';
    if (_selectedCultivo != null) {
      _idCul = _selectedCultivo.idCultivo.toString();
    }

    return FloatingActionButton(
      child: Icon(Icons.filter_list),
      onPressed: () {
        filData.costosByCultivo(_idCul);
        setState(() {});
      },
    );
  }

  Widget _crearBoton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: Text(
            'Guardar',
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: _guardar,
        ),
      ],
    );
  }

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
        imgIcon(ancho * 0.12),
        SizedBox(
          width: 5.0,
        )
      ],
    );
  }

  Widget imgIcon(double ancho) {
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

  Widget _costo(
    BuildContext context,
    CostoModel costo,
    int cont,
  ) {
    if (costo.fkidRegistroFotografico != '0' /* && costo.fkidRegistroFotografico != _idRegFot */) {
      return SizedBox();
    }
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
        _check(costo, ancho * 0.12, cont),
        //valor unidad
        SizedBox(
          width: 5.0,
        )
      ],
    );
  }

  Widget _check(CostoModel costo, double ancho, int i) {
    final temp = Checkbox(
        value: _bloquear[i],
        onChanged: (value) {
          setState(() {
            _bloquear[i] = _bloquear[i] ? false : true;
            if (_bloquear[i]) {
              _costosSelecteds.add(costo);
              print('añadido');
            }else{
              _costosSelecteds.remove(costo);
              print('removido');
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
              child: Center(child: child));
        });
  }
//#########################################

  void _guardar() async {
    //actualizar los costos que se añadan o quiten
    final regFotData =
        Provider.of<RegistrosFotograficosData>(context, listen: false);
    //await regFotData.nuevoRegFotografico(imagenRuta, _costosSelecteds);
    regFotData.actualizarCostosAsociados(_idRegFot, _costosSelecteds);
    mostrarSnackbar('agregados');
    Navigator.pop(context);
  }

  //metodo para crear el aviso de 'imagen guardada'
  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 2500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
