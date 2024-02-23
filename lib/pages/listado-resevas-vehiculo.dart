import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkit_now/data/get_estacionamiento_data.dart';
import 'package:parkit_now/data/get_user_data.dart';
import 'package:parkit_now/data/vehiculos.dart';
import 'package:parkit_now/modelos/vehiculo.dart';
import 'package:parkit_now/utils/colors.dart';
import 'package:parkit_now/widgets/dropdownBtn.dart';
import 'package:parkit_now/widgets/web_side_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListadoReservaVehiculo extends StatefulWidget {
  const ListadoReservaVehiculo({super.key});

  @override
  State<ListadoReservaVehiculo> createState() => _ListadoReservaVehiculoState();
}

class _ListadoReservaVehiculoState extends State<ListadoReservaVehiculo> {
  late Stream<DateTime> fecha;
  late Stream<DateTime> hora;
  bool isReserva = false;

  String? uid;
  bool reg_button = true;
  late List<Vehiculo> vehiculos;
  int? sortColumnIndex;
  bool isAscending = false;
  Color buttonColor1 = Colors.white;
  Color? buttonColor2 = AppColors.primary;
  late List<Map<String, dynamic>> _autosList;
  late List<Map<String, dynamic>> _reservasList;
  late List<String> _reservasId = [];


  Future getUID() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('userId');
    print(action);
    uid = action;
    obtenerReservasEst(uid);
    obtenerAutosEst(uid);
    
  }
  
  Future<String?> getUsuario(DocumentReference ref) async{
    DocumentSnapshot userSnap = await ref.get();

    if(userSnap.exists){
      String? nombre = userSnap['nombre'];
      String? apellido = userSnap['apellido'];
      return '$nombre $apellido';
    }else{
      return null;
    }
  }
  @override
  void initState() {
    getUID();
    
    _autosList =[];
    _reservasList =[];
    
    // _getReservasFromFirebase();
    hora = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());
    fecha = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());

    super.initState();
    this.vehiculos = List.of(allVehicles);
    print('Prueba');
    for(var auto in _autosList){
      print(auto);
    }
    setState(() {
      
    });
  }
  
  


  Widget build(BuildContext context) {
    return Row(
      children: [
        (MediaQuery.of(context).size.width >= 1200)
            ? Flexible(flex: 2, child: SideLayout())
            : Container(),
        Spacer(),
        Expanded(
            flex: 8,
            child: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.local_parking,
                        size: 90,
                      ),
                      Text(
                        'Park-iT Now',
                        style: TextStyle(
                          color: AppColors.primary,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Expanded(child: Container()),
                      Material(
                              child: MyDropDownButton(),
                            )
                    ],
                  ),
                  SizedBox(height: 30,),
                  Row(
                    
                    children: [
                      Text('Registro de vehículos',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: AppColors.primary,
                            fontSize: 30,
                          )),
                      Expanded(child: Container()),
                      StreamBuilder<DateTime>(
                  stream: hora,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Cargando hora...',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: AppColors.primary,
                            fontSize: 30,
                          ));
                    } else {
                      final horaFormateada =
                          DateFormat('HH:mm:ss').format(DateTime.now());
                      return Text(horaFormateada,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: AppColors.primary,
                            fontSize: 30,
                          ));
                    }
                  },
                ),
                Expanded(child: Container()),
                StreamBuilder<DateTime>(
                  stream: fecha,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Cargando fecha...',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: AppColors.primary,
                            fontSize: 30,
                          ));
                    } else {
                      final fechaFormateada =
                          DateFormat('dd/MM/yyyy').format(DateTime.now());
                      return Text(fechaFormateada,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: AppColors.primary,
                            fontSize: 30,
                          ));
                    }
                  },
                ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 500,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: (){
                            buttonColor2 = AppColors.primary;
                            buttonColor1 = Colors.white;
                            setState(() {
                              reg_button = true;
                            });
                          }, 
                          child: Text('Registro de reservas', style: TextStyle(color: buttonColor1),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(35))),
                            
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 500,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: (){
                            buttonColor2 = Colors.white;
                            buttonColor1 = AppColors.primary;
                            setState(() {
                              reg_button = false;
                            });
                          }, 
                          child: Text('Registro de vehículos', style: TextStyle(color: buttonColor2)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor1,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(35))),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: 1000,
                    child: Material(
                      child:  reg_button ? SingleChildScrollView( scrollDirection: Axis.vertical, child: _tablaRegistroReservas()) : SingleChildScrollView( scrollDirection: Axis.vertical, child: _tablaRegistroVehiculos()),
                    ) ,
                  )
                ],
              ),
            )),
        Spacer(),
      ],
    );
  }
  Widget _tablaRegistroReservas(){
    final columns = ['Patente', 'Usuario', 'Hora Inicio', 'Tarifa','Estado', 'Opciones'];

    return DataTable(
      columns: getColumns(columns),
      rows: _reservasList.map((_reservasList) {
        print(getUsuario(_reservasList['usuario']));
  
        Timestamp t = _reservasList['hora'];
        DateTime d = t.toDate();
            return DataRow(
              cells: <DataCell>[
                DataCell(
                  Text(_reservasList['patente'].toString()),
                ),
                DataCell(
                  FutureBuilder(future: getUsuario(_reservasList['usuario']), 
                  builder: (context,snapshot){
                    String? nombre = snapshot.data;
                    return Text(nombre.toString());
                  }),
                  
                ),
                DataCell(
                  Text(DateFormat('HH:mm').format(d)),
                ),
                DataCell(
                  Text('\$ ${formatCurrency(_reservasList['tarifaCLP'])}'),
                ),
                DataCell(
                  Text('En Curso'),
                ),
                DataCell(
                  Row(
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.arrow_circle_up, color: Colors.green)),
                      IconButton(onPressed: (){}, icon: Icon(Icons.arrow_circle_down, color: Colors.red))
                      
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
      sortColumnIndex: sortColumnIndex,
      sortAscending: isAscending,
    );
  }
  void obtenerReservasEst(String? uid) async{
    DocumentReference estRef = FirebaseFirestore.instance.collection('estacionamientos').doc(uid);
    DocumentSnapshot estSnapshot = await estRef.get();
    if(estSnapshot.exists){
      List<dynamic> referenciasA = estSnapshot['reservas'];
      print('Referencias a la collecion reservas: ');
      for( var referencias in referenciasA ){
        DocumentReference reservaRef = referencias;

        DocumentSnapshot reservaSnap = await reservaRef.get();
        if(reservaSnap.exists){
          Map<String, dynamic> datosReserva = reservaSnap.data() as Map<String, dynamic>;
          _reservasList.add(datosReserva);
        

        }
      }
      obtenerReservasId(uid);
    }else {
      print('El estacionamiento con el UID especificado no existe.');
    }
  }
  void obtenerReservasId(String? uid) async{
    DocumentReference estRef = FirebaseFirestore.instance.collection('estacionamientos').doc(uid);
    DocumentSnapshot estSnapshot = await estRef.get();
    if(estSnapshot.exists){
      List<dynamic> referenciasA = estSnapshot['reservas'];
      print('Referencias a la collecion reservas: ');
      for( var referencias in referenciasA ){
        DocumentReference reservaRef = referencias;

        DocumentSnapshot reservaSnap = await reservaRef.get();
        if(reservaSnap.exists){
          
          _reservasId.add(reservaSnap.id);
        

        }
      }
      for(var auto in _reservasId){
        print('ID reserva:  $auto');
      }
    }else {
      print('El estacionamiento con el UID especificado no existe.');
    }
  }
   void obtenerAutosEst(String? uid) async{
    _autosList.clear();
    print('Longitud de _autosList después de la operación: ${_autosList.length}');
    DocumentReference estRef = FirebaseFirestore.instance.collection('estacionamientos').doc(uid);
    DocumentSnapshot estSnapshot = await estRef.get();
    if(estSnapshot.exists){
      List<dynamic> referenciasA = estSnapshot['autos'];
      print('Referencias a la collecion Autos: ');
      print('Longitud de _autosList después de la operación: ${_autosList.length}');
      for( var i = 0; i <referenciasA.length; i++ ){
        DocumentReference autoRef = referenciasA[i];

        DocumentSnapshot autoSnap = await autoRef.get();
        
        if(autoSnap.exists){
          Map<String, dynamic> datosAuto = autoSnap.data() as Map<String, dynamic>;
          _autosList.add(datosAuto);
         
        }
      }
      print('Longitud de _autosList después de la operación: ${_autosList.length}');
      print('Prueba');
      for(var auto in _autosList){
        print(auto);
      }
    }else {
      print('El estacionamiento con el UID especificado no existe.');
    }
  }
  String formatCurrency(double value) {
    // Utiliza NumberFormat para formatear el valor como moneda
    final formatter = NumberFormat.currency(locale: 'es_CL', symbol: '\$');
    return formatter.format(value);
  }
  Widget _tablaRegistroVehiculos(){
    final columns = ['Marca', 'Color', 'Patente', 'Hora Inicio', '¿Es reserva?', 'Opciones'];

    return DataTable(
      columns: getColumns(columns),
      rows: _autosList.map((Map<String, dynamic> _autosList) {
        Timestamp t = _autosList['hora_entrada'];
        DateTime d = t.toDate();
            return DataRow(
              cells: <DataCell>[
                
                DataCell(
                  Text(_autosList['marca'].toString().toUpperCase()),
                ),
                DataCell(
                  Text(_autosList['color'].toString()),
                ),
                DataCell(
                  Text(_autosList['patente'].toString()),
                ),
                DataCell(
                  Text(DateFormat('HH:mm').format(d)),
                ),
                DataCell(
                  _autosList['isReserva']==true ? Text('Si') : Text('No'),
                ),
                DataCell(
                  _autosList['isReserva'] ? Center(
                    child: IconButton(onPressed: () async{
                      DocumentReference usuario;
                      for( var i = 0; i < _reservasList.length; i++ ){
                        
                        if(_reservasList[i]['patente'] == _autosList['patente']){
                          usuario = _reservasList[i]['usuario'];
                          print(usuario.id);
                          SharedPreferences pref = await SharedPreferences.getInstance();
                          pref.setString('id_automovilista', usuario.id);
                          pref.setString('marca', _autosList['marca']);
                          pref.setString('patente', _autosList['patente']);
                          
                        }
                      }
                      
                      Navigator.pushNamed(context, 'report');
                    }, icon: Icon(Icons.report)
                  )
                  ): Container(),
                ),
              ],
            );
          }).toList(),
      sortColumnIndex: sortColumnIndex,
      sortAscending: isAscending,
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
            onSort: (columnIndex, ascending) {
              onSort(columnIndex, ascending);
            },
          ))
      .toList();
List<DataRow> getRows(List<Vehiculo> vehiculos) {
  return vehiculos.map((Vehiculo vehiculo) {
    return DataRow(
      cells: [
        DataCell(Text(vehiculo.modelo)),
        DataCell(Text(vehiculo.patente)),
        DataCell(Text(vehiculo.start.toString())),
        DataCell(Text(vehiculo.estado)),
        DataCell(
          Row(
            children: [
              IconButton(onPressed: (){}, icon: Icon(Icons.arrow_circle_up, color: Colors.green)),
              IconButton(onPressed: (){}, icon: Icon(Icons.arrow_circle_down, color: Colors.red))
              
            ],
          ),
        ),
      ],
    );
  }).toList();
}

  // List<DataRow> getRows(List<Vehiculo> vehiculos) => vehiculos.map((Vehiculo vehiculo) {
  //       final cells = [vehiculo.modelo, vehiculo.patente, vehiculo.start, vehiculo.end, vehiculo.estado, Row(
  //         children: [
  //           ElevatedButton(onPressed: (){}, child: Icon(Icons.arrow_circle_up, color: Colors.green,)),
  //           ElevatedButton(onPressed: (){}, child: Icon(Icons.arrow_circle_down, color: Colors.green,)),
  //         ],
  //       )];
  //       return DataRow(cells: getCells(cells));
  //     }).toList();
  List<DataRow> getRowsVehiculos(List<Vehiculo> vehiculos) {
  return vehiculos.map((Vehiculo vehiculo) {
    return DataRow(
      cells: [
        DataCell(Text(vehiculo.modelo)),
        DataCell(Text(vehiculo.patente)),
        DataCell(Text(vehiculo.start.toString())),
        DataCell(Text(vehiculo.estado)),
        DataCell(Center(child: IconButton(onPressed: (){Navigator.pushNamed(context, 'report');}, icon: Icon(Icons.report)))),
      ],
    );
  }).toList();
}
  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void onSort(int columnIndex, bool ascending) {
    vehiculos.sort((vehiculo1, vehiculo2) {
      switch (columnIndex) {
        case 0:
          return compareString(ascending, vehiculo1.modelo, vehiculo2.modelo);
        case 1:
          return compareString(ascending, vehiculo1.patente, vehiculo2.patente);
        case 2:
          return compareDateTime(ascending, vehiculo1.start, vehiculo2.start);
        
        case 3:
          return compareString(ascending, vehiculo1.estado, vehiculo2.estado);
        default:
          return 0;
      }
    });

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String a, String b) {
    return ascending ? a.compareTo(b) : b.compareTo(a);
  }
  int compareDateTime(bool ascending, DateTime a, DateTime b) {
    return ascending ? a.compareTo(b) : b.compareTo(a);
  }
}

