import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:parkit_now/providers/location_service.dart';
import 'package:parkit_now/utils/colors.dart';
import 'package:parkit_now/widgets/dropdownBtn.dart';
import 'package:parkit_now/widgets/web_side_layout.dart';


class RegistroEst extends StatefulWidget {
  const RegistroEst({super.key});

  @override
  State<RegistroEst> createState() => _RegistroEstState();
}

class _RegistroEstState extends State<RegistroEst> {
  late Stream<DateTime> fecha;
  late Stream<DateTime> hora;

  List<DocumentReference> docsIDs = [];
  final CollectionReference estacionamientos = FirebaseFirestore.instance.collection('estacionamientos');
  LocationService ls= LocationService();
  TextEditingController _nombreController = new TextEditingController();
  TextEditingController _direccionController = new TextEditingController();
  TextEditingController _tarifaController = new TextEditingController();
  TextEditingController _ppController = new TextEditingController();
  TextEditingController _cuposController = new TextEditingController();
  TextEditingController _horaAController = new TextEditingController();
  TextEditingController _correoController = new TextEditingController();
  TextEditingController _horaCController = new TextEditingController();
  TextEditingController _contrasenaController = new TextEditingController();

  late TimeOfDay inTime;
  late TimeOfDay outTime;
  _selectTime(bool inout) async{
    if(inout) {
      TimeOfDay? picker = await showTimePicker(context: context, initialTime: inTime);
      if(picker != null){
        setState(() {
          inTime=picker;
        });
      }
    }else{
      TimeOfDay? picker = await showTimePicker(context: context, initialTime: outTime);
      if(picker != null){
        setState(() {
          outTime=picker;
        });
      }
    }
  }

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
    hora = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());
    fecha = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());
    inTime = TimeOfDay.now();
    outTime = TimeOfDay.now();
    super.initState();
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Row(
      children: [
        (MediaQuery.of(context).size.width >= 1200)
            ? Flexible(flex: 2, child: SideLayout())
            : Container(),
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
                        Material(child: MyDropDownButton(),)
                      ],
                    ),
                    
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text('Registro de nuevo estacionamiento',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          color: AppColors.primary,
                          fontSize: 30,
                        )),
                    Expanded(child: Container()),
                    StreamBuilder<DateTime>(
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
                SizedBox(height: 30,),
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight*0.005,),
                      Card(
                            elevation: 0.0,
                            child: Container(
                              
                              child: Row(children: [
                                Text("Nombre del Estacionamiento: ", style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: AppColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    )),
                                SizedBox(
                                  width: screenWidth*0.05,
                                ),
                                Container(
                                  width: screenWidth*0.4,
                                  height: 35,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: textInput("Nombre del Estacionamiento",_nombreController, 2.0, false,false)),
                                )
                              ]),
                            ),
                          ),
                      Card(
                            elevation: 0.0,
                            child: Container(
                              
                              child: Row(children: [
                                Text("Dirección: ", style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: AppColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    )),
                                SizedBox(
                                  width: screenWidth*0.175,
                                ),
                                Container(
                                  width: screenWidth*0.4,
                                  height: 35,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: textInput("Dirección",_direccionController, 2.0, false,false)),
                                )
                              ]),
                            ),
                          ),
                      Card(
                            elevation: 0.0,
                            child: Container(
                              
                              child: Row(children: [
                                Text("Correo: ", style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: AppColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    )),
                                SizedBox(
                                  width: screenWidth*0.192,
                                ),
                                Container(
                                  width: screenWidth*0.192,
                                  height: 35,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: textInput("Correo",_correoController, 2.0, false,false)),
                                )
                              ]),
                            ),
                          ),
                      Card(
                            elevation: 0.0,
                            child: Container(
                              
                              child: Row(children: [
                                Text("Correo de PayPal: ", style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: AppColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    )),
                                SizedBox(
                                  width: 117,
                                ),
                                Container(
                                  width: 200,
                                  height: 35,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: textInput("Correo de paypal",_ppController, 2.0, false,false)),
                                )
                              ]),
                            ),
                          ),
                      
                      Card(
                            elevation: 0.0,
                            child: Container(
                              
                              child: Row(children: [
                                Text("Cupos Totales: ", style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: AppColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    )),
                                SizedBox(
                                  width: 117,
                                ),
                                Container(
                                  width: 200,
                                  height: 35,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: textInput("Cupos Totales",_cuposController, 2.0, false,false)),
                                )
                              ]),
                            ),
                          ),
                      Row(
                        children: [
                          Card(
                            elevation: 0.0,
                            child: Container(
                              
                              child: Row(children: [
                                Text("Hora de Apertura: ", style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: AppColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    )),
                                SizedBox(
                                  width: 50,
                                ),
                                Container(
                                  width: 275,
                                  height: 40,
                                  child: ElevatedButton(onPressed: (){
                                    setState(() {
                                      _selectTime(true);
                                    });
                                  }, child: Text('${inTime.format(context)}'),style:ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    
                                  )),
                                )
                              ]),
                            ),
                          ),
                      Card(
                            elevation: 0.0,
                            child: Container(
                              
                              child: Row(children: [
                                Text("Hora de Cierre:", style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: AppColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    )),
                                SizedBox(
                                  width: 50,
                                ),
                                Container(
                                  width: 275,
                                  height: 40,
                                  child: ElevatedButton(onPressed: (){
                                    setState(() {
                                      _selectTime(false);
                                    });
                                  }, child: Text(' ${outTime.format(context)}'),style:ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    
                                  )),
                                )
                              ]),
                            ),
                          ),
                        ],
                      ),
                      Card(
                            elevation: 0.0,
                            child: Container(
                              
                              child: Row(children: [
                                Text("Tarifa por minuto: ", style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: AppColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    )),
                                SizedBox(
                                  width: 117,
                                ),
                                Container(
                                  width: 200,
                                  height: 35,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: textInput("23",_tarifaController, 2.0, false,false)),
                                )
                              ]),
                            ),
                          ),
                      Card(
                            elevation: 0.0,
                            child: Container(
                              
                              child: Row(children: [
                                Text("Contraseña: ", style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: AppColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    )),
                                SizedBox(
                                  width: 117,
                                ),
                                Container(
                                  width: 200,
                                  height: 35,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: textInput("Contraseña",_contrasenaController, 2.0, false,true)),
                                )
                              ]),
                            ),
                          ),
                      
                      
                      
                      
                      ElevatedButton(onPressed: () async{                    
                      try{
                          var latLon=await ls.obtenerCoordenadas(_direccionController.text);
                          int tarifa= int.parse(_tarifaController.text);
                        Map<String, dynamic> ubicacion = {
                          'latitud': latLon['lat'],
                          'longitud': latLon['lng'],
                        };
                        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: _correoController.text.trim(),
                            password: _contrasenaController.text.trim(),
                          );
                          // Obtén el ID del usuario recién creado.
                          String? userId = credential.user?.uid;

                          // Asigna el rol al nuevo usuario.
                          await FirebaseFirestore.instance.collection('usuarios').doc(userId).set({
                            'rol': docsIDs[2],
                          });
                        Map<String,dynamic> horario = {
                          'apertura': inTime.format(context),
                          'cierre': outTime.format(context),
                        };
                        DocumentReference estRef = estacionamientos.doc(credential.user?.uid);
                        print(horario);
                        await estRef.set({
                          
                          'nombre': _nombreController.text.trim(),
                          'direccion': _direccionController.text.trim(),
                          'correo': _correoController.text.trim(),
                          'ubicacion': [ubicacion],
                          'encargados':[],
                          'servicios':[],
                          'correoPP':_ppController.text.trim(),
                          'reservas':[],
                          'autos':[],
                          'cupos_totales': int.parse(_cuposController.text.trim()),
                          'cupos_disponibles': int.parse(_cuposController.text.trim()),
                          'horarios':[horario],
                          'tarifa':[tarifa, tarifa*60],
                          'contraseña': _contrasenaController.text.trim(),
                          'telefono': '',
                          
                        }).then((value) {
                          _mostrarModalConfirmacion(context,"Estacionamiento Creado",Icons.task_alt, Colors.green);
                        }).catchError((error) {
                          _mostrarModalConfirmacion(context,"Error al añadir el estacionamiento: $error", Icons.cancel_outlined, Colors.red);
                        });
                        
                        print(_nombreController.text);
                        }catch (e){
                          print('Error $e');
                        }
                      }, child: Text('Estacionamiento')),
                    ],
                  ),
                )
              ]
            ),
          ),
        ),
        Spacer(),
      ]
    );
  }
  DateTime _parsearHora(String texto){
    List<String> partesHora = texto.split(':');
    int hora = int.parse(partesHora[0]);
    int minutos = int.parse(partesHora[1]);
    return DateTime(0,0,0,hora,minutos);
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
      double vAlignment, bool setEditable, bool isPass ) {
    return TextField(
      readOnly: setEditable,
      controller: controller,
      obscureText: isPass,
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