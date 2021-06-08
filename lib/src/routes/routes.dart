import 'package:agrolibreta_v2/src/pages/costo_folder/editar_costo_page.dart';
import 'package:agrolibreta_v2/src/pages/galeria_folder/editar_regfot_page.dart';
import 'package:agrolibreta_v2/src/pages/costo_folder/ver_costo_page.dart';
import 'package:flutter/material.dart';

import 'package:agrolibreta_v2/src/pages/home_folder/home_page.dart';
import 'package:agrolibreta_v2/src/pages/home_folder/perfil_usuario_page.dart';
import 'package:agrolibreta_v2/src/pages/home_folder/config_cultivo_page.dart';
import 'package:agrolibreta_v2/src/pages/home_folder/info_cultivo_page.dart';
import 'package:agrolibreta_v2/src/pages/login_page.dart';
import 'package:agrolibreta_v2/src/pages/home_folder/crear_cultivo_page.dart';
import 'package:agrolibreta_v2/src/pages/home_folder/resumen_costos_page.dart';
import 'package:agrolibreta_v2/src/pages/home_folder/crear_costo_page.dart';
import 'package:agrolibreta_v2/src/pages/utilidades_folder/crear_modelo_referencia_page.dart';
import 'package:agrolibreta_v2/src/pages/costo_folder/costos_page.dart';
import 'package:agrolibreta_v2/src/pages/informe_folder/informe_cultivo_page.dart';
import 'package:agrolibreta_v2/src/pages/utilidades_folder/utilidades_page.dart';
import 'package:agrolibreta_v2/src/pages/galeria_folder/galeria_registros_fotograficos_page.dart';
import 'package:agrolibreta_v2/src/pages/galeria_folder/nuevo_registro_fotografico_page.dart';
import 'package:agrolibreta_v2/src/pages/galeria_folder/detalle_registro_fotografico_page.dart';
import 'package:agrolibreta_v2/src/pages/restaurar_password.dart';

import 'package:agrolibreta_v2/src/pages/home_folder/ver_modelo_referencia.dart';
import 'package:agrolibreta_v2/src/widgets/barraNavegacion.dart';
import 'package:agrolibreta_v2/src/pages/registrar_usuario_page.dart';

import 'package:agrolibreta_v2/src/pages/utilidades_folder/modelo_referencia_list.dart';
import 'package:agrolibreta_v2/src/pages/utilidades_folder/producto_actividad_list.dart';
import 'package:agrolibreta_v2/src/pages/utilidades_folder/ubicaciones_list.dart';
import 'package:agrolibreta_v2/src/pages/utilidades_folder/unidad_medida_list.dart';


Map<String, WidgetBuilder> getAplicationRoutes() {
  return <String, WidgetBuilder>{
    'taps': (BuildContext context) => TapsPage(),
    'home': (BuildContext context) => HomePage(),
    'perfilUsuario': (BuildContext context) => PerfilUsuarioPage(),
    'configCultivo': (BuildContext context) => ConfigCultivoPage(),
    'infoCultivo': (BuildContext context) => InformacionCultivo(),
    'login': (BuildContext context) => LoginPage(),
    'crearCultivo': (BuildContext context) => CrearCultivoPage(),
    'resumenCostos': (BuildContext context) => ResumencostosPage(),
    'crearCosto': (BuildContext context) => CrearCostoPage(),
    'crearModeloReferencia': (BuildContext context) => CrearModeloReferencia(),
    'costos': (BuildContext context) => CostosPage(),
    'informe': (BuildContext context) => InformeCultivoPage(),
    'utilidades': (BuildContext context) => UtilidadesPage(),
    'galeriaRegistrosFoto': (BuildContext context) =>
        GaleriaRegistrosFotograficosPage(),
    'nuevoRegistroFoto': (BuildContext context) =>
        NuevoRegistroFotograficoPage(),
    'detalleRegistroFoto': (BuildContext context) =>
        DetalleRegistroFotograficoPage(),
    'restaurarPassword': (BuildContext context) => RestaurarPassword(),
    'verModelo': (BuildContext context) => VerModeloReferencia(),
    'registrarUsuario' : (BuildContext context) => RegistrarUsuario(),
    'modeloUtil': (BuildContext context) => ModeloReferenciaList(),
    'productoUtil':(BuildContext context) => ProductoActividadList(),
    'ubicacionUtil':(BuildContext context) => UbicacionList(),
    'unidadMedidaUtil': (BuildContext context) => UnidadMedidaList(),
    'editarRegistro': (BuildContext context) => EditarRegFotPage(),
    'verCosto': (BuildContext context) => VerCostoPage(),
    'EditarCosto': (BuildContext context) => EditarCostoPage(),
    
  };
}
