import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkit_now/utils/colors.dart';
import 'package:parkit_now/widgets/web_side_layout.dart';
class EditarServicios extends StatefulWidget {
  const EditarServicios({super.key});

  @override
  State<EditarServicios> createState() => _EditarServiciosState();
}

class _EditarServiciosState extends State<EditarServicios> {
  late Stream<DateTime> fecha;
  late Stream<DateTime> hora;

  TextEditingController _servicioController = new TextEditingController();
  TextEditingController _tarifaController = new TextEditingController();

  TextEditingController _descriptionController = new TextEditingController();
 
  @override
  void initState() {
    hora = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());
    fecha = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());

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
                                  Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
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
                      onPressed: (){}, 
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