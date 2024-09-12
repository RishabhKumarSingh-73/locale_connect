
import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final Color borderColor;
  final Color textColor;
  final TextEditingController controller;
  final String hint;
 final bool obscureText;
  const MyTextfield({super.key,required this.textColor, required this.borderColor, required this.controller ,required this.hint, required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0,horizontal: 20),
      padding: const EdgeInsets.all(3),
      child: TextField(
      
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(
            color: textColor,
            fontSize: 20,
          ),
          decoration: InputDecoration(

            
      
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(15))
                ),
      
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey),
      
          ),
                
      
      ),
    );
  }
}