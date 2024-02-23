import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkit_now/utils/colors.dart';
import 'package:parkit_now/widgets/dropdownBtn.dart';
import 'package:parkit_now/widgets/web_side_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerEst extends StatefulWidget {
  const VerEst({super.key});

  @override
  State<VerEst> createState() => _VerEstState();
}

class _VerEstState extends State<VerEst> {
  late Stream<DateTime> fecha;
  late Stream<DateTime> hora;
  String? uid;
  String? name;
  String? telefono;
  String? direccion;
  List<dynamic> horarios = [];
  List<dynamic> tarifas = [];
  List<dynamic> servicios = [];

  ScrollController _horariosC =  ScrollController();
  ScrollController _tarifasC =  ScrollController();
  ScrollController _ServiciosC =  ScrollController();

  Future getUID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('userId');
    print(action);
    uid = action;
    print('UID: ${uid}');
    obtenerEstData(uid);
    
  }
  Future<void> obtenerEstData(String? uid) async {
    print('Esta es la uid recibida $uid');
    DocumentReference estRef = FirebaseFirestore.instance.collection('estacionamientos').doc(uid);
    DocumentSnapshot estSnapshot = await estRef.get();
    print(estRef);
    
    if(estSnapshot.exists) {
      print('Si existe');
      Map<String, dynamic> estData = estSnapshot.data() as Map<String, dynamic>;
      print('Datos: $estData');
      name = estData['nombre'];
      if(estData['telefono']==null){
        print('No hay telefono asociado');
        telefono = 'No hay telefono asociado';
      }else{
        print(estData['telefono']);
        telefono = estData['telefono'];
      }
      direccion = estData['direccion'];
      horarios = estData['horarios'];
      tarifas= estData['tarifa'];
      servicios = estData['servicios'];
      
      print(horarios);
    }else{
      print('No existe');
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
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: Icon(Icons.arrow_back)),
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
                      Text('Ver Estacionamiento',
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
                  Container(
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
                        vertical: screenHeight * 0.02,
                        horizontal: screenWidth * 0.02),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MediaQuery.of(context).size.width >= 1200
                                      ? Text('Nombre del Estacionamiento',
                                          style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: Colors.grey[800],
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ))
                                      : Text('Nombre del Estacionamiento',
                                          style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: Colors.grey[800],
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          )),
                                  Container(
                                    width: MediaQuery.of(context).size.width >=
                                            1200
                                        ? screenWidth * 0.18
                                        : screenWidth * 0.25,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    margin: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.008),
                                    child: Center(
                                      child: FutureBuilder(
                                        future: obtenerEstData(uid), 
                                        builder: (context, snapshot){
                                          return name== null ? SizedBox(
                                            child: CircularProgressIndicator(),
                                            height: screenHeight*0.03,
                                            width: screenHeight*0.03,
                                          ) :
                                          Text(name.toString(),
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
                                ],
                              ),
                            ),
                            Spacer(),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MediaQuery.of(context).size.width >= 1200
                                      ? Text('Telefono de Contacto',
                                          style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: Colors.grey[800],
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ))
                                      : Text('Telefono de Contacto',
                                          style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: Colors.grey[800],
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          )),
                                  Container(
                                    width: MediaQuery.of(context).size.width >=
                                            1200
                                        ? screenWidth * 0.18
                                        : screenWidth * 0.25,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    margin: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.008),
                                    child: Center(
                                      child: FutureBuilder(
                                        future: obtenerEstData(uid), 
                                        builder: (context, snapshot){
                                          return telefono== null ? SizedBox(
                                            child: CircularProgressIndicator(),
                                            height: screenHeight*0.03,
                                            width: screenHeight*0.03,
                                          ) :
                                          Text(telefono.toString(),
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
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MediaQuery.of(context).size.width >= 1200
                                  ? Text('Dirección del Estacionamiento',
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: Colors.grey[800],
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ))
                                  : Text('Dirección del Estacionamiento',
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: Colors.grey[800],
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      )),
                              Container(
                                width: screenWidth * 0.8,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                margin: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.008),
                                child: Center(
                                  child: FutureBuilder(
                                    future: obtenerEstData(uid),
                                    builder: (context,snapshot){
                                      return direccion== null ? SizedBox(
                                            child: CircularProgressIndicator(),
                                            height: screenHeight*0.03,
                                            width: screenHeight*0.03,
                                          ) :
                                          Text(direccion.toString(),
                                          style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: Colors.grey[800],
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ));
                                    },
                                  )
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MediaQuery.of(context).size.width >= 1200
                                  ? Text(
                                      'Horario(s) de atención',
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: Colors.grey[800],
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : Text(
                                      'Horario(s) de atención',
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: Colors.grey[800],
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_back), 
                                    onPressed: (){
                                      _horariosC.animateTo(
                                        _horariosC.offset-290.0,
                                        duration: Duration(milliseconds: 500), 
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                                    height: screenHeight * 0.05,
                                    width: screenWidth * 0.57,
                                    child: FutureBuilder(
                                      future: obtenerEstData(uid),
                                      builder: (context,snapshot) {
                                        return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          controller: _horariosC,
                                          itemCount: horarios.length,
                                          itemBuilder: (context, index){
                                            print(horarios.length);
                                            print('hola');
                                            return Row(
                                              children: [
                                                SizedBox(width: screenWidth*0.005),
                                                Container(
                                                  width: MediaQuery.of(context).size.width >= 1200
                                                      ? screenWidth * 0.18
                                                      : screenWidth * 0.25,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(),
                                                    borderRadius: BorderRadius.circular(25),
                                                  ),
                                                  margin: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
                                                  child: Center(
                                                    child: Text(
                                                      '${horarios[index]['apertura']} - ${horarios[index]['cierre']}',
                                                      style: TextStyle(
                                                        decoration: TextDecoration.none,
                                                        color: Colors.grey[800],
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: screenWidth*0.005),
                                              ],
                                            );
                                          },
                                          
                                        );
                                      }
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.arrow_forward), 
                                    onPressed: (){
                                      _horariosC.animateTo(
                                        _horariosC.offset+290.0,
                                        duration: Duration(milliseconds: 500), 
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MediaQuery.of(context).size.width >= 1200
                                    ? Text('Tarifas',
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Colors.grey[800],
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ))
                                    : Text('Tarifas',
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Colors.grey[800],
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        )),
                                        
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.arrow_back), 
                                      onPressed: (){
                                        _tarifasC.animateTo(
                                          _tarifasC.offset-290.0,
                                          duration: Duration(milliseconds: 500), 
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: screenHeight * 0.005),
                                      height: screenHeight * 0.05,
                                      width: screenWidth * 0.57,
                                      child: FutureBuilder(
                                        future: obtenerEstData(uid),
                                        builder: (context, snapshot) {
                                          return ListView.builder(
                                            controller: _tarifasC,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: tarifas.length,
                                            itemBuilder: (context, index){
                                              print('tarifa: ${tarifas.length}');
                                              return Row(
                                                children: [
                                                  SizedBox(width: screenWidth*0.005),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context).size.width >=
                                                                1200
                                                            ? screenWidth * 0.18
                                                            : screenWidth * 0.25,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(),
                                                      borderRadius:
                                                          BorderRadius.circular(25),
                                                    ),
                                                    margin: EdgeInsets.symmetric(
                                                        vertical: screenHeight * 0.008),
                                                    child: Center(
                                                      child: Text('\$ ${tarifas[index]}',
                                                          style: TextStyle(
                                                            decoration: TextDecoration.none,
                                                            color: Colors.grey[800],
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w600,
                                                          )),
                                                    ),
                                                  ),
                                                  SizedBox(width: screenWidth*0.005),
                                                  
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.arrow_forward), 
                                      onPressed: (){
                                        _tarifasC.animateTo(
                                          _tarifasC.offset+290.0,
                                          duration: Duration(milliseconds: 500), 
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.arrow_back), 
                                      onPressed: (){
                                        _ServiciosC.animateTo(
                                          _ServiciosC.offset-290.0,
                                          duration: Duration(milliseconds: 500), 
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: screenHeight * 0.005),
                                      height: screenHeight * 0.3,
                                      width: screenWidth * 0.57,
                                      child: FutureBuilder(
                                        future: obtenerEstData(uid),
                                        builder: (context, snapshot){
                                          if(servicios.length>0){
                                              return ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              controller: _ServiciosC,
                                              itemCount: servicios.length,
                                              itemBuilder: (context, index){
                                                return Row(
                                                  children: [
                                                    SizedBox(width: screenWidth*0.005),
                                                    Container(
                                                      margin: EdgeInsets.symmetric(
                                                          vertical: screenHeight * 0.03),
                                                      width:
                                                          MediaQuery.of(context).size.width >=
                                                                  1200
                                                              ? screenWidth * 0.3
                                                              : screenWidth * 0.35,
                                                      height: screenHeight * 0.25,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(),
                                                        borderRadius: BorderRadius.circular(25),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            children: [
                                                              Text('Servicio: ',
                                                                  style: TextStyle(
                                                                    decoration:
                                                                        TextDecoration.none,
                                                                    color: Colors.grey[800],
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight.w600,
                                                                  )),
                                                              SizedBox(
                                                                width: screenWidth * 0.014,
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(context)
                                                                            .size
                                                                            .width >=
                                                                        1200
                                                                    ? screenWidth * 0.18
                                                                    : screenWidth * 0.25,
                                                                height: screenHeight * 0.035,
                                                                
                                                                child: Center(
                                                                  child: Text('${servicios[index]['nombre']}',
                                                                  style: TextStyle(
                                                                    decoration: TextDecoration.none,
                                                                    color: Colors.grey[900],
                                                                    fontSize: 20,
                                                                    fontWeight: FontWeight.w900,
                                                                  )),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: screenHeight * 0.006,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text('Descripción: ',
                                                                  style: TextStyle(
                                                                    decoration:
                                                                        TextDecoration.none,
                                                                    color: Colors.grey[800],
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight.w600,
                                                                  )),
                                                              Container(
                                                                margin: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        screenWidth * 0.0005),
                                                                width: MediaQuery.of(context)
                                                                            .size
                                                                            .width >=
                                                                        1200
                                                                    ? screenWidth * 0.18
                                                                    : screenWidth * 0.25,
                                                                 height: screenHeight*0.07,
                                                                
                                                                child: SingleChildScrollView(
                                                                  child: Text('${servicios[index]['descripcion']}',
                                                                    textAlign: TextAlign.justify,
                                                                    style: TextStyle(
                                                                      decoration: TextDecoration.none,
                                                                      color: Colors.grey[800],
                                                                      fontSize: 20,
                                                                      
                                                                      fontWeight: FontWeight.w600,
                                                                    )),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(width: screenWidth*0.005),
                                                  ],
                                                );
                                              }
                                            );
                                          }else{
                                            return Container(
                                              child: Center(
                                                child: Text('No hay servicios ingresados',style: TextStyle(
                                                                    decoration:
                                                                        TextDecoration.none,
                                                                    color: Colors.grey[800],
                                                                    fontSize: 25,
                                                                    fontWeight: FontWeight.w600,
                                                                  )),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.arrow_forward), 
                                      onPressed: (){
                                        _ServiciosC.animateTo(
                                          _ServiciosC.offset+290.0,
                                          duration: Duration(milliseconds: 500), 
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                    ),   
                                  ],
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        Spacer(),
      ],
    );
  }
}
