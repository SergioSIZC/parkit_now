import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:parkit_now/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class WebLogin extends StatefulWidget {
  const WebLogin({super.key});

  @override
  State<WebLogin> createState() => _WebLoginState();
}

class _WebLoginState extends State<WebLogin> {
  TextEditingController _correoController = new TextEditingController();
  TextEditingController _contrasenaController = new TextEditingController();
  
  

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
     
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bgWeb.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              
              margin: EdgeInsets.symmetric(vertical: screenWidth*0.1),
              child: Column(
                children: [
                  Container(
                    height: screenHeight*0.5,
                    width: screenWidth*0.252,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 10,
                        color: AppColors.primary
                      ),
                      borderRadius: BorderRadius.circular(25)
                    ),
                    child: Image(
                      image: AssetImage('assets/images/estacionamiento.png'),
                      height: screenHeight*0.5,
                      width: screenWidth*0.5,
                      color: AppColors.primary,
                    ),
                  ),
                  Text('Bienvenido a Park-iT Now', style: TextStyle(
                    color: AppColors.primary,
                    decoration: TextDecoration.none,
                  ),),
                ],
              ),
            )
            ),
          Expanded(
            child: Container(
              height: screenHeight * 0.8,
              width: screenWidth * 0.5,
              margin: EdgeInsets.symmetric(horizontal: 20),
              
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: screenHeight*0.17, horizontal: screenWidth*0.064),
                    decoration: BoxDecoration(
                      
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.transparent.withOpacity(0.2),
                    ),
                    child: StreamBuilder<User?>(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, snapshot) {
                        return Column(
                          children: [
                            Text('Iniciar Sesión', style: TextStyle(
                              color: AppColors.primary,
                              decoration: TextDecoration.none,
                            ),),
                            Card(
                              elevation: 0.0,
                              color: Colors.transparent,
                              child: Container(
                                margin: EdgeInsets.only(top: screenHeight*0.05),
                                decoration: BoxDecoration(color: Colors.transparent),
                                child: Row(children: [
                                  Text("Correo: ", style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: AppColors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      )),
                                  SizedBox(
                                    width: screenWidth*0.039,
                                  ),
                                  Container(
                                    width: screenWidth*0.25,
                                    height: screenHeight*0.1,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: textInput("example@example.com",_correoController, 2.0, false,false)),
                                  )
                                ]),
                              ),
                            ),
                            Card(
                              elevation: 0.0,
                              color: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(color: Colors.transparent),
                                child: Row(children: [
                                  Text("Contraseña: ", style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: AppColors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      )),
                                  SizedBox(
                                    width: screenWidth*0.008,
                                  ),
                                  Container(
                                    width: screenWidth*0.25,
                                    height: screenHeight*0.1,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: textInput("Contraseña",_contrasenaController, 2.0, false,true)),
                                  )
                                ]),
                              ),
                            ),
                            Container(
                              width: screenWidth*0.35,
                              height: screenHeight*0.05,
                              child: ElevatedButton(
                                onPressed: (){
                                  signIn();
                                  print('correo: ${_correoController.text} Contraseña: ${_contrasenaController.text}');
                              }, 
                              child: Text('Iniciar Sesión', style: TextStyle(color: AppColors.white),),
                                style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  elevation: 1,
                                  backgroundColor: AppColors.primary,       
                                ),
                                                        ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('¿Olvidó su contraseña?',style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: AppColors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      )),
                                TextButton(
                                  child: Text('Recuperar', style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: AppColors.primary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      )),
                                  onPressed: () {},
                                )
                              ],
                            ),
                          ],
                        );
                      }
                    ),
                  ),
                ),
              ),
            )
          ),
        ],
      ),
    );
  }
  Future signIn() async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _correoController.text.trim(),
        password: _contrasenaController.text.trim(),
      );
    
      // El usuario ha iniciado sesión correctamente.
      print('Inicio de sesión exitoso: ${userCredential.user?.uid}');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', userCredential.user!.uid);

      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('usuarios').doc(userCredential.user!.uid).get();
      var rol;
      if (userDoc.exists) {
        // Obtener datos del documento
        final userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          rol= userData['rol'].id;
          print('Rol : ${rol}');
        });
      }
      if(rol=='g4f0G7V4E9fxmKQuvjBe'){
        Navigator.pushNamed(context, 'registrar-est', arguments: {'uid': userCredential.user?.uid});
      }else{
        Navigator.pushNamed(context, 'web-home', arguments: {'uid': userCredential.user?.uid});
      }
    } catch (e) {
      // Se ha producido un error durante el inicio de sesión.
      print('Error en el inicio de sesión: $e');
    }
  }
  Widget textInput(String texto, TextEditingController controller,
      double vAlignment, bool setEditable, bool isPass ) {
    return TextField(
      readOnly: setEditable,
      controller: controller,
      obscureText: isPass,
      enableSuggestions: true,
      autocorrect: false,
      cursorColor: Colors.grey[600],
      style: TextStyle(color: AppColors.primary),
      decoration: InputDecoration(
        contentPadding:
            EdgeInsets.symmetric(vertical: vAlignment, horizontal: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.horizontal(
              right: Radius.circular(25.0), left: Radius.circular(25.0)),
        ),
        hintText: texto,
        hintStyle: TextStyle(
          fontSize: 20,
        ),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white.withOpacity(0.9),
        alignLabelWithHint: true,
      ),
      keyboardType: TextInputType.text,
    );
  }
}
