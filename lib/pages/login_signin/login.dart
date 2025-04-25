import 'package:ebook22/customwidgets/password_field.dart';
import 'package:ebook22/pages/allpages.dart';
import 'package:ebook22/pages/library_page.dart';
import 'package:ebook22/pages/login_signin/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final Color ButtonColor = const Color(0xff1D3E4C);
  bool checked= false;

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xff092534),
    body: SafeArea(
      child: SingleChildScrollView(  // Add this ScrollView
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
            SizedBox(height: 60),
            
            Text(
              'Sign in to your account',
              style: TextStyle(
                  color: Color(0xfffef7f5),
                  fontSize: 24,
                  
                  fontFamily: 'Satoshi-Bold'),
            ),
            Row(
              children: [
                Text("Don’t have one?",
                    style: TextStyle(color: Color(0xfffef7f5),fontFamily: 'Satoshi-Regular')),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpPage(),));
                  },
                  child: Text(
                    'Sign up',
                    style: TextStyle(color: Color(0xff1d61ef),fontFamily: 'Satoshi-Regular'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20),
                hintText: 'username, email or phone number',
                hintStyle: TextStyle(color: Colors.white60,fontFamily: 'Satoshi-Regular'),
                filled: true,
                fillColor: Color(0x0fffffff),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(style: BorderStyle.solid),
                ),
              ),
            ),
            SizedBox(height: 16),
            PasswordField('password'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Allpages(),));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ButtonColor,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              child: Text('Log in',style: TextStyle(color: Colors.white,fontFamily: 'Satoshi-Bold'),),
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
            SizedBox(height: 40),
            Row(
              children: [
                Expanded(child: Divider(color: Color(0xffB7BBBD))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Or login with",
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
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Image.asset('assets/Icons/facebook.png',height: 18,),
                  label: Text("Facebook",style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ButtonColor,
                    minimumSize: Size(130, 45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    ),
    ));
  }
}
