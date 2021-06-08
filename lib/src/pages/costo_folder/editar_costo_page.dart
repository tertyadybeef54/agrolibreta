import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:agrolibreta_v2/src/dataproviders/costos_data_provider.dart';
import 'package:agrolibreta_v2/src/widgets/concepto_dropdown.dart';
import 'package:agrolibreta_v2/src/widgets/unidad_medida_dropdown.dart';

import 'package:agrolibreta_v2/src/data/concepto_operations.dart';
import 'package:agrolibreta_v2/src/data/costo_operations.dart';
import 'package:agrolibreta_v2/src/data/producto_actividad_operations.dart';
import 'package:agrolibreta_v2/src/data/registro_fotografico_operations.dart';
import 'package:agrolibreta_v2/src/data/unidad_medida_operations.dart';

import 'package:agrolibreta_v2/src/modelos/concepto_model.dart';
import 'package:agrolibreta_v2/src/modelos/costo_model.dart';
import 'package:agrolibreta_v2/src/modelos/producto_actividad_model.dart';
import 'package:agrolibreta_v2/src/modelos/unidad_medida_model.dart';

import 'package:agrolibreta_v2/src/widgets/producto_actividad_dropdown.dart';
import 'package:provider/provider.dart';

class EditarCostoPage extends StatefulWidget {
  @override
  EditarCostoPageState createState() => EditarCostoPageState();
}

class EditarCostoPageState extends State<EditarCostoPage> {
  //las operaciones de las 5 tablas que se usan
  //Conceptos, UnidadesMedida, ProductosActividades, RegistroFotografico, Costos
  ConceptoOperations conOper = new ConceptoOperations();
  UnidadMedidaOperations uniMedOper = new UnidadMedidaOperations();
  ProductoActividadOperations proActOper = new ProductoActividadOperations();
  RegistroFotograficoOperations regFotOper =
      new RegistroFotograficoOperations();
  CostoOperations cosOper = new CostoOperations();

  ProductoActividadModel _selectedProductoActividad;
  callback(selectedProductoActividad) {
    setState(() {
      _selectedProductoActividad = selectedProductoActividad;
    });
  }

  ConceptoModel _selectedConcepto;
  callback1(selectedConcepto) {
    setState(() {
      _selectedConcepto = selectedConcepto;
    });
  }

  UnidadMedidaModel _selectedUnidadMedida;
  callback2(selectedUnidadMedida) {
    setState(() {
      _selectedUnidadMedida = selectedUnidadMedida;
    });
  }

  //estilo de texto letra tamaño 20
  final _style = new TextStyle(
    fontSize: 20.0,
  );
  TextEditingController controlFecha = new TextEditingController();
  TextEditingController _controlCantidad = new TextEditingController();
  TextEditingController _controlValor = new TextEditingController();

  String _fechaC;
  //variables para la creacion de el producto actividad
  String _nombreProductoActividad = '';
  //variables para crear unidad de medida
  String _nombreUnidadMedida = '';
  String _descripcionUnidadMedida = '';
  CostoModel _costoTemp;
  @override
  Widget build(BuildContext context) {
    final CostoModel costo = ModalRoute.of(context).settings.arguments;

    final fecha = costo.fecha.toString();
    final fechaDate = DateTime.tryParse(fecha);
    final fechaFormatted = DateFormat('dd-MM-yyyy').format(fechaDate);

    controlFecha.text = fechaFormatted;
    _controlCantidad.text = costo.cantidad.toString();
    _controlValor.text = costo.valorUnidad.toString();
    _costoTemp = costo;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Editar Costo',
            style: _style,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
        children: [
          SizedBox(height: 20.0),
          Text(
            'Nombre del producto o actividad: ',
            style: _style,
          ),
          _seleccioneProductoActividad(),
          Divider(),
          _input('Cantidad de unidades o jornales', '5', 'Ejemplo: 5',
              TextInputType.number, 1),
          Divider(),
          _input('Valor Unidad o jornal', '5700', 'Ejemplo: 5700',
              TextInputType.number, 2),
          _valorTotal(),
          Divider(),
          _fecha(context),
          Divider(),
          _guardar(context),
        ],
      ),
    );
  }

  //1. primer dropdown - productos actividades
  //##############################################################
  //Seleccionar el producto actividad para el costo
  Widget _seleccioneProductoActividad() {
    return Row(
      children: [
        Icon(Icons.label_important, color: Colors.black45),
        SizedBox(width: 30.0),
        FutureBuilder<List<ProductoActividadModel>>(
          future: proActOper.consultarProductosActividades(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ProductosActividadesDropdowun(snapshot.data, callback)
                : Text('debe crearlos');
          },
        ),
        Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 9.0, vertical: 8.8),
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xff8c6d62)),
            ),
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: () => _registrarProductoActividad(context),
            ),
          ],
        ),
      ],
    );
  }

  // registrar un nuevo producto actividad si no existe
  void _registrarProductoActividad(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Registrar'),
            content: Column(
              //se debe mejorar para mostrarlo mas estetico
              children: [
                _seleccioneUnidadMedida(),
                Divider(),
                _inputI(
                    '', 'Nombre del prod...', 'Nombre', TextInputType.name, 3),
                _seleccioneConcepto(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    final productoActividad = new ProductoActividadModel(
                      nombreProductoActividad: _nombreProductoActividad,
                      fkidConcepto: _selectedConcepto.idConcepto.toString(),
                      fkidUnidadMedida:
                          _selectedUnidadMedida.idUnidadMedida.toString(),
                    );
                    proActOper.nuevoProductoActividad(productoActividad);
                  });
                  Navigator.pop(context);
                },
                child: Text('Guardar'),
              ),
            ],
          );
        });
  }

  //2. segundo dropdown seleccionar el concepto
  Widget _seleccioneConcepto() {
    return FutureBuilder<List<ConceptoModel>>(
      //debe consultar solo los conceptos que estan relacionados con ese cultivo
      future: conOper.consultarConceptos(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ConceptoDropdown(snapshot.data, callback1) //selected concepto
            : Text('sin conceptos');
      },
    );
  }

  //3.tercer dropdown Seleccionar unidad de medida
  Widget _seleccioneUnidadMedida() {
    return Row(
      children: [
        FutureBuilder<List<UnidadMedidaModel>>(
          future: uniMedOper.consultarUnidadesMedida(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? UnidadMedidaDropdown(snapshot.data, callback2)
                : Text('debe crearlas');
          },
        ),
        Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 9.0, vertical: 8.8),
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.lightBlue),
            ),
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: () => _registrarUnidadMedida(context),
            ),
          ],
        ),
      ],
    );
  }

  //registrar nueva unidad de medida si no existe
  void _registrarUnidadMedida(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Registrar unidad de medida'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _inputI('', 'kg', 'Ejemplo: kg', TextInputType.name, 4),
                Divider(),
                _inputI(
                    '', 'bolsas de kilo', 'Descripcion', TextInputType.name, 5),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      final unidadMedida = new UnidadMedidaModel(
                        nombreUnidadMedida: _nombreUnidadMedida,
                        descripcion: _descripcionUnidadMedida,
                      );
                      uniMedOper.nuevoUnidadMedida(unidadMedida);
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Guardar')),
            ],
          );
        });
  }

  //inputs
  //###############################################
  // ingresar el nombre 1.distintivo, 2.area sembrada 3.presupuesto y 4. nombre ubicacion 5. descripcion ubicacion
  // Se debe agrgar condicion de solo enteros para 2 y 3
  Widget _input(String descripcion, String hilabel, String labeltext,
      TextInputType tipotext, int n) {
    var inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      hintText: hilabel,
      labelText: labeltext,
      helperText: descripcion,
      icon: Icon(Icons.drive_file_rename_outline),
      //suffixIcon: Icon(Icons.touch_app),
    );
    return Container(
      padding: EdgeInsets.only(bottom: 5.0),
      height: 80.0,
      width: double.infinity,
      child: TextField(
        controller: n == 1 ? _controlCantidad : _controlValor,
        textAlignVertical: TextAlignVertical.bottom,
        keyboardType: tipotext,
        textCapitalization: TextCapitalization.sentences,
        decoration: inputDecoration,
        onChanged: (valor) {
          if (n == 1) {
            _costoTemp.cantidad = double.parse(valor);
          }
          if (n == 2) {
            _costoTemp.valorUnidad = double.parse(valor);
          }
        },
      ),
    );
  }

  //calcular valor total
  Widget _valorTotal() {
    setState(() {});
    double total = _costoTemp.valorUnidad * _costoTemp.cantidad;
    return Text(
      'Total: ${total.toString()}',
      textAlign: TextAlign.right,
    );
  }

  //input internos
  Widget _inputI(String descripcion, String hilabel, String labeltext,
      TextInputType tipotext, int n) {
    var inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      hintText: hilabel,
      labelText: labeltext,
    );
    return Container(
      padding: EdgeInsets.only(bottom: 5.0),
      height: 60.0,
      width: double.infinity,
      child: TextField(
        textAlignVertical: TextAlignVertical.bottom,
        keyboardType: tipotext,
        textCapitalization: TextCapitalization.sentences,
        decoration: inputDecoration,
        onChanged: (valor) {
          setState(() {
            if (n == 3) {
              _nombreProductoActividad = valor;
            }
            if (n == 4) {
              _nombreUnidadMedida = valor;
            }
            if (n == 5) {
              _descripcionUnidadMedida = valor;
            }
          });
        },
      ),
    );
  }

  //fecha
  //###############################################
  Widget _fecha(BuildContext context) {
    return Container(
      height: 60.0,
      child: TextField(
        textAlignVertical: TextAlignVertical.bottom,
        enableInteractiveSelection: false,
        controller: controlFecha,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          hintText: '',
          labelText: 'fecha',
          helperText: 'Seleccione fecha de compra',
          icon: Icon(Icons.calendar_today),
          suffixIcon: Icon(Icons.touch_app),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDate(context);
        },
      ),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2021),
      lastDate: new DateTime(2030),
      locale: Locale('es', 'ES'),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xff6b9b37), // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black,
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _fechaC = DateFormat('yyyyMMdd').format(picked);
        _costoTemp.fecha = int.parse(_fechaC);
        final _fechaControler = DateFormat('dd-MM-yyyy').format(picked);
        controlFecha.text = _fechaControler;
      });
    }
  }

  //guardar
  //###############################################
  //boton _guardar y guardar en la base de datos el registro del cultivo
  Widget _guardar(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
              child: Text('Guardar'),
              onPressed: () {
                _save(context);
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }

  void _save(
    BuildContext context,
  ) {
    if (_selectedProductoActividad != null) {
      _costoTemp.fkidProductoActividad =
          _selectedProductoActividad.idProductoActividad.toString();
    }
    cosOper.updateCosto(_costoTemp);
    final cosData = Provider.of<CostosData>(context, listen: false);
    cosData.conceptosList = [];
    cosData.sumasList = [];
    cosData.sugeridosList = [];
    cosData.obtenerCostosByConceptos();
  }
}