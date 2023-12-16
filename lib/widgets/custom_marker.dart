import 'package:flutter/material.dart';

class CustomMarker extends StatelessWidget {
  final String texto;
  final Color color;
  const CustomMarker({super.key, required this.color, required this.texto});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 75,
      width: 75,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Icon(Icons.arrow_drop_down,
              color: color,
              size: 50,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15),
            padding: EdgeInsets.all(5),
            color: color,
            child: Text(texto, 
            style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}