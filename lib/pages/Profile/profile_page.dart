import 'package:ebook22/models/resources.dart';
import 'package:ebook22/pages/Profile/editprofile.dart';
import 'package:ebook22/pages/Profile/settings.dart';
import 'package:ebook22/pages/login_signin/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  
  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF092634);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        backgroundColor: backgroundColor,
        title: Text(
          "Profile",
          style: TextStyle(fontSize: 20,fontFamily: 'Satoshi-Bold'),
        ),
        centerTitle: true,
        actions: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFF113B4A),
            child: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfilePage()));
              },
              icon: ImageIcon(AssetImage('assets/Icons/edit.png'),color: Colors.white,),
          ),),
          SizedBox(
            width: 12,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // const SizedBox(height: 20),
            // Top Bar
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: const [
            //       // CircleAvatar(
            //       //   radius: 20,
            //       //   backgroundColor: Color(0xFF113B4A),
            //       //   child: Icon(Icons.arrow_back_ios_new,
            //       //       color: Colors.white, size: 18),
            //       // ),
            //       Text(
            //         "Profile",
            //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            //       ),
            //       CircleAvatar(
            //         radius: 20,
            //         backgroundColor: Color(0xFF113B4A),
            //         child: Icon(Icons.edit, color: Colors.white),
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 30),
            // Profile Picture
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(
                // it was Network image
                "assets/images/${userData[0].userAvatar}",
              ),
            ),
            const SizedBox(height: 15),
            Text(userData[0].userName!,
                style: TextStyle(fontSize: 20,fontFamily: 'Satoshi-Bold')),
            Text(userData[0].userEmail!, style: TextStyle(color: Colors.grey,fontFamily: 'Satoshi-Regular')),
            const SizedBox(height: 30),
            // Buttons
             ProfileButton(onChangeScreen:(){Navigator.push(context, MaterialPageRoute(builder: (context)=> SettingsPage(),));},icon: ImageIcon(AssetImage('assets/Icons/Setting_alt.png'),color: Colors.white,), text: "Settings"),
             ProfileButton(icon: ImageIcon(AssetImage('assets/Icons/Cancel.png'),color: Colors.white), text: "Clear data"),
            // ProfileButton(icon: ImageIcon(AssetImage('assets/icons/Cancel.png'),color: Colors.white), text: "Clear cache"),
             ProfileButton(icon: ImageIcon(AssetImage('assets/Icons/about.png'),color: Colors.white,size: 27,), text: "About"),
             ProfileButton(icon: ImageIcon(AssetImage('assets/Icons/logout1.png'),color: Colors.white,), text: "Log out",onChangeScreen: (){Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage(),));},),
          ],
        ),
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  final ImageIcon icon;
  final String text;
  final onChangeScreen;

  const ProfileButton({this.onChangeScreen,super.key, required this.icon, required this.text,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF113B4A),
          borderRadius: BorderRadius.circular(30),
        ),
        child: ListTile(
          leading: icon,
          title: Text(text, style: const TextStyle(color: Colors.white,fontFamily: 'Satoshi-Regular')),
          onTap: onChangeScreen,
        ),
      ),
    );
  }
}
