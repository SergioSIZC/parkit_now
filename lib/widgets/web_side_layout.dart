import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkit_now/utils/colors.dart';
import 'package:parkit_now/utils/drawer_header.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideLayout extends StatefulWidget {
  SideLayout({super.key});
  static int currentOption = 1;
  @override
  State<SideLayout> createState() => _SideLayoutState();
}

class _SideLayoutState extends State<SideLayout> {
  String? uid;
  String? rol;
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    getUID();
    super.initState();
  }
  Future getUID() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('userId');
    print(action);
    uid = action;
    print('UID: ${uid}');
    await getUserInfo();
  }
  Future<void> getUserInfo() async {
    if (uid != null) {
      // Acceder a la colección "usuarios" en Firestore
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
      
      if (userDoc.exists) {
        // Obtener datos del documento
        final userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          rol= userData['rol'].id;
          print('Rol : ${rol}');
          loading = false;
        });
      }
    }else{  
      print('Es Nullll');
      loading = false;
    }
    
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Drawer(
      backgroundColor: AppColors.primary,
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 50),
              Container(
                  width: screenWidth * 0.12,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)),
                  child: Image(
                    image: AssetImage('assets/images/estacionamiento.png'),
                    width: 140,
                  )),
              SizedBox(height: screenHeight*0.02),
              loading? Container(
                child: CircularProgressIndicator(),
                margin: EdgeInsets.symmetric(horizontal: 100),
                )
              :MyWebDrawerList(screenHeight, screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget MyWebDrawerList(double height, double width) {
    var currentPage = DrawerSections.perfil;
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: rol=='g4f0G7V4E9fxmKQuvjBe'?
      Column(
        children: [
           if (rol != null)
          menuItem(
              1,
              'Registrar Estacionamiento',
              Icons.person_outline,
              currentPage == DrawerSections.micuenta ? true : false,
              'registrar-est'),
         
          SizedBox(
            height: height * 0.4,
          ),
          menuItem(
              5,
              'Cerrar Sesión',
              Icons.logout_rounded,
              currentPage == DrawerSections.configuracion ? true : false,
              'listado-reserva-vehiculo'),
        ],
      )
      :Column(
        children: [
          menuItem(1, 'Home', Icons.home_outlined,
              currentPage == DrawerSections.home ? true : false, 'web-home'),
           if (rol != null)
          menuItem(
              2,
              'Mi Cuenta',
              Icons.person_outline,
              currentPage == DrawerSections.micuenta ? true : false,
              'mi-cuenta'),
          menuItem(
              3,
              'Estacionamiento',
              Icons.near_me_outlined,
              currentPage == DrawerSections.estacionamiento ? true : false,
              'mi-est'),
          
          SizedBox(
            height: height * 0.2,
          ),
          menuItem(
              4,
              'Cerrar Sesión',
              Icons.logout_rounded,
              currentPage == DrawerSections.configuracion ? true : false,
              'listado-reserva-vehiculo'),
        ],
      ),
    );
  }

  Widget menuItem(
      int id, String title, IconData icon, bool selected, String routeName) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (title == 'Cerrar Sesión') {
            signOut();
          } else {
            Navigator.pushNamed(context, routeName);
            setState(() {
              SideLayout.currentOption = id;
            });
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    backgroundColor: Colors.transparent,
                    fontSize: 18,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future signOut() async {
    try {
      await FirebaseAuth.instance.signOut().then((value) => {
            print('Sesión cerrada con exito'),
            Navigator.pushNamed(context, 'web-login')
          });
    } catch (e) {
      // Se ha producido un error durante el inicio de sesión.
      print('Error al cerrar sesión: $e');
    }
  }
}

enum DrawerSections {
  perfil,
  misautos,
  ayudaysoporte,
  configuracion,
  home,
  micuenta,
  estacionamiento,
  cerrar
}
