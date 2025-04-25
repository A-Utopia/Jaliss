import 'package:ebook22/notifiers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}


var underlineDecoration = Container(
  margin: const EdgeInsets.only(top: 9),
  width: 30,
  height: 1,
  decoration: const BoxDecoration(
    color: Colors.white70,
    boxShadow: [
      BoxShadow(
        color: Colors.white70,
        blurRadius: 8,
        spreadRadius: 1.2,
        offset: Offset(0, -5),
      ),
    ],
  ),
);

class _BottomnavbarState extends State<Bottomnavbar> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedpagenotifier,
      builder: (context, selectedIndex, child) {
        return ClipPath(
          clipper: CustomClipPath(),
          child: Container(
            height: 90,
            clipBehavior: Clip.antiAlias,
            decoration:  BoxDecoration(
              
            ),
            child: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    activeIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          CupertinoIcons.book_fill,
                        ),
                        underlineDecoration
                      ],
                    ),
                    icon: const Icon(CupertinoIcons.book),
                    label: 'Library'),
                BottomNavigationBarItem(
                  activeIcon: Column(
                    children: [
                      const Icon(CupertinoIcons.clock_fill),
                      underlineDecoration
                    ],
                  ),
                  icon: const Icon(CupertinoIcons.clock),
                  label: "History",
                ),
                BottomNavigationBarItem(
                  activeIcon: Column(
                    children: [
                      const Icon(CupertinoIcons.compass_fill),
                      underlineDecoration
                    ],
                  ),
                  icon: const Icon(CupertinoIcons.compass),
                  label: "Browse",
                ),
                BottomNavigationBarItem(
                  activeIcon: Column(
                    children: [
                      const Icon(CupertinoIcons.person_circle_fill),
                      underlineDecoration
                    ],
                  ),
                  icon: const Icon(CupertinoIcons.person_circle),
                  label: "Profile",
                ),
              ],
              backgroundColor:  const Color(0xff113342),
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: Colors.white70,
              selectedItemColor: Colors.white,
              selectedIconTheme: const IconThemeData(
                size: 35,
                // shadows: <Shadow>[
                //   Shadow(
                //     color: const Color.fromARGB(179, 222, 217, 217),
                //     blurRadius: 20.0,
                //     offset: Offset(0, 10),
                //   ),
                // ],
              ),
              iconSize: 26,
              showUnselectedLabels: true,
              showSelectedLabels: false,
              onTap: (value) {
                selectedpagenotifier.value = value;
              },
              currentIndex: selectedIndex,
              
            ),
          ),
        );
      },
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    final path = Path();

    path.lineTo(0, h-35);
    path.quadraticBezierTo(5, h-5, 30, h-5);
    path.lineTo(w-30, h-5);
    path.quadraticBezierTo(w-5, h-5, w, h-35);
    path.lineTo(w, 40);
    path.quadraticBezierTo(w - 5, 15, w - 30, 10);
    path.quadraticBezierTo(w / 2, -10, 30, 10);
    path.quadraticBezierTo(5, 15, 0, 40);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
