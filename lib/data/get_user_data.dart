import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkit_now/data/get_rol.dart';

class GetUserData extends StatelessWidget {
  
  final String documentId;
  GetUserData({super.key, required this.documentId});
  @override
  Widget build(BuildContext context) {
    return getUserApellido(documentId);
  }
  Widget getUserRol(documentId){
    CollectionReference rol = FirebaseFirestore.instance.collection('usuarios');
    return  FutureBuilder<DocumentSnapshot>(
      future: rol.doc(documentId).get(),
      builder: (((context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          
          
          
          return GetRol(documentId:data['rol'].id.toString()); 
        }
        return Text('loading...');
      })),
    );
  }
  Widget getUserName(documentId){
    CollectionReference rol = FirebaseFirestore.instance.collection('usuarios');
    return  FutureBuilder<DocumentSnapshot>(
      future: rol.doc(documentId).get(),
      builder: (((context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic>? data = snapshot.data?.data() as Map<String, dynamic>?;
          
          
          
          return Text('${data?['nombre']} ${data?['apellido']}'); 
        }
        return Text('loading...');
      })),
    );
  }
  Widget getUserApellido(documentId){
    CollectionReference rol = FirebaseFirestore.instance.collection('usuarios');
    return  FutureBuilder<DocumentSnapshot>(
      future: rol.doc(documentId).get(),
      builder: (((context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          
          return Text('Apellido ${data['apellido'].toString()}'); 
        }
        return Text('loading...');
      })),
    );
  }
  Widget getUserCorreo(documentId){
    CollectionReference rol = FirebaseFirestore.instance.collection('usuarios');
    return  FutureBuilder<DocumentSnapshot>(
      future: rol.doc(documentId).get(),
      builder: (((context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          
          
          
          return Text(data['correo'.toString()]);
        }
        return Text('loading...');
      })),
    );
  }
}