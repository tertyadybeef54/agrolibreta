import 'package:agrolibreta_v2/src/dataproviders/modelo_referencia_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CrearModeloReferencia extends StatefulWidget {
  @override
  _CrearModeloReferenciaState createState() => _CrearModeloReferenciaState();
}

class _CrearModeloReferenciaState extends State<CrearModeloReferencia> {
  double _semilla = 0;
  double _fertilizantes = 0;
  double _plaguicidas = 0;
  double _materiales = 0;
  double _maquinaria = 0;
  double _manoObra = 0;
  double _transporte = 0;
  double _otros = 0;
  double _suma = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Text('Nuevo modelo de referencia'),
            Text('Cree sus porcentajes'),
          ],
        ),
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(10.0),
      children: [
        _conceptoInput('Semilla: ', '3.9', 1),
        SizedBox(
          height: 10.0,
        ),
        _conceptoInput('abonos y fertilizantes: ', '17.7', 2),
        SizedBox(
          height: 10.0,
        ),
        _conceptoInput('Plaguicidas: ', '12.1', 3),
        SizedBox(
          height: 10.0,
        ),
        _conceptoInput('Materiales y empaques', '6.7', 4),
        SizedBox(
          height: 10.0,
        ),
        _conceptoInput('Maquinaria', '6.5', 5),
        SizedBox(
          height: 10.0,
        ),
        _conceptoInput('Mano de obra', '46.1', 6),
        SizedBox(
          height: 10.0,
        ),
        _conceptoInput('Transporte', '1.5', 7),
        SizedBox(
          height: 10.0,
        ),
        _conceptoInput('Otros', '5.5', 8),
        _textoSumaBoton(context),
      ],
    );
  }

  Widget _conceptoInput(String concepto, String label, int n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Row(
              children: [
                Icon(Icons.grass),
                SizedBox(
                  width: 10.0,
                ),
                Text(concepto),
              ],
            ),
          ],
        ),
        Column(
          children: [
            Row(
              children: [
                _input1(label, n),
                SizedBox(
                  width: 10.0,
                ),
                Text('%'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _input1(String label, int n) {
    String label2 = 'Ej: ' + label;
    var inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      hintText: label,
      labelText: label2,
    );
    return Container(
      width: 100.0,
      child: TextField(
        textAlignVertical: TextAlignVertical.bottom,
        keyboardType: TextInputType.number,
        textCapitalization: TextCapitalization.sentences,
        decoration: inputDecoration,
        onChanged: (value) {
          if (n == 1) {
            _semilla = double.parse(value);
          }
          if (n == 2) {
            _fertilizantes = double.parse(value);
          }
          if (n == 3) {
            _plaguicidas = double.parse(value);
          }
          if (n == 4) {
            _materiales = double.parse(value);
          }
          if (n == 5) {
            _maquinaria = double.parse(value);
          }
          if (n == 6) {
            _manoObra = double.parse(value);
          }
          if (n == 7) {
            _transporte = double.parse(value);
          }
          if (n == 8) {
            _otros = double.parse(value);
          }
          setState(() {});
        },
      ),
    );
  }

  Widget _textoSumaBoton(BuildContext context) {
    final modData = Provider.of<ModeloReferenciaData>(context, listen: false);
    _suma = _semilla +
        _fertilizantes +
        _plaguicidas +
        _materiales +
        _maquinaria +
        _manoObra +
        _transporte +
        _otros;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('debe ser 100 y lleva: ${_suma.toString()} %'),
          SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
              onPressed: () {
                if (_suma != 100) {
                  mostrarSnackbar(context, 'la suma debe ser 100 %');
                } else {
                  modData.anadirModeloReferencia(
                      _semilla,
                      _fertilizantes,
                      _plaguicidas,
                      _materiales,
                      _maquinaria,
                      _manoObra,
                      _transporte,
                      _otros);
                  Navigator.pop(context);
                }
              },
              child: Text('Finalizar')),
          SizedBox(
            height: 30.0,
          )
        ],
      ),
    );
  }

  void mostrarSnackbar(BuildContext context, String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 2500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}