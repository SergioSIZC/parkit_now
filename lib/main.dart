import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:parkit_now/pages/mis_autos.dart';
import 'package:parkit_now/pages/pago.dart';
import 'package:parkit_now/utils/globals.dart' as globals;

import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:parkit_now/firebase_options.dart';
import 'package:parkit_now/pages/editar_estacionamiento.dart';
import 'package:parkit_now/pages/editar_servicios.dart';
import 'package:parkit_now/pages/entrada_salida.dart';
import 'package:parkit_now/pages/home_mobile.dart';
import 'package:parkit_now/pages/listado-resevas-vehiculo.dart';

import 'package:parkit_now/pages/login_register_page.dart';
import 'package:parkit_now/pages/mi_estacionamiento.dart';
import 'package:parkit_now/pages/mi_perfil.dart';
import 'package:parkit_now/pages/no_sesion_home_page.dart';
import 'package:parkit_now/pages/registrar_estacionamiento.dart';
import 'package:parkit_now/pages/report.dart';
import 'package:parkit_now/pages/web_home.dart';
import 'package:parkit_now/pages/web_login.dart';
import 'package:parkit_now/widgets/google_map.dart';


import 'utils/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
     );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance.collection('alertas').snapshots();
    

    final isWeb = identical(0,0.0);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Park-it Now',
      initialRoute: isWeb
          ? 'web-login'
          : 'no-session',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        brightness: Brightness.light,
        fontFamily: 'Inter',
      ),
      onGenerateRoute: (settings) {
        if (settings.name == 'login-register') {
          return MaterialPageRoute(
            builder: (context) {
              return LoginRegisterPage(
                show: settings.arguments as bool, // Asegúrate de que los argumentos se pasen correctamente aquí.
              );
            },
          );
        }
      },
      routes: {
        'web-home'    : (BuildContext context) => WebHome(),
        'no-session'  : (BuildContext context) => NoSesionHomePage(),
        'mobile-home' : (BuildContext context) => MobileHome(),
        'listado-reserva-vehiculo' : (BuildContext context) => ListadoReservaVehiculo(),
        'report'      : (BuildContext context) => Report(),
        'entrada-salida': (BuildContext context) => EntradaSalida(),
        'mi-est': (BuildContext context) => MiEstacionamiento(),
        'edit-est': (BuildContext context) => EditarEstacionamiento(),
        'edit-serv': (BuildContext context) => EditarServicios(),
        'registrar-est':(BuildContext context) => RegistroEst(),
        'web-login':(BuildContext context) => WebLogin(),
        'mapa': (BuildContext context) => MapScreen(),
        'perfil': (BuildContext context) => MiPerfil(),
        'pago': (BuildContext context) => PagoPage(),
        'autos': (BuildContext context) =>MisAutos(),
      }
    );
    
  }

}