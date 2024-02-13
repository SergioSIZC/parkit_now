import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parkit_now/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawerHeader extends StatefulWidget {
  const MyDrawerHeader({super.key});

  @override
  State<MyDrawerHeader> createState() => _MyDrawerHeaderState();
}

class _MyDrawerHeaderState extends State<MyDrawerHeader> {
  String? uid;
  String? userName;
  String? userEmail;

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
          userName = userData['nombre']+' '+userData['apellido'];
          userEmail = userData['correo'];
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      color: AppColors.primary,
      width: double.infinity,
      height:200,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10, top: 10),
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/user.png'),
              )
            ),
          ),
           if (userName != null)
            Text(
              userName!,
              style: TextStyle(color: Colors.white, fontSize: 20),
            )
          else
            CircularProgressIndicator(), // Muestra el CircularProgressIndicator mientras se carga la información
          if (userEmail != null)
            Text(
              userEmail!,
              style: TextStyle(color: Colors.grey[300], fontSize: 14),
            )
          else
            SizedBox(), //
          Container(
            margin: EdgeInsets.only(top: screenHeight*0.02),
            width: screenWidth*0.5,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300,)
            ),
          ),  
        ],
      ),
    );
  }
}