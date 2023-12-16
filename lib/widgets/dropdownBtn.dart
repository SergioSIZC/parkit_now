import 'package:cloud_firestore/cloud_firestore.dart';
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
  
  // Variable para almacenar la opción seleccionada
  
  Future getUID() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('userId');
    print(action);
    uid = action;
    print('UID: ${uid}');
    await getEncargados();
  }
  Future getEncargados() async{
    if(uid!= null){
      final DocumentSnapshot estDoc = await FirebaseFirestore.instance.collection('estacionamientos').doc(uid).get();
      if(estDoc.exists){
        final estData = estDoc.data() as Map<String, dynamic>;
        encargados= estData['encargados'];
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        
        Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal:10),
          decoration: BoxDecoration(
            border: Border.all(),
            color: Colors.transparent,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              itemHeight: 60,
              
              value: selectedItem,
              onChanged: (value) {
                // Actualiza el estado cuando se selecciona una opción
                setState(() {
                  selectedItem = value.toString();
                });
              },
              items: encargados.map((String item) {
                return DropdownMenuItem( 
                  
                  value: item,
                  child: Container(
                    height: 100,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text('Juan Pérez',
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
}