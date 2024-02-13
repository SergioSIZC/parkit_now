import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkit_now/utils/colors.dart';
import 'package:parkit_now/widgets/dropdownBtn.dart';
import 'package:parkit_now/widgets/web_side_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
class EditarServicios extends StatefulWidget {
  const EditarServicios({super.key});

  @override
  State<EditarServicios> createState() => _EditarServiciosState();
}

class _EditarServiciosState extends State<EditarServicios> {
  late Stream<DateTime> fecha;
  late Stream<DateTime> hora;
  String? uid;
  List<dynamic> servicios=[];

  TextEditingController _servicioController = new TextEditingController();
  TextEditingController _tarifaController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _servicioNController = new TextEditingController();
  TextEditingController _tarifaNController = new TextEditingController();
  TextEditingController _descriptionNController = new TextEditingController();
  Future getUID() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('userId');
    print(action);
    uid = action;
    print('UID A: ${uid}');
    getEstServ();
    
  }
  Future getEstServ() async{
    DocumentReference estRef = FirebaseFirestore.instance.collection('estacionamientos').doc(uid);
    DocumentSnapshot estSnap = await estRef.get();
    if(estSnap.exists){
      Map<String,dynamic> estData = estSnap.data() as Map<String,dynamic>;

      servicios=estData['servicios'];
    }
    print(servicios);
  }
  @override
  void initState() {
    hora = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());
    fecha = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());
    getUID();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Row(children: [
      Flexible(flex: 2, child: SideLayout()),
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
                Text('Editar Servicios',
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
              height: 70,
            ),
            Center(
              child: Column(
                children: [
                  Container(
                    height: 290,
                    width: 650,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Colors.grey[200],
                    ),

                    margin: EdgeInsets.symmetric(horizontal: 50),
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal:70),
                    child: Column(
                      
                      children: [
                        Card(
                          elevation: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              
                              color: Colors.grey[200],
                            ),
                            child: Row(children: [
                              Text("Servicio: ",
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: AppColors.primary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  )),
                              SizedBox(
                                width: 50,
                              ),
                              Container(
                                width: 350,
                                height: 35,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: textInput('',
                                        _servicioController, 5.0, false)),
                              )
                            ]),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Card(
                          elevation: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                            ),
                            child: Row(children: [
                              Text("Descripción: ",
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: AppColors.primary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  )),
                              SizedBox(
                                width: 13,
                              ),
                              Container(
                                width: 350,
                                height: 35,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: textInput('',
                                        _descriptionController, 5.0, false)),
                              )
                            ]),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Card(
                          elevation: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                            ),
                            child: Row(children: [
                              Text("Tarifa: ",
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: AppColors.primary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  )),
                              SizedBox(
                                width: 74,
                              ),
                              Container(
                                width: 350,
                                height: 35,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: textInput(
                                        '', _tarifaController, 5.0, false)),
                              )
                            ]),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                                    
                          children: [
                            Spacer(),
                            Container(
                              width: 150,
                              height: 40,
                              child: ElevatedButton(
                                child: Text("Guardar"),
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
                                  _servicioController.text ="";
                                  _descriptionController.text ="";
                                  _tarifaController.text ="";
                                   // Cerrar el cuadro de diálogo
                                },
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: 650,
                    height: 70,
                    child: ElevatedButton(
                      onPressed: (){
                        _mostrarModalNuevo(context);
                      }, 
                      child: Text(' + Agregar Servicio',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          backgroundColor: Colors.grey[400]
                        )
                    ),
                  )
                ],
              ),
            )
          ]))),
      Spacer(),
    ]);
  }
  Future<void> _mostrarModalNuevo(BuildContext context) async {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return showDialog(
      
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            height: screenHeight*0.6,
            child: AlertDialog(
              backgroundColor: Colors.grey[200],
              surfaceTintColor: Colors.grey[200],
              content: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: screenHeight*0.05),
                    child: Center(child: Text('Agregar Nuevo Servicio', style: TextStyle(
                              decoration: TextDecoration.none,
                              color: AppColors.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            )))
                  ),
                  Card(
                    elevation: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        
                        color: Colors.grey[200],
                      ),
                      child: Row(children: [
                        Text("Servicio: ",
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: AppColors.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            )),
                        SizedBox(
                          width: 50,
                        ),
                        Container(
                          width: 350,
                          height: 35,
                          child: Align(
                              alignment: Alignment.center,
                              child: textInput('',
                                  _servicioNController, 5.0, false)),
                        )
                      ]),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Card(
                    elevation: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      child: Row(children: [
                        Text("Descripción: ",
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: AppColors.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            )),
                        SizedBox(
                          width: 13,
                        ),
                        Container(
                          width: 350,
                          height: 35,
                          child: Align(
                              alignment: Alignment.center,
                              child: textInput('',
                                  _descriptionNController, 5.0, false)),
                        )
                      ]),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Card(
                    elevation: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      child: Row(children: [
                        Text("Tarifa: ",
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: AppColors.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            )),
                        SizedBox(
                          width: 74,
                        ),
                        Container(
                          width: 350,
                          height: 35,
                          child: Align(
                              alignment: Alignment.center,
                              child: textInput(
                                  '', _tarifaNController, 5.0, false)),
                        )
                      ]),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      child: Text("Agregar"),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () async{
                        // Realizar la acción de reportar daños
                        // ... tu lógica aquí ...
                        var servicio = {
                          'nombre': _servicioNController.text,
                          'descripcion':_descriptionNController.text,
                          'tarifa': _tarifaNController.text, //
                        };
                        CollectionReference estRef = FirebaseFirestore.instance.collection('estacionamientos');
                        await estRef.doc(uid).update({
                          'servicios': FieldValue.arrayUnion([servicio]),
                        });
                        
                        print(servicio);
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
                        _descriptionNController.text="";
                        _servicioNController.text="";
                        _tarifaNController.text="";
                        Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                      },
                    ),
                  ],
                ),
                
                
              ],
            ),
          ),
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
      cursorColor: AppColors.primary,
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