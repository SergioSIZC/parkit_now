import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetEstData extends StatelessWidget {
  final String documentId;
  final String campo;
  const GetEstData({super.key, required this.documentId, required this.campo});

  @override
  Widget build(BuildContext context) {
    
    if(campo == 'cupos_disponibles'){
      return getCuposDisponibles();  
    }else if(campo == 'cupos_ocupados'){
      return getCuposOcupados();
    }else if(campo == 'cupos_totales'){
      return getCuposTotales();
    }else if(campo == 'autos'){
      return getAutos();
    }else if(campo == 'nombre'){
      return getNombre();
    }else if(campo == 'cant_reservas'){
      return getCantReservas();
    }else{
      return Container();
    }
  }
  FutureBuilder<DocumentSnapshot> getCuposDisponibles(){
    CollectionReference est = FirebaseFirestore.instance.collection('estacionamientos');
    return FutureBuilder<DocumentSnapshot>(
      future: est.doc(documentId).get(),
      builder: (((context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data['cupos_disponibles']}',
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Colors.black,
                                      fontSize: 40)); 
        }
        return CircularProgressIndicator.adaptive();
      })),
    );
  }
  FutureBuilder<DocumentSnapshot> getCantReservas(){
    CollectionReference est = FirebaseFirestore.instance.collection('estacionamientos');
    return FutureBuilder<DocumentSnapshot>(
      future: est.doc(documentId).get(),
      builder: (((context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data['reservas'].length}',
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Colors.black,
                                      fontSize: 40)); 
        }
        return CircularProgressIndicator.adaptive();
      })),
    );
  }
  FutureBuilder<DocumentSnapshot> getCuposOcupados(){
    CollectionReference est = FirebaseFirestore.instance.collection('estacionamientos');
    return FutureBuilder<DocumentSnapshot>(
      future: est.doc(documentId).get(),
      builder: (((context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data['cupos_totales'] - data['cupos_disponibles']}',
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Colors.black,
                                      fontSize: 40)); 
        }
        return CircularProgressIndicator.adaptive();
      })),
    );
  }
  FutureBuilder<DocumentSnapshot> getCuposTotales(){
    CollectionReference est = FirebaseFirestore.instance.collection('estacionamientos');
    return FutureBuilder<DocumentSnapshot>(
      future: est.doc(documentId).get(),
      builder: (((context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data['cupos_totales']}',
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Colors.black,
                                      fontSize: 40)); 
        }
        return CircularProgressIndicator.adaptive();
      })),
    );
  }
  FutureBuilder<DocumentSnapshot> getNombre(){
    CollectionReference est = FirebaseFirestore.instance.collection('estacionamientos');
    return FutureBuilder<DocumentSnapshot>(
      future: est.doc(documentId).get(),
      builder: (((context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data['nombre']}',
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Colors.black,
                                      fontSize: 40)); 
        }
        return CircularProgressIndicator.adaptive();
      })),
    );
  }
  FutureBuilder<DocumentSnapshot> getAutos(){
    CollectionReference est = FirebaseFirestore.instance.collection('estacionamientos');
    return FutureBuilder<DocumentSnapshot>(
    future: est.doc(documentId).get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        List<DocumentReference> autosReferences = List.castFrom(data['autos']);

        // Lista para almacenar los datos de las referencias
        List<Map<String, dynamic>> autosDataList = [];

        // Obtener datos de cada referencia
        Future.wait(
          autosReferences.map((autoRef) {
            return autoRef.get().then((autoSnapshot) {
              if (autoSnapshot.exists) {
                autosDataList.add(autoSnapshot.data() as Map<String, dynamic>);
              }
            });
          }),
        ).then((_) {
          // Aquí tienes la lista completa de datos de las referencias
          print('Datos de autos: $autosDataList');

          // Puedes retornar o hacer algo más con la lista de datos
          return Column(
            children: autosDataList.map((autoData) {
              return Text(
                '${autoData['nombre']} - ${autoData['modelo']}',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  color: Colors.black,
                  fontSize: 20,
                ),
              );
            }).toList(),
          );
        });

      }
      return CircularProgressIndicator.adaptive();
    },
  );
  }
  
}
