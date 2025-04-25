import 'package:ebook22/customwidgets/addbutton.dart';
import 'package:ebook22/customwidgets/history_app_bar.dart';
import 'package:ebook22/customwidgets/browse_container.dart';
import 'package:ebook22/notifiers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ebook22/models/resources.dart';

// int numOfItems = Resources.covers.length;

class Browsepage extends StatefulWidget {
  const Browsepage({super.key});

  @override
  State<Browsepage> createState() => _BrowsepageState();
}

final TextEditingController sourceName = TextEditingController();
final TextEditingController sourceLink = TextEditingController();

class _BrowsepageState extends State<Browsepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: const Text(
                'Download from your own source',
                textAlign: TextAlign.left,
                style: TextStyle(
                    
                    color: Colors.white, fontSize: 18, fontFamily: 'Satoshi-Bold'
                    // fontWeight: FontWeight.bold
              
                    ),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: bchangedlengthnotifier,
                builder: (context, value, child) {
                  return ListView.builder(
                    itemCount: browseM.length + 1,
                    itemBuilder: (context, index) {
                      if (index == browseM.length) {
                        return AddbuttonContainer();
                      }
                      return BrowseContainer(index);
                    },
                  );
                },
              ),
            ),
            
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 82.0),
        child: FloatingActionButton(
          backgroundColor: Color(0xFF1D3E4C),
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Color(0xff284d5d),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color(0xff113342))),
                        icon: Icon(CupertinoIcons.back),
                        onPressed: () {
                          Navigator.pop(context);
                          sourceName.clear();
                          sourceLink.clear();
                        },
                      ),
                      Text('New Source',style: TextStyle(fontFamily: 'Satoshi-Bold'),),
                      IconButton(
                        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color(0xff113342))),
                        icon: Icon(CupertinoIcons.checkmark_alt),
                        onPressed: () {
                          browseM.add(BrowseModel(
                            img: 'browseimg1.jpg',
                            libraryName: sourceName.text,
                            numOfBooks: '1M',
                            numOfUsers: '10M',
                            link: sourceLink.text,
                          ));
                          Navigator.pop(context);
                          sourceName.clear();
                          sourceLink.clear();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: sourceLink,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Your link'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0,bottom: 4),
                        child: Text(
                          'Source Name',
                          style: TextStyle(
                              fontFamily: 'Satoshi-Bold', fontSize: 18),
                        ),
                      ),
                      TextField(
                        controller: sourceName,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Ex: Z-Library'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      
    );
    
  }
}
