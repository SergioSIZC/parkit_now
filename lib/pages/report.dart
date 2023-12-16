import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkit_now/utils/colors.dart';
import 'package:parkit_now/widgets/web_side_layout.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  late Stream<DateTime> fecha;
  late Stream<DateTime> hora;
  
  TextEditingController _vehiculoController = new TextEditingController();
  TextEditingController _patenteController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();
  TextEditingController _descripcionController = new TextEditingController();

  @override
  void initState() {

    hora = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());
    fecha = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());

    super.initState();
  }

  Widget build(BuildContext context) {
    final Map<String, dynamic>? parametros = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

  if (parametros != null && parametros.containsKey('marca')) {
    _vehiculoController.text = parametros['vehiculo'].toString();
    print(parametros);
  } else {
    print('Advertencia: Los parámetros son nulos o no contienen la clave "marca".');
  }
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
                Column(
                  children: [
                    Text('Juan Pérez',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            color: AppColors.primary,
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
                          width: 350,
                          height: 35,
                          child: Align(
                              alignment: Alignment.center,
                              child: textInput(
                                  "Ford Fiesta", _vehiculoController, 5.0, false)),
                        )
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
                          width: 350,
                          height: 35,
                          child: Align(
                              alignment: Alignment.center,
                              child:
                                  textInput("GW-KG-64", _patenteController, 5.0, false)),
                        )
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
                          width: 350,
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
                      child: Row(children: [
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
                          width: 350,
                          height: 130,
                          child: Align(
                              alignment: Alignment.center,
                              child: textInput("Descripción del daño ocurrido...",
                                  _descripcionController, 50.0, false)),
                        )
                      ]),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 160,
                          child: ElevatedButton(
                            onPressed: (){
                              _mostrarModalConfirmacion(context);
                            }, 
                            child: Text("Reportar daños"),
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
                            onPressed: (){}, 
                            child: Text("Cancelar"),
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
          content: Text("Patente: XX-XX-XX"),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Aceptar"),
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
