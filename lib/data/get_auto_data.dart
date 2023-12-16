import 'package:cloud_firestore/cloud_firestore.dart';

class GetAutoData {
  getPatente(String autoid) async {
    CollectionReference<Map<String, dynamic>> auto =
        FirebaseFirestore.instance.collection('autos');
    DocumentSnapshot<Map<String, dynamic>> autoDoc =
        await auto.doc(autoid).get();

    Map<String, dynamic>? data = autoDoc.data();
    if (data != null) {
      String? patente = data['patente'];
      return patente;
    }

    return null;
  }
}
