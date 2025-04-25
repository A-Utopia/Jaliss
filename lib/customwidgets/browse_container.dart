// ignore_for_file: must_be_immutable

import 'package:ebook22/models/resources.dart';
import 'package:ebook22/notifiers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';


class BrowseContainer extends StatefulWidget {
  BrowseContainer(this.index,{super.key});
  int index=0;

  @override
  State<BrowseContainer> createState() => _BrowseContainerState();
}

class _BrowseContainerState extends State<BrowseContainer> {


  @override
  Widget build(BuildContext context) {
    return Link(
      uri: Uri.parse(browseM[widget.index].link!),
      builder: (context, followLink) => 
       InkWell(
        onTap: followLink,
        child: Card(
          elevation: 0,
          color: const Color(0xff092534),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/${browseM[widget.index].img}', // from user
                        width: 64,
                        height: 69,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: SizedBox(
                        height: 90,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                          
                            Text(
                              browseM[widget.index].libraryName!, // from user
                              style: const TextStyle(fontSize: 18,fontFamily: 'Satoshi-Bold'),
                            ),
                       
                            const SizedBox(height: 2,),
                            Text(
                              'over ${browseM[widget.index].numOfUsers} user', // from user
                              style: const TextStyle(fontSize: 10,fontFamily: 'Satoshi-Light'),
                            ),
                            
                            Text(
                              'over ${browseM[widget.index].numOfBooks!} book', // from user
                              style: const TextStyle(fontSize: 10,fontFamily: 'Satoshi-Light'),
                            ),
                            
                            const SizedBox(
                              height: 12,
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: IconButton(
                      onPressed: () {
                          browseM.removeAt(widget.index);
                          bchangedlengthnotifier.value -= 1;
                       
                        },
                      icon: const ImageIcon(AssetImage('assets/Icons/delete.png'))
                    ),
                  )
                ],
              ),
            ),
          ),
      ),
    );
  }
}