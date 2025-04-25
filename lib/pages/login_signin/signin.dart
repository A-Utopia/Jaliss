import 'package:ebook22/customwidgets/password_field.dart';
import 'package:ebook22/pages/allpages.dart';
import 'package:ebook22/pages/login_signin/login.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final Color backgroundColor = const Color(0xFF092531);

  final Color inputColor = const Color(0x0Fffffff);
  final Color ButtonColor = const Color(0xff1D3E4C);

  bool checked = false;

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      
      contentPadding: EdgeInsets.only(left:20),
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white60),
      filled: true,
      fillColor: inputColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(style: BorderStyle.solid,color: Color(0xffB7BBBD)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 40),
              Text(
                'Create an account',
                style: TextStyle(
                    color: Color(0xfffef7f5),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Satoshi-Bold'),
              ),
              Row(
                children: [
                  Text("Already have an account?",
                      style: TextStyle(color: Color(0xfffef7f5),fontFamily: 'Satoshi-Regular')),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      'Sign in',
                      style: TextStyle(color: Color(0xff1D61EF),fontFamily: 'Satoshi-Regular'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                          decoration: _inputDecoration("First Name"),
                          style: TextStyle(color: Colors.white,fontFamily: 'Satoshi-Regular'))),
                  SizedBox(width: 12),
                  Expanded(
                      child: TextFormField(
                          decoration: _inputDecoration("Last Name"),
                          style: TextStyle(color: Colors.white,fontFamily: 'Satoshi-Regular'))),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: _inputDecoration("email"),
                style: TextStyle(color: Colors.white,fontFamily: 'Satoshi-Regular'),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: _inputDecoration("user name"),
                style: TextStyle(color: Colors.white,fontFamily: 'Satoshi-Regular'),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: _inputDecoration("Phone number"),
                style: TextStyle(color: Colors.white,fontFamily: 'Satoshi-Regular'),
              ),
              SizedBox(height: 16),
              PasswordField('password'),
              // TextFormField(
              //   obscureText: true,
              //   decoration: _inputDecoration("password"),
              //   style: TextStyle(color: Colors.white,fontFamily: 'Satoshi-Regular'),
              // ),
              SizedBox(height: 16),
              PasswordField('confirm password'),
              // TextFormField(
              //   obscureText: true,
              //   decoration: _inputDecoration("confirm password"),
              //   style: TextStyle(color: Colors.white,fontFamily: 'Satoshi-Regular'),
              // ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Allpages(),));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ButtonColor,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1202)),
                ),
                child: Text('Sign up',style: TextStyle(fontFamily: 'Satoshi-Bold',color: Colors.white),),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(value: checked, onChanged: (value) {
                        setState(() {
                          checked = value!;
                        });
                      }),
                      Text('Remember me',
                          style: TextStyle(color: Colors.white,fontFamily: 'Satoshi-Regular')),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.white,fontFamily: 'Satoshi-Regular'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: Divider(color: Color(0xffB7BBBD))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Or sign up with",
                        style: TextStyle(color: Color(0xffB7BBBD),fontFamily: 'Satoshi-Regular')),
                  ),
                  Expanded(child: Divider(color: Color(0xffB7BBBD))),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/Icons/google.png',
                      height: 20,
                    ),
                    label: Text("Google"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ButtonColor,
                      foregroundColor: Colors.white,
                      minimumSize: Size(130, 45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28)),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Image.asset('assets/Icons/facebook.png',height: 18,fit: BoxFit.fitWidth,),
                    label: Text("Facebook",style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ButtonColor,
                      minimumSize: Size(130, 45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
