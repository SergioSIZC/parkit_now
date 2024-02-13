import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkit_now/utils/colors.dart';
import 'package:parkit_now/widgets/dropdownBtn.dart';
import 'package:parkit_now/widgets/web_side_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditarEstacionamiento extends StatefulWidget {
  const EditarEstacionamiento({super.key});

  @override
  State<EditarEstacionamiento> createState() => _EditarEstacionamientoState();
}

class _EditarEstacionamientoState extends State<EditarEstacionamiento> {
  late Stream<DateTime> fecha;
  late Stream<DateTime> hora;
  String? uid;
  String? name;
  String? direccion;
  String? telefono;
  String? tarifa;
  String? hApert;
  String? hCierre;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  TextEditingController _addressController = new TextEditingController();
  TextEditingController _tarifaController = new TextEditingController();
  TextEditingController _horarioController = new TextEditingController();
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
  Future getUID() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('userId');
    print(action);
    uid = action;
    print('UID: ${uid}');
    obtenerEstData(uid);
    
  }
  void obtenerEstData(String? uid) async {
    
      DocumentReference estRef = FirebaseFirestore.instance.collection('estacionamientos').doc(uid);
      DocumentSnapshot estSnap = await estRef.get();
      if(estSnap.exists){
        Map<String, dynamic> estData =estSnap.data() as Map<String, dynamic>;
        
        
        
        print('Datos: $estData');
        name = estData['nombre'];
        print(name);
      }
      
    
  }
  @override
  void initState() {
    getUID();
    hora = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());
    fecha = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());
    inTime = TimeOfDay.now();
    outTime = TimeOfDay.now();
    super.initState();
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Row(children: [
      Flexible(flex: 2, child: SideLayout()),
      Spacer(),
      Expanded(
          flex: 8,
          child: Container(
            child: Column(children: [
            SizedBox(height: 20,),
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
                Text('Editar Estacionamiento',
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
              child: Container(
                height: screenHeight * 0.6,
                width: screenWidth * 0.8,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  color: Colors.grey[200],
                ),
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.0299),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 120),
                child: Column(
                  children: [
                    Card(
                      elevation: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                        child: Row(children: [
                          Text("Nombre del Estacionamiento: ",
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: AppColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              )),
                          SizedBox(
                            width: 25,
                          ),
                          Container(
                            width: screenWidth * 0.23,
                            height: screenWidth * 0.025,
                            child: Align(
                                alignment: Alignment.center,
                                child: textInput('$name',
                                    _nameController, 5.0, false)

                                

                              ),
                          )
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                      elevation: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                        child: Row(children: [
                          Text("Dirección del Estacionamiento: ",
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
                            width: screenWidth * 0.23,
                            height: 35,
                            child: Align(
                                alignment: Alignment.center,
                                child: textInput('direction',
                                    _addressController, 5.0, false)),
                          )
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                      elevation: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                        child: Row(children: [
                          Text("Telefono de Contacto: ",
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: AppColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              )),
                          SizedBox(
                            width: 95,
                          ),
                          Container(
                            width: screenWidth * 0.23,
                            height: 35,
                            child: Align(
                                alignment: Alignment.center,
                                child: textInput('42 2 XX XX XX',
                                    _phoneController, 5.0, false)),
                          )
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                      elevation: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                        child: Row(
                                                children: [
                        Card(
                          elevation: 0.0,
                          child: Container(
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: Row(children: [
                              Text("Hora de Apertura: ", style: TextStyle(
                                decoration: TextDecoration.none,
                                color: AppColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              )),
                              SizedBox(
                                width: screenWidth*0.005,
                              ),
                              Container(
                                width: screenWidth*0.08,
                                height: screenHeight*0.04,
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
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: Row(children: [
                              Text("Hora de Cierre:",style: TextStyle(
                                decoration: TextDecoration.none,
                                color: AppColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              )),
                              SizedBox(
                                width: screenWidth*0.005,
                              ),
                              Container(
                                width: screenWidth*0.08,
                                height: screenHeight*0.04,
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
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                      elevation: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                        child: Row(children: [
                          Text("Tarifa(s): ",
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: AppColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              )),
                          SizedBox(
                            width: screenWidth*0.05,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 175,
                                height: 35,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: textInput(
                                        '5400', _tarifaController, 5.0, false)),
                              ),
                              Container(
                                width: 175,
                                height: 35,
                                child: ElevatedButton(
                                  child: Text(' + | Agregar Tarifa'),
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      backgroundColor: Colors.grey[400]),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          )
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
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
                              Navigator.of(context)
                                  .pop(); // Cerrar el cuadro de diálogo
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
                  ],
                ),
              ),
            )
          ]))),
      Spacer(),
    ]);
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
