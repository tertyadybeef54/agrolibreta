import 'package:agrolibreta_v2/src/dataproviders/modelo_referencia_provider.dart';
import 'package:agrolibreta_v2/src/dataproviders/porcentajes_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:agrolibreta_v2/src/routes/routes.dart';
import 'package:agrolibreta_v2/src/pages/home_page.dart';
import 'package:provider/provider.dart';

import 'src/dataproviders/cultivos_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => new CultivosData() ),
        ChangeNotifierProvider(create: (context) => new ModeloReferenciaData() ),
        ChangeNotifierProvider(create: (context) => new PorcentajeData() ),

      ],

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
