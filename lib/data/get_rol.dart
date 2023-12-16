import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class GetRol extends StatelessWidget {
  final String documentId;
  GetRol({super.key, required this.documentId});
  @override
  Widget build(BuildContext context) {
    CollectionReference rol = FirebaseFirestore.instance.collection('rol');
    return  FutureBuilder<DocumentSnapshot>(
      future: rol.doc(documentId).get(),
      builder: (((context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Text('Rol: ${data['rol']}'); 
        }
        return Text('loading...');
      })),
    );
  }
}