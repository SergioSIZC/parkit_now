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


  late Stream<DateTime> fecha;
  late Stream<DateTime> hora;
  String? uid;

  Future getUID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('userIdM');
    print(action);
    uid = action;
    print('UID: ${uid}');
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
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: textInput(
                                              'Correo', encargadoC, 5.0, false)),
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
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: textInput(
                                              'Nombre Apellido', encargadoC, 5.0, false)),
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
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: textInput(
                                              'ejemplo@gmail.com', encargadoC, 5.0, false)),
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
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: textInput(
                                              'ejemplo@gmail.com', encargadoC, 5.0, false)),
                                    ),
                                
                                    
                                  ],
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                      ]
                    )
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