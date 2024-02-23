import 'package:flutter/material.dart';

class Ayuda extends StatelessWidget {
  const Ayuda({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ayuda y Soporte')),
      body: Column(
        children: [
          Column(
            children: [
              Container(margin:EdgeInsets.symmetric(vertical: 10, horizontal: 2),child: Text('¿Tienes dudas sobre las reservas?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),)),
              Container(margin:EdgeInsets.symmetric(vertical: 10, horizontal: 20),child: Text('Para hacer una reserva correctamente debes seleccionar el marcador en el mapa e ingresar los datos que te piden, la "Patente" del vehiculo que utilizarás y la "Cantidad de Horas" que quieres reservar.', textAlign: TextAlign.justify,)),
              Container(margin:EdgeInsets.symmetric(vertical: 10, horizontal: 2),child: Text('Tips:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),textAlign: TextAlign.start,)),
              Container(margin:EdgeInsets.symmetric(vertical: 10, horizontal: 20),child:Text('Una vez seleccionada la Patente e introducida la Cantidad de Horas, presiona denuevo en la cantidad de horas para actualizar la vista.', textAlign: TextAlign.justify,)),
            ],

          ),
          Column(
            children: [
              Container(margin:EdgeInsets.symmetric(vertical: 10, horizontal: 2),child: Text('Contactanos si necesitas mas ayuda', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),)),
              Container(margin:EdgeInsets.symmetric(vertical: 10, horizontal: 20),child:Text('Teléfono: 9 3384 2652',textAlign: TextAlign.start,)),
              Container(margin:EdgeInsets.symmetric(vertical: 10, horizontal: 20),child:Text('Correo Electrónico: parkit-now@correo.cl',textAlign: TextAlign.start,)),
            ],
          ),
        ],
      )
    );
  }
}