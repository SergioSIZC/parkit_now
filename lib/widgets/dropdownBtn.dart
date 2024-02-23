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
    List<DocumentReference> docsIDs = [];
  
  String encargado ='';
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
    if (uid != null) {
      obtenerEncargados(); // Llama a getEncargados solo después de que uid se haya inicializado correctamente
    }
  }
  Future fetchData() async {
    await FirebaseFirestore.instance
        .collection('rol')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              setState(() {
               
                docsIDs.add(document.reference);
                print(document.reference.id);
              });
            }));
  }
  void obtenerEncargados() async {
      try {
      // Reemplaza 'nombre_coleccion' con el nombre real de tu colección en Firebase
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('estacionamientos')
          .doc(uid)
          .get();

      // Verificamos si el documento existe
      if (documentSnapshot.exists) {
        // Obtenemos el campo 'encargado' y lo almacenamos en la variable
        encargado = documentSnapshot['encargados'][0];
        // Actualizamos el estado para que la interfaz de usuario refleje los cambios
        setState(() {});
      } else {
        print('El documento con UID $uid no existe.');
      }
    } catch (error) {
      print('Error al obtener el encargado: $error');
    }
    }
  @override
  void initState() {
    // TODO: implement initState
    fetchData();
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
          child:Row(
            children: [
              Column(
                children: [
                  Text(encargado,
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
              SizedBox(width: 5.0,),
              Image(
                            image: AssetImage('assets/images/user.png'),
                            width: 50,
                          )
            ],
          ),
        ),
      ],
    );
  }
}
  