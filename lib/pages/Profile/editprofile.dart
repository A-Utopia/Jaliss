import 'package:ebook22/models/resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff092534),
      appBar: AppBar(
        backgroundColor: Color(0xff092534),
        elevation: 0,
        leading: IconButton(
          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color(0xff113342))),
          icon : Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () {
                Navigator.pop(context);
              },),
        title: Text('Edit Profile', style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: 'Satoshi-Bold',),),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: IconButton(
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color(0xff113342))),
              icon : Icon(CupertinoIcons.checkmark_alt, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
            },),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            SizedBox(height: 30),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/avatar.jpg'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Color(0xff113342),
                      child: ImageIcon(AssetImage('assets/Icons/edit.png'), size: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  Text(
                    userData[0].userName!,
                    style: TextStyle(color: Colors.white, fontSize: 20,fontFamily: 'Satoshi-Regular'),
                  ),
                  Text(
                    userData[0].userEmail!,
                    style: TextStyle(color: Colors.white70,fontFamily: 'Satoshi-Regular'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            _buildTextField('Full Name', 'User',TextInputType.name),
            SizedBox(height: 20),
            _buildTextField('User Name', 'User Name',TextInputType.name),
            SizedBox(height: 20),
            _buildTextField('Email', 'user@gmail.com',TextInputType.emailAddress),
            SizedBox(height: 20),
            _buildTextField('Phone number', 'number ',TextInputType.phone),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextInputType type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 14,fontFamily: 'Satoshi-Regular')),
        SizedBox(height: 8),
        TextField(
          keyboardType: type,
          style: TextStyle(color: Colors.white,),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white54,fontFamily: 'Satoshi-Regular'),
            filled: true,
            fillColor: Color(0xFF1C3C4B),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
