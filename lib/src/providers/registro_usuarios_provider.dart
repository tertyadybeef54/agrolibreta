import 'dart:convert';

import 'package:agrolibreta_v2/src/data/costo_operations.dart';
import 'package:agrolibreta_v2/src/data/cultivo_operations.dart';
import 'package:agrolibreta_v2/src/data/modelos_referencia_operations.dart';
import 'package:agrolibreta_v2/src/data/porcentaje_operations.dart';
import 'package:agrolibreta_v2/src/data/producto_actividad_operations.dart';
import 'package:agrolibreta_v2/src/data/registro_fotografico_operations.dart';
import 'package:agrolibreta_v2/src/data/ubicaciones_operations.dart';
import 'package:agrolibreta_v2/src/data/unidad_medida_operations.dart';
import 'package:agrolibreta_v2/src/data/usuario_operations.dart';
import 'package:agrolibreta_v2/src/modelos/costo_model.dart';
import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';
import 'package:agrolibreta_v2/src/modelos/estado_model.dart';
import 'package:agrolibreta_v2/src/modelos/modelo_referencia_model.dart';
import 'package:agrolibreta_v2/src/modelos/porcentaje_model.dart';
import 'package:agrolibreta_v2/src/modelos/producto_actividad_model.dart';
import 'package:agrolibreta_v2/src/modelos/registro_fotografico_model.dart';
import 'package:agrolibreta_v2/src/modelos/usuario_model.dart';
import 'package:agrolibreta_v2/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

//estas varibales son usadas para obtener todos los datos de la base de datos
//para posteriormente enviarlas a firebase cloudstore
CostoOperations _cosOper = new CostoOperations();
CultivoOperations _culOper = new CultivoOperations();
ModelosReferenciaOperations _modOper = new ModelosReferenciaOperations();
PorcentajeOperations _porOper = new PorcentajeOperations();
ProductoActividadOperations _proOper = new ProductoActividadOperations();
RegistroFotograficoOperations _regOper = new RegistroFotograficoOperations();
UbicacionesOperations _ubiOper = new UbicacionesOperations();
UnidadMedidaOperations _uniOper = new UnidadMedidaOperations();

UsuarioOperations _usuOper = new UsuarioOperations();

//registrar un usuario en real time database
class RegistroUsuariosProvider {
  final String _url = 'https://agrolibretav1-default-rtdb.firebaseio.com';
  final _prefs = new PreferenciasUsuario();
  Future<bool> crearUsuario(RegistroUsuariosModel registro) async {
    final url = '$_url/usuarios.json?auth=${_prefs.token}';

    final resp = await http.post(Uri.parse(url),
        body: registroUsuariosModelToJson(registro));

    final decodedData = json.decode(resp.body);

    print(decodedData);
    return true;
  }

  final dbFirestore =
      FirebaseFirestore.instance.collection('users').doc('uncorreo@gmial.com');

//metodo para sincronizar los datos locales con la nube que en este caso es cloud firestore de firebase
//se hace una consulta a la base de datos locar tabla por tabla y los resultados son enviados a la nube
//en caso de ser nuevos se crea un noevo documento en la nube, en caso de hac}ber sido modificado solo se actualiza.
  Future<bool> subirDatos(/* UsersModel users */) async {
    final List<CostoModel> costos = await _cosOper.consultarCostos();
    costos.forEach((costo) async {
      await dbFirestore
          .collection('Costos')
          .doc('${costo.idCosto}')
          .set(costo.toJson());
    });
    final List<CultivoModel> cultivos = await _culOper.consultarCultivos();
    cultivos.forEach((cultivo) async {
      await dbFirestore
          .collection('Cultivos')
          .doc('${cultivo.idCultivo}')
          .set(cultivo.toJson());
    });
    final List<ModeloReferenciaModel> modRef =
        await _modOper.consultarModelosReferencia();
    modRef.forEach((modelo) async {
      await dbFirestore
          .collection('ModelosReferencia')
          .doc('${modelo.idModeloReferencia}')
          .set(modelo.toJson());
    });
    final List<PorcentajeModel> porcentajes =
        await _porOper.consultarPorcentajes();
    porcentajes.forEach((modelo) async {
      await dbFirestore
          .collection('')
          .doc('${modelo.idPorcentaje}')
          .set(modelo.toJson());
    });
    final List<ProductoActividadModel> prodActs =
        await _proOper.consultarProductosActividades();
    prodActs.forEach((modelo) async {
      await dbFirestore
          .collection('')
          .doc('${modelo.idProductoActividad}')
          .set(modelo.toJson());
    });
    final List<RegistroFotograficoModel> regFots =
        await _regOper.consultarRegistrosFotograficos();
    regFots.forEach((modelo) async {
      await dbFirestore
          .collection('')
          .doc('${modelo.idRegistroFotografico}')
          .set(modelo.toJson());
    });

/*     final idUser = 1;
    final url = '$_url/users/-MbnC5JNGx218pLFceQv.json?auth=${_prefs.token}';
    final resp = await http.put(Uri.parse(url), body: usersModelToJson(users));
    final decodedData = json.decode(resp.body);
    print(decodedData); */
    return true;
  }

  Future<bool> bajarDatos() async {
/*     final idUser = await _usuOper.getUsuarioById(1);
    final email = idUser.email;
    final db = FirebaseDatabase();
    //final userRef = db.ch
    UsersModel users = new UsersModel(); */
    await Firebase.initializeApp();
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc('uncorreo@gmial.com')
        .collection('Estados')
        .get();

    //print(snapshot.docs[0].data());

    snapshot.docs.forEach((estados) {
      final EstadoModel estTemp = new EstadoModel();
      final id = estados.data()['idEstado'].toString();
      final nombre = estados.data()['nombreEstado'].toString();

      int i = int.parse(id);
      estTemp.idEstado = i;
      estTemp.nombreEstado = nombre;
      print(estTemp.nombreEstado);
    });

    //.where("users", isEqualTo: "andres@gmail.com")
    //.snapshots();
/* 
    final url = "$_url/users.json?oderBy='correo'&limitToFirst='andres'";
    final resp = await http.get(Uri.parse(url));
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    if (decodedData == null) {
      return false;
    }
    decodedData.forEach((key, value) {
      //print(value);
      //print('################');
    }); */
    //print(decodedData);
    return true;
  }
}
