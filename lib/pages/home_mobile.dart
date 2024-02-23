import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:parkit_now/data/get_estacionamiento_data.dart';
import 'package:parkit_now/utils/navbar.dart';
import 'package:parkit_now/widgets/google_map.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MobileHome extends StatefulWidget {
  const MobileHome({
    super.key,
  });

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  String? uid;
  List<dynamic> alertas = [];
  var currentPage = DrawerSections.perfil;
  String texto = 'Aviso de Cierre';
  late BannerAd bannerAd;
  bool isAdLoaded = false;
  var adUnit = "ca-app-pub-3940256099942544/6300978111";

  initBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnit,
      listener: BannerAdListener(onAdLoaded: (ad) {
        debugPrint('$ad loaded.');
        setState(() {
          isAdLoaded = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        debugPrint('BannerAd failed to load: $error');
        // Dispose the ad here to free resources.
        ad.dispose();
      }),
      request: AdRequest(),
    )..load();
  }

  Future getUID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('userIdM');
    print(action);
    uid = action;
    print('UID: ${uid}');
    obtenerAlertas();
  }
  Future obtenerAlertas() async{
    DocumentReference userRef = FirebaseFirestore.instance.collection('usuarios').doc(uid);
    DocumentSnapshot userSnap = await userRef.get();
    if(userSnap.exists){
      Map<String,dynamic> userData = userSnap.data() as Map<String,dynamic>;

      alertas = userData['alertas'];
      print('Existeeee ${alertas.length}');
    }else{
      print('no existeee $userRef');
    }
  }
  @override
  void initState() {
    getUID();
    
    initBannerAd();
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
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.person),
              color: Colors.white,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: <Widget>[
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.notifications),
                color: Colors.white,
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                  setState(() {});
                },
              );
            },
          )
        ],
      ),
      drawer: NavBar(),
      endDrawer: Drawer(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: screenHeight*0.05),
              child: Text('Notificaciones',
              style: TextStyle(
                decoration: TextDecoration.none,
                color: Colors.grey[800],
                fontSize: 20,
                fontWeight: FontWeight.w600,
              )),
            ),
            Container(
              height: screenHeight*0.85,
              child: FutureBuilder(
                future: obtenerAlertas(),
                builder: (context, snapshot){
                  return alertas.length>0 ? ListView.builder(
                    itemCount: alertas.length,
                    itemBuilder: (context, index){
                      return Container(
                        height: screenHeight * 0.15,
                        margin: EdgeInsets.all(screenWidth * 0.05),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(25.0)),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.015),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.notifications, color: Colors.red.shade700,),
                                  Text('Aviso de emergencia', style: TextStyle(color: Colors.red.shade700),),
                                  Spacer(),
                                  IconButton(onPressed: () async{
                                    DocumentReference userRef = FirebaseFirestore.instance.collection('usuarios').doc(uid);
                                    DocumentSnapshot userSnapshot = await userRef.get();
                                    if (userSnapshot.exists){
                                      userRef.update({
                                        'alertas': FieldValue.arrayRemove([alertas[index]]),
                                      }).then((value) => print('Listo'));

                                    }
                                    setState(() {
                                      
                                    });
                                  }, icon: Icon(Icons.close), style: IconButton.styleFrom(iconSize: 15),)
                                ],
                              )),
                            Container(
                              margin: EdgeInsets.all(screenWidth * 0.015),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(alertas[index]['fecha']),
                                        Text(alertas[index]['hora']),
                                      ],
                                    ),
                                    Text(
                                        alertas[index]['descripción']),
                                  ],
                                )),
                          ],
                        ));
                    }
                  ):
                  Container(child: Center(child: Text('No hay alertas',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.grey[800],
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  )),));
                  
                },
              ),
            
            )
          ],
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
                      height: screenHeight * 0.1,
                    ),
                    Container(
                      color: Colors.transparent,
                      height: screenHeight * 0.83,
                      width: screenWidth * 0.95,
                      child: MapScreen(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isAdLoaded
          ? SizedBox(
              height: bannerAd.size.height.toDouble(),
              width: bannerAd.size.width.toDouble(),
              child: AdWidget(ad: bannerAd),
            )
          : SizedBox(
            child: Text(
              'No cargado'
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