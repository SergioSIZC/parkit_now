import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkit_now/utils/colors.dart';
import 'package:parkit_now/widgets/dropdownBtn.dart';
import 'package:parkit_now/widgets/web_side_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MiCuenta extends StatefulWidget {
  const MiCuenta({super.key});

  @override
  State<MiCuenta> createState() => _MiCuentaState();
}

class _MiCuentaState extends State<MiCuenta> {
  TextEditingController encargadoC = new TextEditingController();
  TextEditingController correoPPC = new TextEditingController();
  TextEditingController telefonoC = new TextEditingController();

  String correoPP='';
  String telefono='';
  String encargado='';
  String correo='';
  bool editable = false;
  late Stream<DateTime> fecha;
  late Stream<DateTime> hora;

  String? uid;

  Future getUID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('userId');
    print(action);
    uid = action;
    print('UID: ${uid}');
    getEstData();
  }
  Future<void> getEstData() async{
    DocumentReference estRef = FirebaseFirestore.instance.collection('estacionamientos').doc(uid);
    DocumentSnapshot estSnap = await estRef.get();
    if( estSnap.exists ){
      Map<String,dynamic> estData = estSnap.data() as Map<String,dynamic>;
      print(estData);
      correoPP=estData['correoPP'];
      if(estData['telefono']==null || estData['telefono'] ==''){
        print('No hay telefono asociado');
        telefono = 'No hay telefono asociado';
      }else{
        print(estData['telefono']);
        telefono = estData['telefono'];
        
      }
      if(estData['encargados'].length==0){
        encargado ='No hay encargado';
      }else{
        print(estData['encargados'][0]);
        encargado = estData['encargados'][0];
        
      }
      correo= estData['correo'];
    }
  }
  @override
  void initState() {
    hora = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());
    fecha = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());

    getUID();
    super.initState();
  }
  @override
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
                  SizedBox(
                    height: 20,
                  ),
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
                      Text('Mi Cuenta',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: AppColors.primary,
                            fontSize: 30,
                          )),
                      Expanded(child: Container()),
                      //Fecha y hora
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
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  FutureBuilder(
                    future: getEstData(),
                    builder: (context,snapshot) {
                      if(telefono!='No hay telefono asociado'){
                        telefonoC.text= telefono;
                      }
                      if(encargado!='No hay encargado'){
                        encargadoC.text= encargado;
                      }     
                      correoPPC.text = correoPP;                 
                      return encargado=='' ? CircularProgressIndicator(): Container(
                        height: screenHeight * 0.74,
                        width: screenWidth * 0.8,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Colors.grey[200],
                        ),
                        margin:
                            EdgeInsets.symmetric(horizontal: screenWidth * 0.00099),
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.04,
                            horizontal: screenWidth * 0.04),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Material(
                                  color: Colors.grey[200],
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        MediaQuery.of(context).size.width >= 1200
                                            ? Text('Correo Actual',
                                                style: TextStyle(
                                                  decoration: TextDecoration.none,
                                                  color: Colors.grey[800],
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ))
                                            : Text('Correo Actual',
                                                style: TextStyle(
                                                  decoration: TextDecoration.none,
                                                  color: Colors.grey[800],
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                        Container(
                                          width: screenWidth*0.3,
                                          height: 35,
                                          child: Text('$correo', style: TextStyle(fontSize:20)),
                                        ),
                                    
                                        
                                      ],
                                    ),
                                  ),
                                ),
                                Material(
                                  color: Colors.grey[200],
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        MediaQuery.of(context).size.width >= 1200
                                            ? Text('Cambiar Encargado',
                                                style: TextStyle(
                                                  decoration: TextDecoration.none,
                                                  color: Colors.grey[800],
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ))
                                            : Text('Cambiar Encargado',
                                                style: TextStyle(
                                                  decoration: TextDecoration.none,
                                                  color: Colors.grey[800],
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                        Container(
                                          width: screenWidth*0.3,
                                          height: 35,
                                          child: editable?textInput(
                                              '$encargado', encargadoC, 5.0, false):
                                              Text('$encargado', style: TextStyle(fontSize:20)),
                                        ),
                                    
                                        
                                      ],
                                    ),
                                  ),
                                ),
                                Material(
                                  color: Colors.grey[200],
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        MediaQuery.of(context).size.width >= 1200
                                            ? Text('Cambiar Correo Paypal',
                                                style: TextStyle(
                                                  decoration: TextDecoration.none,
                                                  color: Colors.grey[800],
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ))
                                            : Text('Cambiar Correo Paypal',
                                                style: TextStyle(
                                                  decoration: TextDecoration.none,
                                                  color: Colors.grey[800],
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                        Container(
                                          width: screenWidth*0.3,
                                          height: 35,
                                          child: editable?textInput(
                                              '$correoPP', correoPPC, 5.0, false):
                                              Text('$correoPP', style: TextStyle(fontSize:20)),
                                        ),
                                    
                                        
                                      ],
                                    ),
                                  ),
                                ),
                                Material(
                                  color: Colors.grey[200],
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        MediaQuery.of(context).size.width >= 1200
                                            ? Text('Agregar número de teléfono',
                                                style: TextStyle(
                                                  decoration: TextDecoration.none,
                                                  color: Colors.grey[800],
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ))
                                            : Text('Agregar número de teléfono',
                                                style: TextStyle(
                                                  decoration: TextDecoration.none,
                                                  color: Colors.grey[800],
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                        Container(
                                          width: screenWidth*0.3,
                                          height: 35,
                                          child: editable?textInput(
                                              '$telefono', telefonoC, 5.0, false):
                                              Text('$telefono', style: TextStyle(fontSize:20)),
                                        ),
                                    
                                        
                                      ],
                                    ),
                                  ),
                                ),
                                Material(
                                  color: Colors.grey[200],
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        editable? Row(
                                          children: [
                                            ElevatedButton(onPressed: () async{
                                              CollectionReference estRef = FirebaseFirestore.instance.collection('estacionamientos');
                                              await estRef.doc(uid).update({
                                                'encargados': [encargadoC.text],
                                                'telefono': telefonoC.text,
                                                'correoPP': correoPPC.text,
                                              }).then((value) => setState((){}));
                                              editable = false;
                                              setState(() {
                                                
                                              });
                                            }, child: Row(
                                              children: [
                                                Text('Guardar'),
                                                Icon(Icons.save),
                                              ],
                                            )),
                                            ElevatedButton(onPressed: (){
                                              editable = false;
                                              setState(() {
                                                
                                              });
                                            }, child: Row(
                                              children: [
                                                Text('Cancelar'),
                                                Icon(Icons.cancel),
                                              ],
                                            ))
                                          ],
                                        ):
                                        ElevatedButton(onPressed: (){
                                          editable = true;
                                          setState(() {
                                            
                                          });
                                        }, child: Row(
                                          children: [
                                            Text('Editar'),
                                            Icon(Icons.edit),
                                          ],
                                        ))
                                    
                                        
                                      ],
                                    ),
                                  ),
                                ),
                                
                              ],
                            ),
                          ]
                        )
                      );
                    }
                  ),
                ]
            )
          ),
        ),
        Spacer(),
      ]
            
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