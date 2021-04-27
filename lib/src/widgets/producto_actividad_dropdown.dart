import 'package:agrolibreta_v2/src/modelos/producto_actividad_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProductosActividadesDropdowun extends StatefulWidget {
  List<ProductoActividadModel> productosActividades;

  Function(ProductoActividadModel) callback;

  ProductosActividadesDropdowun(
    this.productosActividades,
    this.callback, {
    Key key,
  }) : super(key: key);
  @override
  _ProductosActividadesDropdownState createState() => _ProductosActividadesDropdownState();
}

class _ProductosActividadesDropdownState extends State<ProductosActividadesDropdowun> {
  String selected = 'Seleccionar';
  @override
  Widget build(BuildContext context) {
    
    return DropdownButton<ProductoActividadModel>(
      hint: Text(selected),
      onChanged: (ProductoActividadModel value) {
        setState(() {
          widget.callback(value);
          selected = value.nombreProductoActividad;
        });
      },
      items: widget.productosActividades.map((productoActividad) {
        return DropdownMenuItem(
          value: productoActividad,
          child: Text(productoActividad.nombreProductoActividad),
        );
      }).toList(),
    );
  }
}
