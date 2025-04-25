// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PasswordField extends StatefulWidget {
  PasswordField(this.hint,{super.key});
  String? hint;
  @override
  State<PasswordField> createState() => _PasswordFieldState();
}
  
class _PasswordFieldState extends State<PasswordField> {
  
  
  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    
    return TextFormField(
      obscureText: !isPasswordVisible,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: IconButton(
            color: Colors.white,
              onPressed: () {setState(() {
                isPasswordVisible = !isPasswordVisible;
              });},
                icon: isPasswordVisible
                  ? const ImageIcon(AssetImage('assets/Icons/View.png'))
                  : const ImageIcon(AssetImage('assets/Icons/Hide.png')),
        ),
        ),

        contentPadding: EdgeInsets.only(left: 20,),
        hintText: widget.hint,
        hintStyle:
            TextStyle(color: Colors.white60, fontFamily: 'Satoshi-Regular',),
        filled: true,
        fillColor: Color(0x0fffffff),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(style: BorderStyle.solid),
        ),
      ),
    );
  }
}
