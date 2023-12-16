import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
class LocationService {
  final String key = "AIzaSyDDkDgQoln8eaeT-bHmKTpitkA4yje3-YY";

  Future<String> getPlaceId(String input) async{
    final String url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key";
    var response = await http.get(Uri.parse(url));
    print(response.body);
    var json = convert.jsonDecode(response.body);
    var placeId= json['candidates'][0]['place_id'] as String;
    print(placeId);
    return placeId;
  }
  Future<Map<String,dynamic>> getPlace(String input) async{
    final placeId = await getPlaceId(input);
    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);
    var results = json['result']! as Map<String,dynamic>;
    print(results['geometry']['location']['lat'].toString()+' '+ results['geometry']['location']['lng'].toString());
    return results;

  }
  Future<Map<String, dynamic>> obtenerCoordenadas(String direccion) async {
  final apiKey = 'AIzaSyDDkDgQoln8eaeT-bHmKTpitkA4yje3-YY'; // Reemplaza con tu clave de API de Google Maps
  final apiUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
  final response = await http.get(Uri.parse('$apiUrl?address=$direccion&key=$apiKey'));
  print(response);
  if (response.statusCode == 200) {
    final decodedBody = convert.jsonDecode(response.body);
    print(decodedBody['results'][0]['geometry']['location']);
    return decodedBody['results'][0]['geometry']['location'];
  } else {
    throw Exception('Error al obtener coordenadas');
  }
}

}