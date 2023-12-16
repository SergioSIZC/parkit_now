import 'package:cloud_firestore/cloud_firestore.dart';
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
          !isEditable ? Container(
            margin: EdgeInsets.symmetric(vertical: screenHeight*0.03),
            child: Text(userName?? 'Cargando...', style: TextStyle(fontSize: 18))) 
          : TextField(
            controller: _nombreC,
            decoration: InputDecoration(
              labelText: userName,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(25.0), left: Radius.circular(25.0)),
                
              ),
            ),
          ),
          !isEditable ? Container(
            margin: EdgeInsets.only(bottom: screenHeight*0.03, top: screenHeight*0.01),
            child: Text(userLastName?? 'Cargando...', style: TextStyle(fontSize: 18))) 
          : TextField(
            controller: _apellidoC,
            decoration: InputDecoration(
              labelText: userLastName,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(25.0), left: Radius.circular(25.0)),
                
              ),
            ),
          ),
          Row(
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
                      onPressed: (){
                        isEditable= false;
                        setState(() {
                          userLastName= _apellidoC.text;
                          userName = _nombreC.text;
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
                        isEditable= true;
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
          )
        ],
      ),
    );
  }
}