
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:agrolibreta_v2/src/routes/routes.dart';
import 'package:agrolibreta_v2/src/pages/home_folder/home_page.dart';

import 'package:agrolibreta_v2/src/preferencias_usuario/preferencias_usuario.dart';

import 'package:agrolibreta_v2/src/dataproviders/cultivo_data.dart';
import 'package:agrolibreta_v2/src/dataproviders/ubicaciones_data.dart';
import 'package:agrolibreta_v2/src/dataproviders/pie_data_provider.dart';
import 'package:agrolibreta_v2/src/dataproviders/costos_data_provider.dart';
import 'package:agrolibreta_v2/src/dataproviders/usuario_data_provider.dart';
import 'package:agrolibreta_v2/src/dataproviders/porcentajes_data_provider.dart';
import 'package:agrolibreta_v2/src/dataproviders/registro_fotografico_data.dart';
import 'package:agrolibreta_v2/src/dataproviders/modelo_referencia_provider.dart';
import 'package:agrolibreta_v2/src/dataproviders/filtros_costos_data_provider.dart';
import 'package:agrolibreta_v2/src/dataproviders/unidades_medida_data_provider.dart';
import 'package:agrolibreta_v2/src/dataproviders/productos_actividades_data_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}
//Este es el widget raiz de la aplicación
class MyApp extends StatelessWidget {
  
  final prefs = new PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => new CultivoData()),
          ChangeNotifierProvider(create: (context) => new ModeloReferenciaData()),
          ChangeNotifierProvider(create: (context) => new PorcentajeData()),
          ChangeNotifierProvider(create: (context) => new UbicacionesData()),
          ChangeNotifierProvider(create: (context) => new UnidadesMedidaData()),
          ChangeNotifierProvider(create: (context) => new ProductoActividadData()),
          ChangeNotifierProvider(create: (context) => new CostosData()),
          ChangeNotifierProvider(create: (context) => new UsuarioProvider()),
          ChangeNotifierProvider(create: (context) => new RegistrosFotograficosData()),
          ChangeNotifierProvider(create: (context) => new FiltrosCostosData() ),
          ChangeNotifierProvider(create: (context) => new PieData() ),
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
          initialRoute: prefs.ultimaPagina,
          routes: getAplicationRoutes(),
          onGenerateRoute: (RouteSettings settings) {
            return MaterialPageRoute(
              builder: (BuildContext context) => HomePage
              (),
            );
          },
          theme:ThemeData(
            primaryColor: Color(0xff9ccc65),
            primaryColorLight: Color(0xffcfff95),
            primaryColorDark: Color(0xff6b9b37),
            accentColor: Color(0xff8c6d62),
            iconTheme: IconThemeData(color:Color(0xff1b5e20)),
            textButtonTheme: TextButtonThemeData(style:ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Color(0xff1b5e20)))),
            elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(0xff8c6d62)))),
            timePickerTheme: TimePickerThemeData(backgroundColor:Colors.orange),
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
              textTheme: TextTheme(headline6: TextStyle(
                color: Colors.white,
                fontSize: 20.0, 
                fontWeight: FontWeight.bold
              )),
            )
          )
        )
    );
  }
}
