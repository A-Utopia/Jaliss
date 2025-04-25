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


class Allpages extends StatelessWidget {
  Allpages({super.key});

  List<Widget> pages = [
    LibraryPage(),
    const HistoryPage(),
    Browsepage(),
    const ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      extendBody: true,
      body: ValueListenableBuilder(
            valueListenable: selectedpagenotifier,
            builder: (context, selectedPage, child) {
              return pages.elementAt(selectedPage);
            },
          ),
          bottomNavigationBar: Bottomnavbar(),
    );
  }
}