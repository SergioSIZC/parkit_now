import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkit_now/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDropDownButton extends StatefulWidget {
  @override
  _MyDropDownButtonState createState() => _MyDropDownButtonState();
}

class _MyDropDownButtonState extends State<MyDropDownButton> {
  // Lista de elementos para mostrar en la lista desplegable
  String? uid;
  String selectedItem = 'Crear Encargado';
  List<String> encargados = [];
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _aPController = TextEditingController();
  TextEditingController _aMController = TextEditingController();
  Key _textFieldKey = UniqueKey();

  // Variable para almacenar la opción seleccionada

  Future getUID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('userId');
    print(action);
    uid = action;
    print('UID: ${uid}');
    await getEncargados();
  }

  Future getEncargados() async {
    if (uid != null) {
      final DocumentSnapshot estDoc = await FirebaseFirestore.instance
          .collection('estacionamientos')
          .doc(uid)
          .get();
      if (estDoc.exists) {
        final estData = estDoc.data() as Map<String, dynamic>;
        final encargadosDynamic =
            estData['encargados'] ?? <dynamic>[]; // Manejo de nulos
        final encargadosString = List<String>.from(
            encargadosDynamic.map((dynamic e) => e.toString()));
        setState(() {
          encargados = encargadosString;
          selectedItem = 'Crear Encargado';
        });
        print('Nombre del estacionamiento: ${estData['encargados']}');
      }
    }
    print('Hola desde dropdown');
  }

  @override
  void initState() {
    // TODO: implement initState
    getUID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(),
            color: Colors.transparent,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              itemHeight: 60,
              value: selectedItem,
              onChanged: (value) {
                if (value == 'Crear Encargado') {
                  _mostrarModalCrearEnc(context, 'Crear Nuevo Encargando',
                      Icons.person_add, AppColors.primary);
                  print('No hay encargados');
                } else {
                  setState(() {
                    selectedItem = value.toString();
                  });
                }
                // Actualiza el estado cuando se selecciona una opción
              },
              items: (encargados.isEmpty
                      ? ['Crear Encargado']
                      : [...encargados, 'Crear Encargado'])
                  .map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: Container(
                    height: 100,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        if (item != 'Crear Encargado')
                          Column(
                            children: [
                              Text(item,
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: AppColors.primary,
                                      fontSize: 20)),
                              Text('Encargado ${item}',
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Colors.grey,
                                      fontSize: 10))
                            ],
                          ),
                        if (item == 'Crear Encargado')
                          Row(
                            children: [
                              Container(
                                  width: screenWidth * 0.045,
                                  height: screenHeight * 0.1,
                                  child: Icon(
                                    Icons.person_add,
                                    size: 30,
                                  )),
                              Text(item,
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: AppColors.primary,
                                      fontSize: 20)),
                            ],
                          )
                        else
                          Image(
                            image: AssetImage('assets/images/user.png'),
                            width: 50,
                          )
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _mostrarModalCrearEnc(
      BuildContext context, String mensaje, IconData icono, Color color) async {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool ver = true;
    return showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: screenHeight * 0.7,
            width: screenWidth * 0.7,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    child: Icon(
                  Icons.person_add,
                  size: 40,
                )),
                Center(
                    child: Text(
                  'Registrar un nuevo encargado',
                  style: TextStyle(fontSize: 30),
                )),
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: screenWidth * 0.05,
                  margin: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.01,
                      horizontal: screenWidth * 0.05),
                  child: Material(
                    child: TextField(
                      controller: _nombreController,
                      decoration:
                          InputDecoration(labelText: 'Ingrese su Nombre'),
                    ),
                  ),
                ),
                Container(
                  width: screenWidth * 0.05,
                  margin: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.01,
                      horizontal: screenWidth * 0.05),
                  child: Material(
                    child: TextField(
                      controller: _aPController,
                      decoration: InputDecoration(
                          labelText: 'Ingrese su primer apellido'),
                    ),
                  ),
                ),
                Container(
                  width: screenWidth * 0.05,
                  margin: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.01,
                      horizontal: screenWidth * 0.05),
                  child: Material(
                      child: TextField(
                    controller: _aMController,
                    decoration: InputDecoration(
                        labelText: 'Ingrese su segundo apellido'),
                  )),
                ),
                Container(
                  width: screenWidth * 0.9,
                  margin: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.01,
                      horizontal: screenWidth * 0.05),
                  child: Expanded(
                    child: TextField(
                     
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passController,
                      decoration: InputDecoration(
                          labelText: 'Ingrese una contraseña',
                          
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: screenWidth * 0.05,
                  margin: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.01,
                      horizontal: screenWidth * 0.1),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      ElevatedButton(
                        child: Text("Crear"),
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () async{
                          
                          DocumentSnapshot estDoc = await FirebaseFirestore.instance.collection('estacionamientos').doc(uid).get();
                          if(estDoc.exists) {
                            
                          }

                          Navigator.of(context)
                              .pop(); // Cerrar el cuadro de diálogo
                        },
                      ),
                      Spacer(),
                      ElevatedButton(
                        child: Text("Borrar"),
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          // Realizar la acción de reportar daños
                          // ... tu lógica aquí ...
                          Navigator.of(context)
                              .pop(); // Cerrar el cuadro de diálogo
                        },
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ],
            ));
      },
    );
  }
}
