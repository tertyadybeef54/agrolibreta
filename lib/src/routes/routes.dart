import 'package:agrolibreta_v2/src/pages/ver_modelo_referencia.dart';
import 'package:agrolibreta_v2/src/widgets/barraNavegacion.dart';
import 'package:flutter/material.dart';

import 'package:agrolibreta_v2/src/pages/home_page.dart';
import 'package:agrolibreta_v2/src/pages/perfil_usuario_page.dart';
import 'package:agrolibreta_v2/src/pages/config_cultivo_page.dart';
import 'package:agrolibreta_v2/src/pages/info_cultivo_page.dart';
import 'package:agrolibreta_v2/src/pages/login_page.dart';
import 'package:agrolibreta_v2/src/pages/crear_cultivo_page.dart';
import 'package:agrolibreta_v2/src/pages/resumen_costos_page.dart';
import 'package:agrolibreta_v2/src/pages/crear_costo_page.dart';
import 'package:agrolibreta_v2/src/pages/crear_modelo_referencia_page.dart';
import 'package:agrolibreta_v2/src/pages/select_modelo_referencia_page.dart';
import 'package:agrolibreta_v2/src/pages/costos_page.dart';
import 'package:agrolibreta_v2/src/pages/informe_cultivo_page.dart';
import 'package:agrolibreta_v2/src/pages/utilidades_page.dart';
import 'package:agrolibreta_v2/src/pages/galeria_registros_fotograficos_page.dart';
import 'package:agrolibreta_v2/src/pages/nuevo_registro_fotografico_page.dart';
import 'package:agrolibreta_v2/src/pages/detalle_registro_fotografico_page.dart';
import 'package:agrolibreta_v2/src/pages/restaurar_password.dart';

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
    'selecionarModeloReferencia': (BuildContext context) =>
        SelectModeloReferencia(),
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
  };
}
