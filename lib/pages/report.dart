import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkit_now/utils/colors.dart';
import 'package:parkit_now/widgets/dropdownBtn.dart';
import 'package:parkit_now/widgets/web_side_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  String? uid;
  String? aid;
  String? ama;
  String? apa;
  late Stream<DateTime> fecha;
  late Stream<DateTime> hora;
  
  TextEditingController _vehiculoController = new TextEditingController();
  TextEditingController _patenteController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();
  TextEditingController _descripcionController = new TextEditingController();

  Future getUID() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('userId');
    final String? action2 = prefs.getString('id_automovilista');
    final String? action3 = prefs.getString('marca');
    final String? action4 = prefs.getString('patente');
    print('UID: $action');
    print('AID: $action2');
    print('MARCA: $action3');
    print('PATENTE: $action4');
    uid = action;
    aid = action2;
    ama = action3;
    apa = action4;
    
    
  }
  
  @override
  void initState() {
    getUID();
    hora = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());
    fecha = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());

    super.initState();
  }
  

  Widget build(BuildContext context) {
    final Map<String, dynamic>? parametros = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    if (parametros != null && parametros.containsKey('marca')) {
      _vehiculoController.text = parametros['vehiculo'].toString();
      print(parametros);
    } else {
      print('Advertencia: Los parámetros son nulos o no contienen la clave "marca".');
    }
    
    return Row(children: [
      (MediaQuery.of(context).size.width >= 1200)
            ? Flexible(flex: 2, child: SideLayout())
            : Container(),
      Spacer(),
      Expanded(
          flex: 8,
          child: Container(
              child: Column(children: [
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
                      Material(
                              child: MyDropDownButton(),
                            )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Text('Reporte de daños',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      color: AppColors.primary,
                      fontSize: 30,
                    )),
                Expanded(child: Container()),
                StreamBuilder<DateTime>(
                  stream: hora,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
            Row(
              children: [
                Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height:100),
                    Card(
                      elevation: 0.0,
                      child: Row(children: [
                        Text("Vehículo: ",
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: AppColors.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            )),
                        SizedBox(
                          width: 108,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width >=
                                  1200
                              ? screenWidth*0.23
                              : screenWidth * 0.25,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          margin: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.008),
                          child: Center(
                            child: FutureBuilder(
                              future: getUID(), 
                              builder: (context, snapshot){
                                return ama== null ? SizedBox(
                                  child: CircularProgressIndicator(),
                                  height: screenHeight*0.03,
                                  width: screenHeight*0.03,
                                ) :
                                Text(ama.toString().toUpperCase(),
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.grey[800],
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ));
                              }
                            ),
                          ),
                        ),
                      ]),
                    ),
                    Card(
                      elevation: 0.0,
                      child: Row(children: [
                        Text("Patente: ",
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: AppColors.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            )),
                        SizedBox(
                          width: 117,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width >=
                                  1200
                              ? screenWidth*0.23
                              : screenWidth * 0.25,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          margin: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.008),
                          child: Center(
                            child: FutureBuilder(
                              future: getUID(), 
                              builder: (context, snapshot){
                                return apa== null ? SizedBox(
                                  child: CircularProgressIndicator(),
                                  height: screenHeight*0.03,
                                  width: screenWidth*0.23,
                                ) :
                                Text(apa.toString(),
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.grey[800],
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ));
                              }
                            ),
                          ),
                        ),
                      ]),
                    ),
                    Card(
                      elevation: 0.0,
                      child: Row(children: [
                        Text("Hora del accidente: ",
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: AppColors.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: screenWidth*0.23,
                          height: 35,
                          child: Align(
                              alignment: Alignment.center,
                              child:
                                  textInput(DateFormat('HH:mm:ss').format(DateTime.now()).toString(), _dateController, 5.0, true)),
                        )
                      ]),
                    ),
                    Card(
                      elevation: 0.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text("Descripción:",
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: AppColors.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            )),
                        SizedBox(
                          width: 81,
                        ),
                        Container(
                          width: screenWidth*0.23,
                          margin: EdgeInsets.symmetric(vertical: screenHeight*0.03),
                          child: TextField(
                          
                          controller: _descripcionController,
                          obscureText: false,
                          enableSuggestions: true,
                          autocorrect: false,
                          maxLines: 3,
                          cursorColor: AppColors.primary,
                          style: TextStyle(color: AppColors.primary),
                          decoration: InputDecoration(
                            
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(25.0), left: Radius.circular(25.0)),
                            ),
                            hintText: 'Descripción de lo ocurrido...',
                            hintStyle: TextStyle(
                              fontSize: 20,
                            ),
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            fillColor: Colors.white.withOpacity(0.9),
                            alignLabelWithHint: true,
                          ),
                          keyboardType: TextInputType.text,
                          )
                        )
                      ]),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 160,
                          child: ElevatedButton(
                            onPressed: () async {
                              
                              _mostrarModalConfirmacion(context);
                            }, 
                            child: Text("Reportar daños", style: TextStyle(color: AppColors.white),),
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              backgroundColor: Colors.green,
                              
                            ),
                          ),
                        ),
                        SizedBox(width: 50,),
                        SizedBox(
                          width: 160,
                          child: ElevatedButton(
                            onPressed: (){
                              Navigator.pushNamed(context, 'listado-reserva-vehiculo');
                            }, 
                            child: Text("Cancelar", style: TextStyle(color: AppColors.white),),
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
              ],
            )
          ]))),
      Spacer(),
    ]);
  }
  Future<void> _mostrarModalConfirmacion(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(Icons.warning, size: 50,color: Colors.amber,),
          title: Text("¿Estás seguro de que quieres reportar daños?"),
          content: Text("Patente: $apa"),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Aceptar"),
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                backgroundColor: Colors.green,
              ),
              onPressed: () async{
                DocumentReference userRef = FirebaseFirestore.instance.collection('usuarios').doc(aid);
                DocumentSnapshot userSnap = await userRef.get();
                if(userSnap.exists){
                  
                  final fechaFormateada =
                      DateFormat('dd/MM/yyyy').format(DateTime.now());
                  final horaFormateada =
                      DateFormat('HH:mm:ss').format(DateTime.now());
                  var alertas = {
                    'patente': apa.toString(),
                    'marca': ama.toString(),
                    'id_estacionamiento': uid,
                    'descripción':_descripcionController.text,
                    'fecha': fechaFormateada,
                    'hora': horaFormateada,
                  };
                  userRef.update({
                    'alertas': FieldValue.arrayUnion([alertas]),
                  });
                  print('alertas: ${userSnap['alertas']}');
                }else{
                  print('Usuario no existe');
                }
                _descripcionController.text='';
                setState(() {
                  
                });
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
              },
            ),
            ElevatedButton(
              child: Text("Cancelar"),
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
              },
            ),
            
          ],
        );
      },
    );
  }
  Widget textInput(
      String texto, TextEditingController controller, double vAlignment, bool setEditable) {
        double screenHeight = MediaQuery.of(context).size.height;
        double screenWidth = MediaQuery.of(context).size.width;
    return TextField(
      readOnly: setEditable,
      controller: controller,
      obscureText: false,
      enableSuggestions: true,
      autocorrect: false,
      maxLines: null,
      cursorColor: AppColors.primary,
      style: TextStyle(color: AppColors.primary),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: vAlignment,horizontal: 10.0),
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
