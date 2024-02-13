import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkit_now/utils/colors.dart';
import 'package:parkit_now/utils/drawer_header.dart';


class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.primary,
      child: SingleChildScrollView(
        child: Container(
          
          child: Column(
            children: [
              MyDrawerHeader(),
              MyDrawerList(),
            ],
          ),
        ),
      ),
        
    );
  }
  Widget MyDrawerList(){
  var currentPage = DrawerSections.perfil;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
  return Container(
    color: AppColors.primary,
    padding: EdgeInsets.only(top: 15),
    child: Column(
      children: [
        menuItem(1, 'Perfil', Icons.person,
          currentPage == DrawerSections.perfil ? true : false, 'perfil'
        ),
        menuItem(2, 'Mis Autos', Icons.drive_eta,
          currentPage == DrawerSections.misautos ? true : false, 'autos'
        ),
        menuItem(3, 'Ayuda y Soporte', Icons.help,
          currentPage == DrawerSections.ayudaysoporte ? true : false, 'ayuda'
        ),
        
        menuItem(4, 'Configuración', Icons.settings,
          currentPage == DrawerSections.configuracion ? true : false, 'mobile-home'
        ),
        SizedBox(height: screenHeight*0.2,),
        menuItem(
              5,
              'Cerrar Sesión',
              Icons.logout_rounded,
              currentPage == DrawerSections.configuracion ? true : false,
              'login-register'),
      ],
    ),
  );
}
Widget MyWebDrawerList(){
  var currentPage = DrawerSections.perfil;
  return Container(
    
    
    padding: EdgeInsets.only(top: 15),
    child: Column(
      
      children: [
        menuItem(1, 'Home', Icons.home_outlined,
          currentPage == DrawerSections.home ? true : false, 'listado-reserva-vehiculo'
        ),
        menuItem(2, 'Mi Cuenta', Icons.person_outline,
          currentPage == DrawerSections.micuenta ? true : false, 'listado-reserva-vehiculo'
        ),
        menuItem(3, 'Estacionamiento', Icons.near_me_outlined,
          currentPage == DrawerSections.estacionamiento ? true : false, 'listado-reserva-vehiculo'
        ),
        menuItem(4, 'Ajustes', Icons.settings_outlined,
          currentPage == DrawerSections.configuracion ? true : false, 'listado-reserva-vehiculo'
        ),
        SizedBox(height: 250,),
        menuItem(5, 'Cerrar Sesión', Icons.logout_rounded,
          currentPage == DrawerSections.configuracion ? true : false, 'listado-reserva-vehiculo'
        ),
      ],
    ),
  );
}
  Widget menuItem(int id, String title, IconData icon, bool selected, String routeName){
    bool inicio = true;
  return Material(
    color: Colors.transparent,
    child: InkWell(   
      
      onTap: () {
          if (title == 'Cerrar Sesión') {
            signOut();
          } else {
            Navigator.pushNamed(context, routeName, arguments: inicio);
            setState(() {
              
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
    bool inicio = true;
    try {
      await FirebaseAuth.instance.signOut().then((value) => {
            print('Sesión cerrada con exito'),
            Navigator.pushNamed(context, 'login-register', arguments: inicio)
          });
    } catch (e) {
      // Se ha producido un error durante el inicio de sesión.
      print('Error al cerrar sesión: $e');
    }
  }
}






enum DrawerSections{
  perfil,
  misautos,
  ayudaysoporte,
  configuracion,
  home,
  micuenta,
  estacionamiento,  
  cerrar
}