import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:parkit_now/providers/location_service.dart';
import 'package:parkit_now/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Location _locationController = new Location();

  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  
  String? uid;
  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
  static const LatLng _applePark = LatLng(37.3346, -122.0090);
  LatLng _searchedPoint = LatLng(0,0);
  LatLng? _currentPosition = null;
  List<Marker> _markers = [];
  late BitmapDescriptor userMarker;
  late BitmapDescriptor estMarker;
  

  TextEditingController _searchController = TextEditingController();
  
  
  Future getUID() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('userIdM');
    print(action);
    uid = action;
    print('UID: ${uid}');
  }
  @override
  void initState() {
    super.initState();
    try{
      _markers.clear;
      getUID();
      getLocationUpdates();
      
    }catch(e){
      print('Error: ${e}');
    }
  }
 
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:_currentPosition==null ? 
        Center(
          child: 
            CircularProgressIndicator(),
        ) 
        :Column(
          children: [
            Container(
              width: screenWidth*0.75,
              padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white, // Fondo transparente
                  borderRadius: BorderRadius.circular(30),
                ),
              child: Row(
                
                children: [
                  Expanded(child: TextFormField(
                    key: Key('searchField'),
                    controller: _searchController,
                    textCapitalization: TextCapitalization.words,
                    readOnly: false,
                    decoration: InputDecoration(hintText: 'Buscar Dirección'),
                    onChanged: (value){
                      print(value);
                    },
                  )),
                  IconButton(onPressed: () async{
                    var place = await LocationService().getPlace(_searchController.text);
                    _goToPlace(place);
                  }, 
                  icon: Icon(Icons.search),)
                ],
              ),
            ),
            SizedBox(height: screenHeight*0.01,),
            Expanded(
              
              child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        color: Colors.transparent,
                        height: screenHeight *1,
                        width: screenWidth*0.95,
                        child: GoogleMap(
                          onMapCreated: (
                            (GoogleMapController controller) => {
                              _mapController.complete(controller),
                              _markers=[ 
                                Marker(
                                  markerId: MarkerId("_currentLocation"),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(HSLColor.fromAHSL(1, 216, 0.889, 0.212).hue),
                                  position: _currentPosition!,
                                  infoWindow: InfoWindow(title:'Tu Ubicación')
                                ),
                                Marker(
                                  markerId: MarkerId("_sourceLocation"),
                                  icon: BitmapDescriptor.defaultMarker,
                                  position: _pGooglePlex
                                ),
                                Marker(
                                  markerId: MarkerId("_searchedLocation"),
                                  icon: BitmapDescriptor.defaultMarker,
                                  position: _searchedPoint,
                                  infoWindow: InfoWindow(title: 'Punto Buscado')
                                ),
                              ],
                              _addMarkers(),
                            }
                          ),
                          initialCameraPosition: CameraPosition(target: _currentPosition!, zoom: 14),
                          markers: Set<Marker>.of(_markers),
                        ),
                        
                      ),
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed:(){
            _goToCurrentPos(_currentPosition!);
          } ,
          child: Icon(Icons.pin_drop, color: AppColors.white,),
          shape: CircleBorder(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      );
    
  }
  
  Future<void> _addMarkers() async {
    // Obtener la colección de Firebase y agregar marcadores
    
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('estacionamientos').get();

    querySnapshot.docs.forEach((doc) {
      List ubicacion = doc['ubicacion'];
      print('Hola- ${ubicacion[0]['latitud']}');
        String? id = doc.id;
        double lat = ubicacion[0]['latitud'];
        double lng = ubicacion[0]['longitud'];
        String markerTitle = doc['nombre'];
        int cupos_disponibles=doc['cupos_disponibles'];
        int cupos_totales=doc['cupos_totales'];
        int tarifa_hora = doc['tarifa'][1];
        String hApert = doc['horarios'][0]['apertura'];
        String hCierre = doc['horarios'][0]['cierre'];

        LatLng markerLatLng = LatLng(lat, lng);

        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(markerLatLng.toString()),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange
              ),
              position: markerLatLng,
              infoWindow: InfoWindow(title: markerTitle),
              onTap: (){
                _mostrarInfoEstacionamiento(context, markerTitle, cupos_disponibles, cupos_disponibles,tarifa_hora, hApert.toString(), hCierre.toString(), id, lat, lng);
              }
            ),
          );
        });
      
    });
  }
  
  Future<void> _mostrarInfoEstacionamiento(BuildContext context, String nombre, int disp, int total, int tarifa, String apert, String cierre, String? id,double lat, double lng) async {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: screenWidth*0.9,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(25)
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                nombre,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                width: screenWidth*0.7,
                height: screenHeight*0.2,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(target: LatLng(lat,lng), zoom: 19, ),
                  markers: {
                    Marker(
                      markerId: MarkerId('_estacionamiento'),
                      icon: BitmapDescriptor.defaultMarker,
                      position: LatLng(lat,lng),
                      infoWindow: InfoWindow(title:nombre),
                    )
                  },
                ),
              ),
              
              SizedBox(height: 8),
              Text(
                '$apert - $cierre',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Spacer(),
                  Text(
                    'Tarifa: ${tarifa.toString()}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Cupos: ${disp.toString()}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              
              
              
              SizedBox(height: 16),
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      CollectionReference<Map<String, dynamic>> user = await FirebaseFirestore.instance.collection('usuarios');
                        DocumentSnapshot<Map<String, dynamic>> userDoc = await user.doc(uid).get();
                        Map<String,dynamic>? data = userDoc.data();
                        if(total==disp){
                          CollectionReference estRef = FirebaseFirestore.instance.collection('estacionamientos');
                          DocumentSnapshot estDoc = await estRef.doc(id).get();

                          CollectionReference reservas = await FirebaseFirestore.instance.collection('reservas');
                          DocumentReference reservaRef = await reservas.add({
                            'usuario': userDoc.reference,
                            'estacionamiento': estDoc.reference,
                            'hora': FieldValue.serverTimestamp(),
                            'tarifa': tarifa,

                          });
                        
                          await estRef.doc(id).update({
                            'reservas': FieldValue.arrayUnion([reservaRef])
                          });
                          print(userDoc.reference);
                          print(data);
                          print('Reservar');
                          disp--;
                          await estRef.doc(id).update({
                            'cupos_disponibles': disp,
                            
                          }).then((value){
                            _addMarkers();
                          });
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        }
                    },
                    child: Text('Reservar',style: TextStyle(color: AppColors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      
                      Navigator.of(context).pop();
                    },
                    child: Text('Cerrar', style: TextStyle(color: AppColors.primary),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                    ),
                  ),
                  Spacer()
                ],
              )
            ],
          ),
        );
      },
    );
  }
  
  
  Future<void> _cameraToPosition(LatLng pos) async{
    final GoogleMapController controller = await _mapController.future;

    CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 15);
    await controller.animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }
  Future<void> getLocationUpdates() async{
    try{
      bool _serviceEnabled;
      PermissionStatus _permisionGranted;
      _serviceEnabled = await _locationController.serviceEnabled();
      if(_serviceEnabled) {
        _serviceEnabled = await _locationController.requestService();
      }else{
        return;
      }
      _permisionGranted = await _locationController.hasPermission();
      if(_permisionGranted == PermissionStatus.denied) {
        _permisionGranted = await _locationController.requestPermission();
        if(_permisionGranted == PermissionStatus.granted) {
          return;
        }
      }
      _locationController.onLocationChanged.listen((LocationData currentLocation) {
        if(currentLocation.latitude!= null && currentLocation.longitude!= null){
          setState((){
            _currentPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
            
          });
        }
      });
    }catch (e, stacktrace) {
      print("Error en getLocationUpdates: $e");
      print(stacktrace);
    }
  }
  Future<void> _goToPlace(Map<String, dynamic> place) async {
  final double lat = place['geometry']['location']['lat'];
  final double lng = place['geometry']['location']['lng'];
  final GoogleMapController controller = await _mapController.future;

    // Update the _currentPosition
    setState(() {
      _searchedPoint = LatLng(lat, lng);
    });
     // Update the position of the _searchedLocation marker
    setState(() {
      _markers.removeWhere((marker) => marker.markerId.value == "_searchedLocation");
      _markers.add(
        Marker(
          markerId: MarkerId("_searchedLocation"),
          icon: BitmapDescriptor.defaultMarker,
          position: _searchedPoint,
          infoWindow: InfoWindow(title: 'Punto Buscado'),
        ),
      );
    });
    // Update the camera position
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, lng), zoom: 18)));

  }
   Future<void> _mostrarModalConfirmacion(BuildContext context, String mensaje, IconData icono, Color color) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(icono, size: 50,color: color,),
          content: Text(mensaje),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Ok"),
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                // Realizar la acción de reportar daños
                // ... tu lógica aquí ...
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
              },
            ),
            
            
          ],
        );
      },
    );
  }
  Future<void> _goToCurrentPos(LatLng pos) async{

      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: pos, zoom: 15)));
  }
  
}