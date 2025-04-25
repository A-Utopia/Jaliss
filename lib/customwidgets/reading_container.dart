import 'package:ebook22/models/resources.dart';
import 'package:ebook22/notifiers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';

class ReadingContainer extends StatefulWidget {
  ReadingContainer(this.index,{super.key});
  int index=0;
  @override
  State<ReadingContainer> createState() => _ReadingContainerState();
}

class _ReadingContainerState extends State<ReadingContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Flexible(
        child: Card(
          
          color: const Color(0xff113342),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/${readingBM[widget.index].cover}', // from user list of images url
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
                        height: 93,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                              Text(
                              readingBM[widget.index].bookName!, // from user list of books
                              style: TextStyle(fontSize: 18,fontFamily: 'Satoshi-Bold'),
                            ),
                            SizedBox(height: 6,),
                            Text(
                              'Pages: ${readingBM[widget.index].pages}', // from user list of # of pages
                              style: TextStyle(fontSize: 14,fontFamily: 'Satoshi-Light'),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
        
                            LinearPercentIndicator(
                              percent: readingBM[widget.index].progress!,
                              lineHeight: 3,
                              progressColor: Colors.blue,
                              barRadius: Radius.circular(3),
                              animation: true,
                              animationDuration: 800,
                              padding: EdgeInsets.symmetric(horizontal: 0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: IconButton(
                      onPressed: () {
                        readingBM.removeAt(widget.index);
                        rchangedlengthnotifier.value -=1;
                      },
                      icon: const Icon(Icons.delete_outlined,color: Color(0xffE6E6E6),),
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