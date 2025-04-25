// ignore_for_file: unused_import

import 'package:ebook22/customwidgets/bottomnavbar.dart';
import 'package:ebook22/notifiers.dart';
import 'package:ebook22/pages/Browse_page/browse_page.dart';
import 'package:ebook22/pages/History_page/history_page.dart';
import 'package:ebook22/pages/Profile/editprofile.dart';
import 'package:ebook22/pages/Profile/settings.dart';
import 'package:ebook22/pages/library_page.dart';
import 'package:ebook22/pages/login_signin/login.dart';
import 'package:ebook22/pages/login_signin/signin.dart';
import 'package:ebook22/pages/Profile/profile_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Widget> pages = [
    const LibraryPage(),
    const HistoryPage(),
    const Browsepage(),
    const ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff092534),
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff092534), brightness: Brightness.dark),
      ),
      home: Scaffold(
        extendBody: true,
        body: LoginPage(),
        // ValueListenableBuilder(
        //   valueListenable: selectedpagenotifier,
        //   builder: (context, selectedPage, child) {
        //     return pages.elementAt(selectedPage);
        //   },
        // ),
        
        // bottomNavigationBar: Bottomnavbar(),
      ),
    );
  }
}
