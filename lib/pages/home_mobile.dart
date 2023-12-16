import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parkit_now/data/get_estacionamiento_data.dart';
import 'package:parkit_now/utils/navbar.dart';
import 'package:parkit_now/widgets/google_map.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MobileHome extends StatefulWidget {
  const MobileHome({super.key});

  @override
  State<MobileHome> createState() => _MobileHomeState();
}
class _MobileHomeState extends State<MobileHome> {
  
  String? uid;
  var currentPage = DrawerSections.perfil;
  Future getUID() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('userIdM');
    print(action);
    uid = action;
    print('UID: ${uid}');
  }
  @override
  void initState() {
    getUID();
    setState(() {
      super.initState();
    });
  }
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: Builder(
          builder: (context){
            return IconButton(
              icon: Icon(Icons.person),
              color: Colors.white,
              onPressed: (){
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: <Widget>[
          Builder(
            builder: (context){
              return IconButton(
                icon: Icon(Icons.notifications),
                color: Colors.white,
                onPressed: (){
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          )
        ],
      ),
      drawer: NavBar(),
      endDrawer: Drawer(
        child: Container(
          color: Colors.grey[200],
          child: Center(
            child: Text(
              "Notifications",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30
              ),
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Container(
        color: Colors.grey.shade200,
        child: Stack(
          children: [
            Image(
              image: AssetImage('assets/images/estacionamientos2.jpg'),
            ),
            Positioned(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight*0.1,
                    ),
                    
                    Container(
                      color: Colors.transparent,
                      height: screenHeight *0.9,
                      width: screenWidth*0.95,
                      child: MapScreen(),
                      
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// child: Column(
                        //   children: [
                        //     FutureBuilder(
                        //       future: FirebaseFirestore.instance.collection('estacionamientos').get(),
                        //       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        //         if (snapshot.connectionState == ConnectionState.waiting) {
                        //           return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos
                        //         } else if (snapshot.hasError) {
                        //           return Text('Error: ${snapshot.error}');
                        //         } else {
                        //           // Muestra la lista de nombres
                        //           return Column(
                        //             children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        //               Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        //               String nombre = data['nombre'];
                        //               String cupos = data['cupos_disponibles'].toString();
                        //               return Container(
                        //                 width: screenWidth*0.6,
                        //                 child: ElevatedButton(
                        //                   style: ElevatedButton.styleFrom(
                        //                     shape: BeveledRectangleBorder()
                        //                   ),
                        //                   onPressed: () async{
                        //                     CollectionReference<Map<String, dynamic>> user = await FirebaseFirestore.instance.collection('usuarios');
                        //                     DocumentSnapshot<Map<String, dynamic>> userDoc = await user.doc(uid).get();
                        //                     Map<String,dynamic>? data = userDoc.data();

                        //                     CollectionReference reservas = await FirebaseFirestore.instance.collection('reservas');
                        //                     DocumentReference reservaRef = await reservas.add({
                        //                       'usuario': userDoc.reference,
                        //                       'estacionamiento': document.reference,
                        //                       'hora': FieldValue.serverTimestamp(),
                        //                       'tarifa': 5400,

                        //                     });
                        //                     CollectionReference estRef = FirebaseFirestore.instance.collection('estacionamientos');
                        //                     DocumentSnapshot estDoc = await estRef.doc(document.reference.id).get();
                        //                     await estRef.doc(document.reference.id).update({
                        //                       'reservas': FieldValue.arrayUnion([reservaRef])
                        //                     });
                        //                     print(userDoc.reference);
                        //                     print(data);
                        //                     print('Reservar');
                        //                   },
                        //                   child: Text('$nombre | $cupos'),
                        //                 ),
                        //               );
                        //             }).toList(),
                        //           );
                        //         }
                        //       },
                        //     ),
                        //   ],
                        // )