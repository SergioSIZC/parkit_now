import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkit_now/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MiPerfil extends StatefulWidget {
  const MiPerfil({super.key});

  @override
  State<MiPerfil> createState() => _MiPerfilState();
}

class _MiPerfilState extends State<MiPerfil> {
  String? uid;
  String? userName;
  String? userLastName;
  String? userEmail;
  bool isEditable = false;
  TextEditingController _nombreC = TextEditingController();
  TextEditingController _apellidoC = TextEditingController();
  TextEditingController _correoC = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUID();
  }
  Future getUID() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('userIdM');
    print(action);
    uid = action;
    print('UID: ${uid}');
    await getUserInfo();
  }
  Future<void> getUserInfo() async {
    if (uid != null) {
      // Acceder a la colección "usuarios" en Firestore
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();

      if (userDoc.exists) {
        // Obtener datos del documento
        final userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          userName = userData['nombre'];
          userLastName = userData['apellido'];
          userEmail = userData['correo'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text('Mi Perfil'),),
      body:Column(
        children: [
          Row(
            children: [
              SizedBox(width:screenWidth*0.08),
              Text('Nombre: '),
              Spacer(),
              Container(
                margin: EdgeInsets.symmetric(vertical: screenHeight*0.03),
                child: !isEditable ? Container(

                  child: Text(userName?? 'Cargando...', style: TextStyle(fontSize: 18))) 
                : Container(
                  width: screenWidth*0.5,
                  child: TextField(
                    controller: _nombreC,
                    decoration: InputDecoration(
                      labelText: userName,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(25.0), left: Radius.circular(25.0)),
                        
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width:screenWidth*0.08),
              Text('Apellido: '),
              Spacer(),
              Container(
                margin: EdgeInsets.symmetric(vertical: screenHeight*0.03),
                child: !isEditable ? Container(
                  
                  child: Text(userLastName?? 'Cargando...', style: TextStyle(fontSize: 18))) 
                : Container(
                  width: screenWidth*0.5,
                  child: TextField(
                    controller: _apellidoC,
                    decoration: InputDecoration(
                      labelText: userLastName,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(25.0), left: Radius.circular(25.0)),
                        
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
          Row(
            children: [
              SizedBox(width:screenWidth*0.08),
              Text('Correo: '),
              Spacer(),
              Container(
                margin: EdgeInsets.symmetric(vertical: screenHeight*0.03),
                child: Text(userEmail?? 'Cargando...', style: TextStyle(fontSize: 18, color: Colors.black)),),
              Spacer(),
            ],
          ), 
          
          Container(
            margin: EdgeInsets.symmetric(vertical: screenHeight*0.06),
            child: Row(
              children: [
                Spacer(),
                !isEditable ? 
                ElevatedButton(
                  onPressed: (){
                    isEditable= true;
                    setState(() {
                      
                    });
                  }, 
                  child: Row(children: [Text('Editar',style: TextStyle(color: AppColors.primary),), Icon(Icons.edit_square, color: AppColors.primary,)]))
                  :
                  Row(
                    children: [
                       ElevatedButton(
                        onPressed: () async{
                          if(_nombreC.text =='' ){
                            _nombreC.text= userName!;
                          }
                          if(_apellidoC.text =='' ){
                            _apellidoC.text= userLastName!;
                          }
                          await FirebaseFirestore.instance.collection('usuarios').doc(uid).update({
                              'nombre': _nombreC.text,
                              'apellido': _apellidoC.text,
                              
                            }
                          
                          ).then((value){
                            _mostrarModalConfirmacion(context, 'Cambios Guardados, vuelve a iniciar sesión', Icons.check, Colors.green);
                          });
                          setState(() {
                          isEditable= false;
                            
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ), 
                        child: Row(
                          children: [
                            Text('Guardar',style: TextStyle(color: AppColors.white),), 
                            Icon(Icons.save_alt, color: AppColors.white,)
                          ]
                        )
                      ),
                       ElevatedButton(
                        onPressed: (){
                          isEditable= false;
                          setState(() {
                            
                          });
                        }, 
                        child: Row(
                          children: [
                            Text('Cancelar',style: TextStyle(color: AppColors.primary),), 
                            Icon(Icons.edit_square, color: AppColors.primary,)
                          ]
                        )
                      ),
                    ],
                  ),
                  Spacer()
              ],
            ),
          )
        ],
      ),
    );
  }
  Future<void> _mostrarModalConfirmacion(BuildContext context, String mensaje, IconData icono, Color color) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(icono, size: 50,color: color,),
          content: Text(mensaje),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Ok"),
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
            
            
          ],
        );
      },
    );
  }
}