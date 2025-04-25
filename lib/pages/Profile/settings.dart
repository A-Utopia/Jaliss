import 'package:ebook22/pages/login_signin/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  bool isNotification = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff092534),
      appBar: AppBar(
        backgroundColor: Color(0xff092534),
        title: Text(
          'Settings',
          style: TextStyle(fontFamily: 'Satoshi-Bold'),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leadingWidth: 70,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(CupertinoIcons.back),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Color(0xff113342),
            ),
            minimumSize: WidgetStatePropertyAll(Size(44,44),),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListView(
            shrinkWrap: true,
            cacheExtent: 100,
            itemExtent: 60,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              settingsCountainer(ImageIcon(AssetImage('assets/Icons/User_circle.png'),color: Colors.white,), 'Manage accounts',
                  Icon(Icons.chevron_right)),
              settingsCountainer(
                  ImageIcon(AssetImage('assets/Icons/Language.png'),color: Colors.white,), 'Language', Icon(Icons.chevron_right)),
              settingsCountainer(
                  ImageIcon(AssetImage('assets/Icons/Notification.png'),color: Colors.white,),
                  'Notification',
                  Switch(
                    value: isNotification,
                    onChanged: (value) => setState(() {
                      isNotification = !isNotification;
                    }),
                    activeColor: Colors.white,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color(0xff2E5668D4),
                  )),
              settingsCountainer(
                  ImageIcon(AssetImage('assets/Icons/moon.png'),color: Colors.white,),
                  'Dark mode',
                  Switch.adaptive(
                    value: isDarkMode,
                    onChanged: (value) => setState(() {
                      isDarkMode = !isDarkMode;
                    }),
                    activeColor: Colors.white,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color(0xff2E5668D4),
                  )),
              settingsCountainer(
                ImageIcon(AssetImage('assets/Icons/Lock.png'),color: Colors.white,),
                'Change password',
                Icon(Icons.chevron_right),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(),));
                },
                child: settingsCountainer(
                    ImageIcon(AssetImage('assets/Icons/logout1.png'),color: Colors.white,), 'Log out', const SizedBox()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget settingsCountainer(ImageIcon icon, String title, Widget action) {
  return InkWell(
    child: Container(
      height: 80,
      width: 400,
      child: ListTile(
        leading: icon,
        title: Text(title, style: TextStyle(color: Colors.white,fontFamily: 'Satoshi-Regular')),
        trailing: action,
      ),
    ),
  );
}
