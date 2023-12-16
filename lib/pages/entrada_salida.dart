import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parkit_now/data/get_estacionamiento_data.dart';
import 'package:parkit_now/data/get_rol.dart';
import 'package:parkit_now/data/get_user_data.dart';
import 'package:parkit_now/data/get_auto_data.dart';

import 'package:parkit_now/utils/colors.dart';
import 'package:parkit_now/widgets/dropdownBtn.dart';
import 'package:parkit_now/widgets/web_side_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EntradaSalida extends StatefulWidget {
  const EntradaSalida({super.key});

  @override
  State<EntradaSalida> createState() => _EntradaSalidaState();
}

class _EntradaSalidaState extends State<EntradaSalida> {
  late Stream<DateTime> fecha;
  late Stream<Timestamp> hora;

  List<String> docsIDs = [];
  String? uid;
  late int disp;
  late int total;

  GetAutoData autoData = new GetAutoData();

  TextEditingController _patenteSController = new TextEditingController();
  TextEditingController _colorController = new TextEditingController();
  TextEditingController _marcaController = new TextEditingController();
  TextEditingController _patenteIController = new TextEditingController();
  TextEditingController _horaESController = new TextEditingController();
  TextEditingController _horaEIController = new TextEditingController();
  TextEditingController _horaSSController = new TextEditingController();
  TextEditingController _pagarController = new TextEditingController();

  // Future fetchData() async {
  //   await FirebaseFirestore.instance
  //       .collection('usuarios')
  //       .get()
  //       .then((snapshot) => snapshot.docs.forEach((document) {
  //             setState(() {
  //               docsIDs.add(document.reference.id);
  //               print(document.reference.id);
  //             });
  //           }));
  // }
  Future getUID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('userId');
    print(action);
    uid = action;
    getEstInfo();
  }

  Future<void> getEstInfo() async {
      if (uid != null) {
        // Acceder a la colección "usuarios" en Firestore
        final DocumentSnapshot estDoc =
            await FirebaseFirestore.instance.collection('estacionamientos').doc(uid).get();

        if (estDoc.exists) {
          // Obtener datos del documento
          final estData = estDoc.data() as Map<String, dynamic>;
          disp = estData['cupos_disponibles'];
          total = estData['cupos_totales'];
        }
      }
  }
  @override
  void initState() {
    getUID();
    // fetchData();
    hora = Stream.periodic(Duration(seconds: 1), (_) => Timestamp.now());
    fecha = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());

    super.initState();
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Row(
      children: [
        Flexible(flex: 2, child: SideLayout()),
        Spacer(),
        Expanded(
          flex: 8,
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_parking,
                      size: 90,
                    ),
                    Text(
                      'Park-iT Now',
                      style: TextStyle(
                        color: AppColors.primary,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Expanded(child: Container()),
                    Column(
                      children: [
                        // Text('Juan Pérez',
                        //     style: TextStyle(
                        //         decoration: TextDecoration.none,
                        //         color: AppColors.primary,
                        //         fontSize: 20)),
                        // Text('Encargado',
                        //     style: TextStyle(
                        //         decoration: TextDecoration.none,
                        //         color: Colors.grey,
                        //         fontSize: 15))
                        Column(
                          children: [
                            Material(
                              child: MyDropDownButton(),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text('Registro de vehículos',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          color: AppColors.primary,
                          fontSize: 30,
                        )),
                    Expanded(child: Container()),
                    StreamBuilder<Timestamp>(
                      stream: hora,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text('Cargando hora...',
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: AppColors.primary,
                                fontSize: 30,
                              ));
                        } else {
                          final horaFormateada =
                              DateFormat('HH:mm:ss').format(DateTime.now());
                          return Text(horaFormateada,
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: AppColors.primary,
                                fontSize: 30,
                              ));
                        }
                      },
                    ),
                    Expanded(child: Container()),
                    StreamBuilder<DateTime>(
                      stream: fecha,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text('Cargando fecha...',
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: AppColors.primary,
                                fontSize: 30,
                              ));
                        } else {
                          final fechaFormateada =
                              DateFormat('dd/MM/yyyy').format(DateTime.now());
                          return Text(fechaFormateada,
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: AppColors.primary,
                                fontSize: 30,
                              ));
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
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
                          Text('Plazas Totales',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.grey,
                                  fontSize: 15)),
                          FutureBuilder(
                            future: Future.value(uid),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                return GetEstData(
                                  documentId: uid.toString(),
                                  campo: 'cupos_totales',
                                );
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
                            height: screenHeight * 0.08,
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
                          Text('Plazas Reservadas',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.grey,
                                  fontSize: 15)),
                          FutureBuilder(
                            future: Future.value(uid),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                return GetEstData(
                                  documentId: uid.toString(),
                                  campo: 'cant_reservas',
                                );
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
                            height: screenHeight * 0.08,
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
                          Text('Plazas Ocupadas',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.grey,
                                  fontSize: 15)),
                          FutureBuilder(
                            future: Future.value(uid),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                return GetEstData(
                                  documentId: uid.toString(),
                                  campo: 'cupos_ocupados',
                                );
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
                            height: screenHeight * 0.08,
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
                          Text('Plazas Disponibles',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.grey,
                                  fontSize: 15)),
                          FutureBuilder(
                            future: Future.value(uid),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                return GetEstData(
                                  documentId: uid.toString(),
                                  campo: 'cupos_disponibles',
                                );
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
                  height: 30,
                ),

                Row(
                  children: [
                    Spacer(),
                    Container(
                      width: screenWidth * 0.3,
                      height: screenHeight * 0.47,
                      padding: EdgeInsets.only(left: 15, top: 20),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.grey[200]),
                      child: Column(
                        children: [
                          Text('Registro entrada',
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: AppColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              )),
                          SizedBox(
                            height: 30,
                          ),
                          Card(
                            elevation: 0.0,
                            child: Container(
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
                              child: Row(children: [
                                Text("Patente: ",
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: AppColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    )),
                                SizedBox(
                                  width: screenWidth * 0.047,
                                ),
                                Container(
                                  width: screenWidth * 0.13,
                                  height: screenHeight * 0.05,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: textInput("GW-KG-64",
                                          _patenteIController, 2.0, false)),
                                )
                              ]),
                            ),
                          ),
                          Card(
                            elevation: 0.0,
                            child: Container(
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
                              child: Row(children: [
                                Text("Marca: ",
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: AppColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    )),
                                SizedBox(
                                  width: screenWidth * 0.0566,
                                ),
                                Container(
                                  width: screenWidth * 0.13,
                                  height: screenHeight * 0.05,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: textInput('Ford', _marcaController,
                                          5.0, false)),
                                )
                              ]),
                            ),
                          ),
                          Card(
                            elevation: 0.0,
                            child: Container(
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
                              child: Row(children: [
                                Text("Color: ",
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: AppColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    )),
                                SizedBox(
                                  width: screenWidth * 0.0613,
                                ),
                                Container(
                                  width: screenWidth * 0.13,
                                  height: screenHeight * 0.05,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: textInput('Azul', _colorController,
                                          5.0, false)),
                                )
                              ]),
                            ),
                          ),
                          Card(
                            elevation: 0.0,
                            child: Container(
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
                              child: Row(children: [
                                Text("Hora Entrada: ",
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: AppColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    )),
                                SizedBox(
                                  width: screenWidth * 0.013,
                                ),
                                Container(
                                  width: screenWidth * 0.13,
                                  height: screenHeight * 0.05,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: textInput(DateFormat('HH:mm:ss').format(DateTime.now()),
                                          _horaEIController, 5.0, true)),
                                )
                              ]),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: screenHeight * 0.04),
                            child: Row(
                              children: [
                                Spacer(),
                                Container(
                                  width: 150,
                                  height: 40,
                                  child: ElevatedButton(
                                    child: Text("Ingresar"),
                                    style: ElevatedButton.styleFrom(
                                      shape: StadiumBorder(),
                                      backgroundColor: Colors.green,
                                    ),
                                    onPressed: () async {
                                      if(_colorController.text != '' && _patenteIController.text != '' && _marcaController.text != ''){
                                        if(total==disp){
                                          CollectionReference autosCollection =
                                          FirebaseFirestore.instance
                                              .collection('autos');
                                      
                                          DocumentReference autoReference =
                                            await autosCollection.add({
                                          'patente': _patenteIController.text,
                                          'marca': _marcaController.text,
                                          'color': _colorController.text,
                                          'hora_entrada': FieldValue.serverTimestamp(),

                                          });
                                          
                                          CollectionReference estRef = FirebaseFirestore.instance.collection('estacionamientos');
                                          DocumentSnapshot estDoc = await estRef.doc(uid).get();
                                          int cuposDisponibles = estDoc['cupos_disponibles'];
                                          cuposDisponibles--;
                                          
                                            await estRef.doc(uid).update({
                                            'cupos_disponibles': cuposDisponibles,
                                            'autos': FieldValue.arrayUnion([autoReference]),
                                          }).then((value) {
                                            _mostrarModalConfirmacion(context,"Vehículo ingresado correctamente",Icons.task_alt, Colors.green);
                                          }).catchError((error) {
                                            
                                          });
                                          print(autoReference);
                                          setState(() {
                                            _colorController.text='';
                                            _patenteIController.text='';
                                            _marcaController.text='';
                                          });
                                        }else{
                                          _mostrarModalConfirmacion(context,"Error al añadir el vehículo, cupos llenos", Icons.cancel_outlined, Colors.red);
                                        }
                                      }else{
                                        _mostrarModalConfirmacion(context,"Error al añadir el vehículo, faltan campos por rellenar", Icons.cancel_outlined, Colors.red);
                                      }
                                      
                                      
                                      
                                      // Cerrar el cuadro de diálogo
                                    },
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  width: 150,
                                  height: 40,
                                  child: ElevatedButton(
                                    child: Text("Borrar"),
                                    style: ElevatedButton.styleFrom(
                                      shape: StadiumBorder(),
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Cerrar el cuadro de diálogo
                                    },
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 450,
                      height: 350,
                      padding: EdgeInsets.only(left: 15, top: 20),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.grey[200]),
                      child: Column(
                        children: [
                          Text('Registro salida',
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: AppColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              )),
                          SizedBox(height: 30),
                          Card(
                            elevation: 0.0,
                            child: Container(
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
                              child: Row(children: [
                                Text("Patente: ",
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: AppColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    )),
                                SizedBox(
                                  width: screenWidth * 0.0735,
                                ),
                                Container(
                                  width: screenWidth * 0.13,
                                  height: screenHeight * 0.05,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: textInput("GW-KG-64",
                                          _patenteSController, 5.0, false)),
                                )
                              ]),
                            ),
                          ),
                          Card(
                            elevation: 0.0,
                            child: Container(
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
                              child: Row(children: [
                                Text("Hora Entrada: ",
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: AppColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    )),
                                SizedBox(
                                  width: screenWidth * 0.0397,
                                ),
                                Container(
                                  width: screenWidth * 0.13,
                                  height: screenHeight * 0.05,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: textInput('Hora ',
                                          _horaESController, 5.0, false)),
                                )
                              ]),
                            ),
                          ),
                          Card(
                            elevation: 0.0,
                            child: Container(
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
                              child: Row(children: [
                                Text("Hora Salida: ",
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: AppColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    )),
                                SizedBox(
                                  width: screenWidth * 0.0505,
                                ),
                                Container(
                                  width: screenWidth * 0.13,
                                  height: screenHeight * 0.05,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: textInput(
                                          DateFormat('HH:mm:ss')
                                              .format(DateTime.now())
                                              .toString(),
                                          _horaSSController,
                                          5.0,
                                          true)),
                                )
                              ]),
                            ),
                          ),
                          Card(
                            elevation: 0.0,
                            child: Container(
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
                              child: Row(children: [
                                Text("Por pagar ",
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: AppColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    )),
                                SizedBox(
                                  width: 100,
                                ),
                                Container(
                                  width: screenWidth * 0.13,
                                  height: screenHeight * 0.05,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: textInput('5400', _pagarController,
                                          5.0, false)),
                                )
                              ]),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: screenHeight * 0.04),
                            child: Row(
                              children: [
                                Spacer(),
                                Container(
                                  width: 150,
                                  height: 40,
                                  child: ElevatedButton(
                                    child: Text("Retirar"),
                                    style: ElevatedButton.styleFrom(
                                      shape: StadiumBorder(),
                                      backgroundColor: Colors.green,
                                    ),
                                    onPressed: () async {

                                      if(total>disp){
                                        CollectionReference estRef = FirebaseFirestore.instance.collection('estacionamientos');
                                        // DocumentSnapshot estDoc = await estRef.doc(uid).get();
                                        // int cuposDisponibles = estDoc['cupos_disponibles'];
                                        // cuposDisponibles--;
                                        List<DocumentReference> autosDoc=[];
                                        await estRef.doc(uid).get().then((value) async {
                                          
                                          value['autos'].forEach((value)=>{
                                            autosDoc.add(value),
                                          });
                                          List<DocumentReference> autoAEliminar = [];

                                          await Future.forEach(autosDoc, (autoRef) async {
                                            String? patente = await autoData.getPatente(autoRef.id);
                                            if(patente == _patenteSController.text){
                                              print('Antes');
                                              autosDoc.forEach((e)=>print(e.id)
                                              );
                                              print('${patente} = ${_patenteSController.text} este si ${autoRef}');
                                              CollectionReference autosCollection =
                                            FirebaseFirestore.instance
                                                .collection('autos');
                                              await autosCollection.doc(autoRef.id).delete();
                                              autoAEliminar.add(autoRef);
                                            }else{
                                              print('Esta no');
                                            }
                                          });
                                          if(autoAEliminar.isEmpty){
                                            _mostrarModalConfirmacion(context,"La patente ingresada no es válida, o no se encuentra en el sistema", Icons.cancel_outlined, Colors.red);
                                            return; 
                                          }else{
                                            _mostrarModalConfirmacion(context,"Vehículo retirado correctamente",Icons.task_alt, Colors.green);
                                            await estRef.doc(uid).update({
                                            'cupos_disponibles': FieldValue.increment(1),
                                            'autos': autosDoc
                                          });
                                        setState(() {
                                            _colorController.text='';
                                            _patenteIController.text='';
                                            _marcaController.text='';
                                        });
                                          }
                                          print('Despues');
                                          autoAEliminar.forEach((autoRef) {
                                            autosDoc.remove(autoRef);
                                          });
                                          autosDoc.forEach((e)=>print(e.id));
                                          
                                        });


                                        
                                        
                                      }else{
                                        _mostrarModalConfirmacion(context,"Error al retirar el vehículo, No se pueden retirar más vehiculos", Icons.cancel_outlined, Colors.red);
                                      }
                                      
                                    },
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  width: 150,
                                  height: 40,
                                  child: ElevatedButton(
                                    child: Text("Borrar"),
                                    style: ElevatedButton.styleFrom(
                                      shape: StadiumBorder(),
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Cerrar el cuadro de diálogo
                                    },
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                  ],
                ),

                // Text('Sector de pruebas'),
                // Expanded(
                //   child: FutureBuilder(
                //     future: Future.value(docsIDs),
                //     builder: (context, snapshot) {
                //       if (snapshot.connectionState == ConnectionState.waiting) {
                //         return CircularProgressIndicator();
                //       } else {
                //         return ListView.builder(
                //           itemCount: docsIDs.length,
                //           itemBuilder: (context, index) {
                //             return Material(
                //               child: ListTile(
                //                 title: GetUserData(documentId: docsIDs[index]),
                //               ),
                //             );
                //           },
                //         );
                //       }
                //     },
                //   ),
                // )
              ],
            ),
          ),
        ),
        Spacer(),
      ],
    );
  }
  Future<void> _mostrarModalConfirmacion(BuildContext context, String mensaje, IconData icono, Color color) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(icono, size: 50,color: color,),
          content: Text(mensaje),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Ok"),
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                // Realizar la acción de reportar daños
                // ... tu lógica aquí ...
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
              },
            ),
            
            
          ],
        );
      },
    );
  }
  Widget textInput(String texto, TextEditingController controller,
      double vAlignment, bool setEditable) {
    return TextField(
      readOnly: setEditable,
      controller: controller,
      obscureText: false,
      enableSuggestions: true,
      autocorrect: false,
      cursorColor: Colors.white,
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
