import 'package:flutter/material.dart';
import 'package:parkit_now/utils/colors.dart';

TextField reusableTextField(String text, IconData icon, bool isPasswordType, TextEditingController controller){
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    style: TextStyle(color: Colors.blue.shade900.withOpacity(0.9)),
    decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(25.0), left: Radius.circular(25.0)),
              
            ),
            prefixIcon: Icon(icon, color: Colors.blue.shade900),
            labelText: text,
            labelStyle: TextStyle(
              fontSize: 20,
            ),
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            fillColor: Colors.white.withOpacity(0.9)
          ),
    keyboardType: isPasswordType ? TextInputType.visiblePassword : TextInputType.emailAddress,
  );
}