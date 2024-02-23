import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkit_now/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MisAutos extends StatefulWidget {
  const MisAutos({super.key});

  @override
  State<MisAutos> createState() => _MisAutosState();
}

class _MisAutosState extends State<MisAutos> {
  String? uid;
  List<dynamic> patentes = [];
  bool tieneAutos = false;

  TextEditingController _patentesController = new TextEditingController();

  Future getUID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('userIdM');
    print(action);
    uid = action;
    print('UID: ${uid}');
    obtenerPatentes();
  }

  void obtenerPatentes() async {
    DocumentSnapshot user =
        await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
    final userData = user.data() as Map<String, dynamic>;
    patentes = userData['autos'] ?? [];
    tieneAutos = patentes.isNotEmpty;
    print(patentes);
    setState(() {});
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Autos'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: patentes.length,
              itemBuilder: (context, index) {
                return Container(
                  
                  width: screenWidth * 0.5,
                  margin: EdgeInsets.symmetric(vertical: screenWidth * 0.005),
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  decoration: BoxDecoration(                    
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.grey.shade300,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03),
                          child: Icon(Icons.directions_car, color:Colors.grey.shade700, size:30)),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all( color: Colors.grey.shade700),
                        ),
                        height: screenHeight * 0.03,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: screenWidth * 0.05),
                        child: Text(
                          patentes[index]['patente'],
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 30),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
         
        ],
      ),
      floatingActionButton: Container(
        height: screenHeight*0.06,
        width: screenWidth*0.4,
        child: FloatingActionButton(
          onPressed: () {
            // Navegar a la pantalla de añadir autos
            // Puedes usar Navigator para llevar al usuario a otra pantalla.
            // Navigator.push(context, MaterialPageRoute(builder: (context) => AgregarAutoPage()));
            _mostrarModal(context);
          },
          child: Text('Añadir Autos'),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
        ),
      ),
    );
  }

  Future<void> _mostrarModal(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // Obtener la altura del teclado virtual
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            width: screenWidth * 0.9,
            height: screenHeight - keyboardHeight,
            decoration: BoxDecoration(
                color: AppColors.white, borderRadius: BorderRadius.circular(25)),
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Añadir un nuevo auto',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: screenWidth * 1,
                      margin: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.01,
                          horizontal: screenWidth * 0.01),
                      child: Material(
                          child: TextField(
                        controller: _patentesController,
                        decoration:
                            InputDecoration(labelText: 'Ingrese una patente'),
                      )),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        ElevatedButton(
                          child: Text("Crear"),
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () async {
                            Map<String, dynamic> auto = {
                              'patente': _patentesController.text.toUpperCase(),
                            };
              
                            await FirebaseFirestore.instance
                                .collection('usuarios')
                                .doc(uid)
                                .update({
                              'autos': FieldValue.arrayUnion([auto]),
                            });
                            setState(() {
                              obtenerPatentes();
                              _patentesController.text = '';
                            });
              
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
                            setState(() {
                              
                              _patentesController.text = '';
                            });
                            Navigator.of(context)
                                .pop(); // Cerrar el cuadro de diálogo
                          },
                        ),
                        Spacer(),
                      ],
                    ),
                  ]),
            ),
          ),
        );
      },
    );
  }
}
