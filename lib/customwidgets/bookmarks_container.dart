// ignore_for_file: must_be_immutable

import 'package:ebook22/models/resources.dart';
import 'package:ebook22/notifiers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';

class BookmarkContainer extends StatefulWidget {
  BookmarkContainer(this.index,{super.key});
  int index=0;
  @override
  State<BookmarkContainer> createState() => _BookmarkContainerState();
}

class _BookmarkContainerState extends State<BookmarkContainer> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xff113342),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/images/${bookmarkBM[widget.index].cover}', // from user
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
                          bookmarkBM[widget.index].bookName!, // from user
                          style: TextStyle(fontSize: 18,fontFamily: 'Satoshi-Bold'),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          'Pages: ${bookmarkBM[widget.index].pages}', // from user
                          style: TextStyle(fontSize: 14,fontFamily: 'Satoshi-Light'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        LinearPercentIndicator(
                            percent: bookmarkBM[widget.index].progress!,
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
                      bookmarkBM.removeAt(widget.index);
                      bmchangedlengthnotifier.value -= 1;
                     
                    },
                  icon: const Icon(CupertinoIcons.bookmark_fill,color: Color(0xffE6E6E6),),
                ),
              )
            ],
          ),
        ),
      );
  }
}