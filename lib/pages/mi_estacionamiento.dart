import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkit_now/utils/colors.dart';
import 'package:parkit_now/widgets/web_side_layout.dart';

class MiEstacionamiento extends StatefulWidget {
  const MiEstacionamiento({super.key});

  @override
  State<MiEstacionamiento> createState() => _MiEstacionamientoState();
}

class _MiEstacionamientoState extends State<MiEstacionamiento> {
  late Stream<DateTime> fecha;
  late Stream<DateTime> hora;
  @override
  void initState() {
    
    hora = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());
    fecha = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());

    super.initState();
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
              SizedBox(
                height: 30,
              ),
              Row(
                    children: [
                      Text('Mi Estacionamiento',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: AppColors.primary,
                            fontSize: 30,
                          )),
                      Expanded(child: Container()),
                      StreamBuilder<DateTime>(
                        stream: hora,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
              SizedBox(
                height: 70,
              ),
              Container(
                
                child: Column(
                  children: [
                    Container(
                      height: 90,
                      width: 500,
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.pushNamed(context, 'edit-est');
                        }, 
                        child: Text('Editar estacionamiento', style:TextStyle(
                          fontSize: 30
                        )),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          backgroundColor: Colors.grey[400]
                        )
                      )
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: 90,
                      width: 500,
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.pushNamed(context, 'edit-serv');
                        }, 
                        child: Text('Editar servicios adicionales', style:TextStyle(
                          fontSize: 30
                        )),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          backgroundColor: Colors.grey[400]
                        )
                      )
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: 90,
                      width: 500,
                      child: ElevatedButton(
                        onPressed: (){}, child: Text('Ver estacionamiento', style:TextStyle(
                          fontSize: 30
                        )),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          backgroundColor: Colors.grey[400]
                        )
                      )
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ),    
              
              ],
            ),
          )
        ),
        Spacer(),
      ],
    );
  }
}