import 'package:agrolibreta_v2/src/dataproviders/pie_data_provider.dart';
import 'package:agrolibreta_v2/src/dataproviders/usuario_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrolibreta_v2/src/dataproviders/costos_data_provider.dart';
import 'package:agrolibreta_v2/src/dataproviders/porcentajes_data_provider.dart';
import 'package:agrolibreta_v2/src/dataproviders/registro_fotograficos_data.dart';
import 'package:agrolibreta_v2/src/dataproviders/modelo_referencia_provider.dart';
import 'package:agrolibreta_v2/src/dataproviders/filtros_costos_data_provider.dart';

import 'package:agrolibreta_v2/src/pages/home_folder/home_page.dart';
import 'package:agrolibreta_v2/src/pages/costo_folder/costos_page.dart';
import 'package:agrolibreta_v2/src/pages/utilidades_folder/utilidades_page.dart';
import 'package:agrolibreta_v2/src/pages/informe_folder/informe_cultivo_page.dart';
import 'package:agrolibreta_v2/src/pages/galeria_folder/galeria_registros_fotograficos_page.dart';

class TapsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => new _NavegacionModel(),
      child: Scaffold(
        body: _Paginas(),
        bottomNavigationBar: _Navegacion(),
      ),
    );
  }
}

class _Navegacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navegacionModel = Provider.of<_NavegacionModel>(context);
    return BottomNavigationBar(
        selectedItemColor: Color(0xff1b5e20),
        type: BottomNavigationBarType.fixed,
        iconSize: 25,
        currentIndex: navegacionModel.paginaActual,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.dns), label: 'Utilidades'),
          BottomNavigationBarItem(
              icon: Icon(Icons.collections), label: 'Galeria'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'costos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.content_paste_rounded), label: 'Informes'),
        ],
        selectedLabelStyle: TextStyle(color: Color(0xff1b5e20)),
        onTap: (index) => navegacionModel.paginaActual = index);
  }
}

class _Paginas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navegacionModel = Provider.of<_NavegacionModel>(context);
    //Provider.of<CultivosData>(context, listen: false);
    Provider.of<PorcentajeData>(context, listen: false);
    Provider.of<CostosData>(context, listen: false);
    Provider.of<RegistrosFotograficosData>(context, listen: false);
    Provider.of<FiltrosCostosData>(context, listen: false);
    Provider.of<PieData>(context, listen: false);
    Provider.of<UsuarioProvider>(context, listen: false);
    Provider.of<ModeloReferenciaData>(context, listen: false);
    return PageView(
      controller: navegacionModel.pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        HomePage(),
        UtilidadesPage(),
        GaleriaRegistrosFotograficosPage(),
        CostosPage(),
        InformeCultivoPage(),
      ],
    );
  }
}

//provider que cambia el valor del index del botton navigator bar
class _NavegacionModel with ChangeNotifier {
  int _paginaActual = 0;
  PageController _pageController = new PageController();

  int get paginaActual => this._paginaActual;
  set paginaActual(int valor) {
    this._paginaActual = valor;
    notifyListeners();
    _pageController.animateToPage(valor,
        duration: Duration(milliseconds: 700), curve: Curves.easeInOutCirc);
  }

  PageController get pageController => _pageController;
}
