import 'package:agrolibreta_v2/src/data/costo_operations.dart';
import 'package:agrolibreta_v2/src/data/cultivo_operations.dart';
import 'package:agrolibreta_v2/src/data/modelos_referencia_operations.dart';
import 'package:agrolibreta_v2/src/data/porcentaje_operations.dart';
import 'package:agrolibreta_v2/src/data/producto_actividad_operations.dart';
import 'package:agrolibreta_v2/src/data/ubicaciones_operations.dart';
import 'package:agrolibreta_v2/src/data/unidad_medida_operations.dart';
import 'package:agrolibreta_v2/src/data/usuario_operations.dart';
import 'package:agrolibreta_v2/src/modelos/costo_model.dart';
import 'package:agrolibreta_v2/src/modelos/cultivo_model.dart';
import 'package:agrolibreta_v2/src/modelos/modelo_referencia_model.dart';
import 'package:agrolibreta_v2/src/modelos/porcentaje_model.dart';
import 'package:agrolibreta_v2/src/modelos/producto_actividad_model.dart';
import 'package:agrolibreta_v2/src/modelos/ubicacion_model.dart';
import 'package:agrolibreta_v2/src/modelos/unidad_medida_model.dart';
import 'package:agrolibreta_v2/src/modelos/usuario_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//estas varibales son usadas para obtener todos los datos de la base de datos
//para posteriormente enviarlas a firebase cloudstore
CostoOperations _cosOper = new CostoOperations();
CultivoOperations _culOper = new CultivoOperations();
ModelosReferenciaOperations _modOper = new ModelosReferenciaOperations();
PorcentajeOperations _porOper = new PorcentajeOperations();
ProductoActividadOperations _proOper = new ProductoActividadOperations();
UbicacionesOperations _ubiOper = new UbicacionesOperations();
UnidadMedidaOperations _uniOper = new UnidadMedidaOperations();
UsuarioOperations _usuOper = new UsuarioOperations();
//RegistroFotograficoOperations _regOper = new RegistroFotograficoOperations();

//registrar un usuario en real time database
class SincronizacionProvider {
/*   final String _url = 'https://agrolibretav1-default-rtdb.firebaseio.com';
  final _prefs = new PreferenciasUsuario();
  Future<bool> crearUsuario(RegistroUsuariosModel registro) async {
    final url = '$_url/usuarios.json?auth=${_prefs.token}';

    final resp = await http.post(Uri.parse(url),
        body: registroUsuariosModelToJson(registro));

    final decodedData = json.decode(resp.body);

    print(decodedData);
    return true;
  } */

//metodo para sincronizar los datos locales con la nube que en este caso es cloud firestore de firebase
//se hace una consulta a la base de datos locar tabla por tabla y los resultados son enviados a la nube
//en caso de ser nuevos se crea un noevo documento en la nube, en caso de hac}ber sido modificado solo se actualiza.
  Future<bool> subirDatos(String email) async {
    print('subir datos');
    await Firebase.initializeApp();
    final dbFirestore =
        FirebaseFirestore.instance.collection('users').doc('$email');
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
      if (modelo.idModeloReferencia > 1) {
        await dbFirestore
            .collection('ModelosReferencia')
            .doc('${modelo.idModeloReferencia}')
            .set(modelo.toJson());
      }
    });

    final List<PorcentajeModel> porcentajes =
        await _porOper.consultarPorcentajes();
    porcentajes.forEach((modelo) async {
      if (modelo.idPorcentaje > 8) {
        await dbFirestore
            .collection('Porcentajes')
            .doc('${modelo.idPorcentaje}')
            .set(modelo.toJson());
      }
    });

    final List<ProductoActividadModel> prodActs =
        await _proOper.consultarProductosActividades();
    prodActs.forEach((modelo) async {
      if (modelo.idProductoActividad > 11) {
        await dbFirestore
            .collection('ProductosActividades')
            .doc('${modelo.idProductoActividad}')
            .set(modelo.toJson());
      }
    });
    final List<UbicacionModel> ubicaciones =
        await _ubiOper.consultarUbicaciones();
    ubicaciones.forEach((modelo) async {
      await dbFirestore
          .collection('Ubicaciones')
          .doc('${modelo.idUbicacion}')
          .set(modelo.toJson());
    });
    final List<UnidadMedidaModel> unidades =
        await _uniOper.consultarUnidadesMedida();
    unidades.forEach((modelo) async {
      if (modelo.idUnidadMedida > 5) {
        await dbFirestore
            .collection('UnidadesMedida')
            .doc('${modelo.idUnidadMedida}')
            .set(modelo.toJson());
      }
    });
    final List<RegistroUsuariosModel> usuario =
        await _usuOper.consultarUsuario();
    await dbFirestore
        .collection('Usuario')
        .doc('${usuario[0].idUsuario}')
        .set(usuario[0].toJson());

    return true;
/*     final List<RegistroFotograficoModel> regFots =
        await _regOper.consultarRegistrosFotograficos();
    regFots.forEach((modelo) async {
      await dbFirestore
          .collection('')
          .doc('${modelo.idRegistroFotografico}')
          .set(modelo.toJson());
    }); */

/*     final idUser = 1;
    final url = '$_url/users/-MbnC5JNGx218pLFceQv.json?auth=${_prefs.token}';
    final resp = await http.put(Uri.parse(url), body: usersModelToJson(users));
    final decodedData = json.decode(resp.body);
    print(decodedData); */
  }

  Future<bool> bajarDatos(String email) async {
    print('bajar datos');
    await Firebase.initializeApp();
    final snapshot =
        FirebaseFirestore.instance.collection('users').doc('$email');

    final cul = await _culOper.consultarCultivos();

    if (cul.length == 0) {
      final cultivos = await snapshot.collection('Cultivos').get();
      cultivos.docs.forEach((cultivo) {
        final CultivoModel culTemp = new CultivoModel();

        final String idCultivo = cultivo["idCultivo"].toString();
        final String fkidUbicacion = cultivo["fkidUbicacion"].toString();
        final String fkidEstado = cultivo["fkidEstado"].toString();
        final String fkidModeloReferencia =
            cultivo["fkidModeloReferencia"].toString();
        final String fkidProductoAgricola =
            cultivo["fkidProductoAgricola"].toString();
        final String nombreDistintivo = cultivo["nombreDistintivo"].toString();
        final String areaSembrada = cultivo["areaSembrada"].toString();
        final String fechaInicio = cultivo["fechaInicio"].toString();
        final String fechaFinal = cultivo["fechaFinal"].toString();
        final String presupuesto = cultivo["presupuesto"].toString();
        final String precioVentaIdeal = cultivo["precioVentaIdeal"].toString();

        culTemp.idCultivo = int.parse(idCultivo);
        culTemp.fkidUbicacion = fkidUbicacion;
        culTemp.fkidEstado = fkidEstado;
        culTemp.fkidModeloReferencia = fkidModeloReferencia;
        culTemp.fkidProductoAgricola = fkidProductoAgricola;
        culTemp.nombreDistintivo = nombreDistintivo;
        culTemp.areaSembrada = double.parse(areaSembrada);
        culTemp.fechaInicio = fechaInicio;
        culTemp.fechaFinal = fechaFinal;
        culTemp.presupuesto = int.parse(presupuesto);
        culTemp.precioVentaIdeal = double.parse(precioVentaIdeal);

        _culOper.nuevoCultivo(culTemp);
      });

      final costos = await snapshot.collection('Costos').get();
      costos.docs.forEach((costo) {
        final CostoModel cosTemp = new CostoModel();
        final String idCosto = costo["idCosto"].toString();
        final String fkidProductoActividad =
            costo["fkidProductoActividad"].toString();
        final String fkidCultivo = costo["fkidCultivo"].toString();
        final String fkidRegistroFotografico =
            costo["fkidRegistroFotografico"].toString();
        final String cantidad = costo["cantidad"].toString();
        final String valorUnidad = costo["valorUnidad"].toString();
        final String fecha = costo["fecha"].toString();

        cosTemp.idCosto = int.parse(idCosto);
        cosTemp.fkidProductoActividad = fkidProductoActividad;
        cosTemp.fkidCultivo = fkidCultivo;
        cosTemp.fkidRegistroFotografico = fkidRegistroFotografico;
        cosTemp.cantidad = double.parse(cantidad);
        cosTemp.valorUnidad = double.parse(valorUnidad);
        cosTemp.fecha = int.parse(fecha);

        _cosOper.nuevoCosto(cosTemp);
      });

      final modelos = await snapshot.collection('ModelosReferencia').get();
      modelos.docs.forEach((modelo) {
        final ModeloReferenciaModel modTemp = new ModeloReferenciaModel();
        final String idModeloReferencia =
            modelo["idModeloReferencia"].toString();
        final String suma = modelo["suma"].toString();

        modTemp.idModeloReferencia = int.parse(idModeloReferencia);
        modTemp.suma = double.parse(suma);

        _modOper.nuevoModeloReferencia(modTemp);
      });

      ///bajar porcentajes a la base de datos local
      final porcentajes = await snapshot.collection('Porcentajes').get();
      porcentajes.docs.forEach((porcentaj) {
        final PorcentajeModel porTemp = new PorcentajeModel();

        final String idPorcentaje = porcentaj["idPorcentaje"].toString();
        final String fk2idModeloReferencia =
            porcentaj["fk2idModeloReferencia"].toString();
        final String fk2idConcepto = porcentaj["fk2idConcepto"].toString();
        final String porcentaje = porcentaj["porcentaje"].toString();

        porTemp.idPorcentaje = int.parse(idPorcentaje);
        porTemp.fk2idModeloReferencia = fk2idModeloReferencia;
        porTemp.fk2idConcepto = fk2idConcepto;
        porTemp.porcentaje = double.parse(porcentaje);

        _porOper.nuevoPorcentaje(porTemp);
      });
    }
    return true;
    /*        .collection('Estados')
        .get();

    snapshot.docs.forEach((estados) {
      final EstadoModel estTemp = new EstadoModel();
      final id = estados.data()['idEstado'].toString();
      final nombre = estados.data()['nombreEstado'].toString();

      int i = int.parse(id);
      estTemp.idEstado = i;
      estTemp.nombreEstado = nombre;
      print(estTemp.nombreEstado);
    });

     final idUser = await _usuOper.getUsuarioById(1);
    final email = idUser.email;
    final db = FirebaseDatabase();
    //final userRef = db.ch
    UsersModel users = new UsersModel(); 

    //print(snapshot.docs[0].data());
    //.where("users", isEqualTo: "andres@gmail.com")
    //.snapshots();
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
  }

  Future<bool> bajarUsuario(String correo) async {
    await Firebase.initializeApp();
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc('$correo')
        .collection('Usuario')
        .doc('1')
        .get();

    if (snapshot.exists) {
      final RegistroUsuariosModel _usuTemp = new RegistroUsuariosModel();
      final String documento = snapshot['documento'].toString();
      final String password = snapshot['password'].toString();
      final String nombres = snapshot['nombres'].toString();
      final String apellidos = snapshot['apellidos'].toString();
      final String email = snapshot['email'].toString();
      final String fechaNacimiento = snapshot['fechaNacimiento'].toString();
      final String fechaUltimaSincro = snapshot['fechaUltimaSincro'].toString();

      _usuTemp.documento = int.parse(documento);
      _usuTemp.password = int.parse(password);
      _usuTemp.nombres = nombres;
      _usuTemp.apellidos = apellidos;
      _usuTemp.email = email;
      _usuTemp.fechaNacimiento = fechaNacimiento;
      _usuTemp.fechaUltimaSincro = fechaUltimaSincro;
      _usuOper.nuevoUsuario(_usuTemp);
      return true;
    }
    return false;
  }
}
