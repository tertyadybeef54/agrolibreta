
import 'package:flutter/material.dart';


//import 'package:agrolibreta_v2/src/pages/info_cultivo_page.dart';
import 'package:agrolibreta_v2/src/pages/config_cultivo_page.dart';
//import 'package:agrolibreta_v2/src/pages/perfil_usuario_page.dart';
//import 'package:agrolibreta_v2/src/pages/home_page.dart';
import 'package:agrolibreta_v2/src/routes/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      initialRoute: 'detalleRegistroFoto',
      routes: getAplicationRoutes(),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (BuildContext context) => ConfigCultivoPage(),
        );
      },
    );
  }
}
