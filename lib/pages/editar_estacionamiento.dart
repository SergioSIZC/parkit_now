import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkit_now/utils/colors.dart';
import 'package:parkit_now/widgets/web_side_layout.dart';

class EditarEstacionamiento extends StatefulWidget {
  const EditarEstacionamiento({super.key});

  @override
  State<EditarEstacionamiento> createState() => _EditarEstacionamientoState();
}

class _EditarEstacionamientoState extends State<EditarEstacionamiento> {
  late Stream<DateTime> fecha;
  late Stream<DateTime> hora;

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  TextEditingController _addressController = new TextEditingController();
  TextEditingController _tarifaController = new TextEditingController();
  TextEditingController _horarioController = new TextEditingController();
  @override
  void initState() {
    hora = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());
    fecha = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());

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
                Container(                    
                    height: screenHeight * 0.09,
                    child: Image(
                        image:
                            AssetImage('assets/images/estacionamiento.png'))),
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
                                child: textInput('Estacionamiento Tobías',
                                    _nameController, 5.0, false)),
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
                                child: textInput('Av. Libertad #408',
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
                        child: Row(children: [
                          Text("Horario(s) de atención: ",
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: AppColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              )),
                          SizedBox(
                            width: 87,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 175,
                                height: 35,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: textInput('09:00 - 22:00',
                                        _horarioController, 5.0, false)),
                              ),
                              Container(
                                width: 175,
                                height: 35,
                                child: ElevatedButton(
                                  child: Text(' + | Agregar Horario'),
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
                            width: 220,
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
