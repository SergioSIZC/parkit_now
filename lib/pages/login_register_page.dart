import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:parkit_now/pages/home_mobile.dart';
import 'package:parkit_now/utils/colors.dart';
import 'package:parkit_now/widgets/reusable_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRegisterPage extends StatefulWidget {
  final bool show;
  LoginRegisterPage({required this.show});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  String _nombre = '';
  String _email = '';
  String _fecha = '';
  Color _ingresar = AppColors.primary;
  Color _nuevaCuenta = Colors.grey.shade300;
  bool showInputs = false;
  TextEditingController _passwordLController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _emailLController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _nombreController = new TextEditingController();
  TextEditingController _apellidoController = new TextEditingController();
  List<DocumentReference> docsIDs = [];
  Future fetchData() async {
    await FirebaseFirestore.instance
        .collection('rol')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              setState(() {
                docsIDs.add(document.reference);
                print(document.reference.id);
              });
            }));
  }

  @override
  void initState() {
    fetchData();
    setState(() {
      super.initState();

      // Asignar el valor de widget.myBool a myLocalBool en initState.
      showInputs = widget.show;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.grey.shade200,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image(
                image: AssetImage('assets/images/estacionamientos2.jpg'),
              ),
            ),
            Positioned(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 90,
                    ),
                    Icon(
                      Icons.local_parking,
                      color: Colors.black,
                      size: 200,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                          color: Colors.white,
                          height: screenHeight * 0.6,
                          width: 390,
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: 30,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 60.0,
                                          width: screenWidth * 0.9,
                                          child: AnimatedButtonBar(
                                              radius: 50.0,
                                              invertedSelection: true,
                                              elevation: 5,
                                              foregroundColor:
                                                  AppColors.primary,
                                              backgroundColor:
                                                  Colors.grey.shade100,
                                              children: [
                                                ButtonBarEntry(
                                                    child: Text('Ingresar'),
                                                    onTap: () {
                                                      setState(() {
                                                        showInputs = true;
                                                      });
                                                    }),
                                                ButtonBarEntry(
                                                    child: Text('Nueva Cuenta'),
                                                    onTap: () {
                                                      setState(() {
                                                        showInputs = false;
                                                      });
                                                    })
                                              ]),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: showInputs
                                        ? _crearLogin(
                                            context, screenHeight, screenWidth)
                                        : _crearRegister(
                                            screenHeight, screenWidth),
                                  )
                                ],
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future signIn(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailLController.text.trim(),
        password: _passwordLController.text.trim(),
      );

      // El usuario ha iniciado sesión correctamente.
      print('Inicio de sesión exitoso: ${userCredential.user?.uid}');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userIdM', userCredential.user!.uid);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MobileHome()),
      );
    } catch (e) {
      // Se ha producido un error durante el inicio de sesión.
      print('Error en el inicio de sesión: $e');
    }
  }

  Future register() async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());
      String? userId = credential.user?.uid;
      await FirebaseFirestore.instance.collection('usuarios').doc(userId).set({
        'nombre': _nombreController.text.trim(),
        'apellido': _apellidoController.text.trim(),
        'correo': _emailController.text.trim(),
        'rol': docsIDs[0],
      });
    } catch (e) {
      print('Error al registrar: $e');
    }
  }

  Widget _crearLogin(BuildContext context, double height, double width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Bienvenido a Park-iT Now',
          style: TextStyle(
            fontSize: 25,
            color: AppColors.primary,
          ),
        ),
        SizedBox(
          height: height * 0.06,
        ),
        SizedBox(
            width: width*0.9,
            height: height * 0.06,
            child: reusableTextField(
                'Correo', Icons.email, false, _emailLController)),
        SizedBox(
          height: 15.0,
        ),
        SizedBox(
            width: width*0.9,
            height: height * 0.06,
            child: reusableTextField(
                'Contraseña', Icons.lock, true, _passwordLController)),
        SizedBox(
          height: 15.0,
        ),
        SizedBox(
          height: height*0.07,
          width: width*0.9,
          child: ElevatedButton(
            child: Text('Iniciar'),
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              backgroundColor: AppColors.primary,
            ),
            onPressed: () {
              signIn(context);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('¿Olvidó su contraseña?'),
            TextButton(
              child: Text('Recuperar'),
              onPressed: () {},
            )
          ],
        )
      ],
    );
  }

  Widget _crearRegister(double height, double width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Bienvenido a Park-iT Now',
          style: TextStyle(
            fontSize: 25,
            color: AppColors.primary,
          ),
        ),
        SizedBox(
          height: height*0.015,
        ),
        SizedBox(
            width: width*0.9,
            height: height * 0.06,
            child: reusableTextField(
                'Nombre', Icons.person, false, _nombreController)),
        SizedBox(
          height: 10.0,
        ),
        SizedBox(
          width: width*0.9,
          height: height * 0.06,
          child: reusableTextField(
              'Apellido', Icons.text_fields, false, _apellidoController),
        ),
        SizedBox(
          height: 10.0,
        ),
        SizedBox(
            width: width*0.9,
            height: height * 0.06,
            child: reusableTextField(
                'Correo', Icons.email, false, _emailController)),
        SizedBox(
          height: 10.0,
        ),
        SizedBox(
            width: width*0.9,
            height: height * 0.06,
            child: reusableTextField(
                'Contraseña', Icons.lock, true, _passwordController)),
        SizedBox(
          height: 10.0,
        ),
        SizedBox(
          height: height*0.07,
          width: width*0.9,
          child: ElevatedButton(
            child: Text('Registrarse'),
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              backgroundColor: AppColors.primary,
            ),
            onPressed: () {
              register();
              print('Registrado');
            },
          ),
        ),
      ],
    );
  }
}
