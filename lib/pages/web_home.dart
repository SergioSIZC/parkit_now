import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parkit_now/data/get_estacionamiento_data.dart';

import 'package:parkit_now/widgets/web_side_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebHome extends StatefulWidget {
  WebHome({super.key});

  @override
  State<WebHome> createState() => _WebHomeState();
}

class _WebHomeState extends State<WebHome> {
  Color buttonColor1 = Colors.white;
  Color buttonColor2 = Colors.white;
  String? uid;
  List<String> docsIDs = [];


  Future getUID() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('userId');
    print(action);
    uid = action;
    print('UID: ${uid}');
  }

  void initState(){
    getUID();
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
  final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return Row(children: [
      Flexible(flex: 2, child: SideLayout()),
      Spacer(),
      Expanded(
          flex: 8,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_parking,
                      size: 90,
                    ),
                    Text(
                      'Park-iT Now ',
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Text('Bienvenido Juan',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontSize: 30,
                            )),
                        Text('Revisa la última información de hoy',
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Colors.grey,
                                fontSize: 15))
                      ],
                    ),
                    Expanded(flex: 2, child: Container()),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text('Juan Pérez',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black,
                                    fontSize: 20)),
                            Text('Encargado',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.grey,
                                    fontSize: 15))
                          ],
                        ),
                        Image(
                          image: AssetImage('assets/images/user.png'),
                          width: 50,
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(border: Border.all()),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      Column(
                        children: [
                          Text('Reservas',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.grey,
                                  fontSize: 15)),
                          FutureBuilder(
                            future: Future.value(uid),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }else{
                                return GetEstData(documentId: uid.toString(), campo: 'cant_reservas',);
                              }
                              
                            },
                             
                          )
                        ],
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                            decoration: BoxDecoration(border: Border.all()),
                          width: 1.0,
                          height: 50,
                          ),
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Column(
                        children: [
                          Text('Vehículos ingresados',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.grey,
                                  fontSize: 15)),
                          Text('68',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.black,
                                  fontSize: 40))
                        ],
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                            decoration: BoxDecoration(border: Border.all()),
                          width: 1.0,
                          height: 50,
                          ),
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Column(
                        children: [
                          Text('Plazas disponibles',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.grey,
                                  fontSize: 15)),
                          FutureBuilder(
                            future: Future.value(uid),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }else{
                                return GetEstData(documentId: uid.toString(), campo: 'cupos_disponibles',);
                              }
                              
                            },
                             
                          )
                        ],
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    Expanded(child: Container()),
                    HoverableWidget(
                        Icons.edit_calendar,
                        'Registro de vehículos y Reservas',
                        buttonColor1,
                        'listado-reserva-vehiculo',
                      ),
                    
                    Expanded(
                      child: Container(),
                    ),
                     HoverableWidget(Icons.emoji_transportation,
                            'Registrar entrada y salida', buttonColor2, 'entrada-salida'),
                    Expanded(child: Container()),
                  ],
                ),
              ],
            ),
          )),
      Spacer(),
    ]);
  }

  Widget HoverableWidget(
      IconData icono, String texto, Color color, String navigation) {
    
    return Container(
      alignment: Alignment.center,
      width: 400,
      height: 300,
      
      decoration: BoxDecoration(
        border: Border.all(), // Establecer el color del borde aquí
        borderRadius: BorderRadius.circular(5.0), // Ajusta según tus preferencias
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey[600],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
        ),
        onPressed: (){
          Navigator.pushNamed(context, navigation);
        },
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, size: 200, color: Colors.black), // Muestra el icono
            Center(
                child: Text(texto,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontSize: 30))), // Muestra el texto
          ],
          
        ),
      ),
    );
  }
}
