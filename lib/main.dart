import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:agrolibreta_v2/src/blocs/provider.dart';
import 'package:agrolibreta_v2/src/preferencias_usuario/preferencias_usuario.dart';

import 'package:agrolibreta_v2/src/routes/routes.dart';
import 'package:agrolibreta_v2/src/pages/home_page.dart';
import 'src/dataproviders/cultivos_data.dart';
import 'package:agrolibreta_v2/src/dataproviders/ubicaciones_data.dart';
import 'package:agrolibreta_v2/src/dataproviders/costos_data_provider.dart';
import 'package:agrolibreta_v2/src/dataproviders/porcentajes_data_provider.dart';
import 'package:agrolibreta_v2/src/dataproviders/modelo_referencia_provider.dart';
import 'package:agrolibreta_v2/src/dataproviders/unidades_medida_data_provider.dart';
import 'package:agrolibreta_v2/src/dataproviders/productos_actividades_data_provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

   
   final prefs = new PreferenciasUsuario();
   print(prefs.token);
   
    return Provider(
      child: MaterialApp(

        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''), // English, no country code
          const Locale('es', 'ES'), // *See Advanced Locales below*
        ],
        title: 'AgroLibreta',
        initialRoute: 'taps',
        routes: getAplicationRoutes(),
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) => HomePage(),
          );
        },
      ),
    );  
  }
}
