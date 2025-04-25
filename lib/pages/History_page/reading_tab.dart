import 'package:ebook22/customwidgets/reading_container.dart';
import 'package:ebook22/models/resources.dart';
import 'package:ebook22/notifiers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReadingPage extends StatefulWidget {
  const ReadingPage({super.key});

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: rchangedlengthnotifier,
      builder: (context, value, child) {
        return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView.builder(
          itemCount: readingBM.length,
          itemBuilder: (context, index) {
            return ReadingContainer(index);
          },
        ),
      ),
    );
      },
    );
  }
}
