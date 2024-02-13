import 'package:flutter/material.dart';
import 'package:parkit_now/pages/login_register_page.dart';
import 'package:parkit_now/utils/colors.dart';
class NoSesionHomePage extends StatelessWidget {
  bool register = false;
  bool inicio = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
           Container(
                      height: screenHeight * 0.20,
                      width: screenWidth * 0.44,
                      margin: EdgeInsets.only(top: screenHeight * 0.08),
                      padding: EdgeInsets.all(screenHeight*0.005),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(width: 4, color: AppColors.primary),
                          borderRadius: BorderRadius.circular(25)),
                      child: Image(
                        image: AssetImage('assets/images/estacionamiento.png'),
                        height: screenHeight * 0.5,
                        width: screenWidth * 0.5,
                        color: AppColors.primary,
                      ),
                    ),
           SizedBox(height: screenHeight*0.5,),
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
                Navigator.pushReplacementNamed(context, 'login-register', arguments: inicio);
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