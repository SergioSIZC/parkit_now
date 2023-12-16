import 'package:flutter/material.dart';
import 'package:parkit_now/pages/login_register_page.dart';
import 'package:parkit_now/utils/colors.dart';
class NoSesionHomePage extends StatelessWidget {
  bool register = false;
  bool inicio = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      resizeToAvoidBottomInset: false,    
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/estacionamientos.jpg'),
            fit: BoxFit.cover,
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           SizedBox(height: 40.0,),
           Icon(
            Icons.local_parking, 
            size: 200, 
            color:Colors.black
           ),
           SizedBox(height: 400.0,),
           _crearBoton(context),
            
          ],
        ),
      ),
    );
  }
  
  Widget _crearBoton(BuildContext context) {
    return Column(
      children: [
        Container(
          
          child: SizedBox(
            height: 50.0,
            width: 300.0,
            child: ElevatedButton(
              onPressed: (){
                Navigator.pushReplacementNamed(context, 'mobile-home', arguments: inicio);
              }, 
              child: Text('Iniciar Sesión', style: TextStyle(color: AppColors.white),),
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                elevation: 1,
                backgroundColor: Colors.blue.shade900,       
              ),
              
            ),
          ),
        ),
        Row(
            children: [
              Expanded(child: Container(),),
              Text('¿No tienes cuenta?', style: TextStyle(color: Colors.white)),
              TextButton(
                child: Text('Crear'),
                onPressed: (){
                  
                  Navigator.pushNamed(context, 'login-register', arguments: register);
                }, 
              ),
              Expanded(child: Container(),),
            ],
          ),

      ],
    );
  }
}