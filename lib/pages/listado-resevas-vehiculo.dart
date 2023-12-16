import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkit_now/data/get_estacionamiento_data.dart';
import 'package:parkit_now/data/get_user_data.dart';
import 'package:parkit_now/data/vehiculos.dart';
import 'package:parkit_now/modelos/vehiculo.dart';
import 'package:parkit_now/utils/colors.dart';
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

  String? uid;
  bool reg_button = true;
  late List<Vehiculo> vehiculos;
  int? sortColumnIndex;
  bool isAscending = false;
  Color buttonColor1 = Colors.white;
  Color? buttonColor2 = AppColors.primary;
  late List<Map<String, dynamic>> _autosList;
  late List<Map<String, dynamic>> _reservasList;

  Future getUID() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('userId');
    print(action);
    uid = action;
    
  }
  Future<void> _getAutosFromFirebase() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('autos').get();

    setState(() {
      _autosList = querySnapshot.docs.map((DocumentSnapshot document) {
        Map<String,dynamic> data = document.data() as Map<String, dynamic>;
        data['id']=document.id;
        return data;
      }).toList();
    });
  }
  Future<void> _getReservasFromFirebase() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('reservas').get();
    setState(() {
      _reservasList = querySnapshot.docs.map((DocumentSnapshot document) {
        Map<String,dynamic> data = document.data() as Map<String, dynamic>;
        CollectionReference users = FirebaseFirestore.instance.collection('usuarios');

        DocumentReference userRef = data['usuario'];
        data['id']=document.id;
        data['usuario']= userRef.id;
        print(userRef.id);
        return data;
      }).toList();
    });
  }
  Future getAutos() async{

  }
  @override
  void initState() {
    getUID();
    _autosList =[];
    _reservasList =[];
    _getAutosFromFirebase();
    _getReservasFromFirebase();
    hora = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());
    fecha = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());

    super.initState();
    this.vehiculos = List.of(allVehicles);
  }
  
  


  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(flex: 2, child: SideLayout()),
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
                      Column(
                        children: [
                          Text('Juan Pérez',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: AppColors.primary,
                                  fontSize: 20)),
                          Text('Encargado',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.grey,
                                  fontSize: 15))
                        ],
                      ),
                      Image(
                        image: AssetImage('assets/images/user.png'),
                        width: 50,
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
    final columns = ['ID', 'Usuario', 'Hora Inicio', 'Tarifa','Estado', 'Opciones'];

    return DataTable(
      columns: getColumns(columns),
      rows: _reservasList.map((Map<String, dynamic> data) {
  
        Timestamp t = data['hora'];
        DateTime d = t.toDate();
            return DataRow(
              cells: <DataCell>[
                DataCell(
                  Text(data['id'].toString()),
                ),
                DataCell(
                  GetUserData(documentId: data['usuario']).getUserName(data['usuario']),
                  
                ),
                DataCell(
                  Text(DateFormat('HH:mm').format(d)),
                ),
                DataCell(
                  Text(data['tarifa'].toString()),
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
  Widget _tablaRegistroVehiculos(){
    final columns = ['ID','Vehículo', 'Patente', 'Hora Inicio', 'Opciones'];

    return DataTable(
      columns: getColumns(columns),
      rows: _autosList.map((Map<String, dynamic> data) {
        Timestamp t = data['hora_entrada'];
        DateTime d = t.toDate();
            return DataRow(
              cells: <DataCell>[
                DataCell(
                  Text(data['id'].toString()),
                ),
                DataCell(
                  Text(data['marca'].toString()),
                ),
                DataCell(
                  Text(data['patente'].toString()),
                ),
                DataCell(
                  Text(DateFormat('HH:mm').format(d)),
                ),
                DataCell(Center(child: IconButton(onPressed: (){Navigator.pushNamed(context, 'report');}, icon: Icon(Icons.report)))),
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

