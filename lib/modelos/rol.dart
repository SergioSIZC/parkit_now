import 'package:cloud_firestore/cloud_firestore.dart';
class Rol{
  final String? id;
  final String rol;

  const Rol({
    this.id,
    required this.rol,
  });
  toJson(){
    return {"rol": rol};
  }

  factory Rol.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return Rol(
      id: document.id,
      rol:data["rol"],
    );
  }

}