import 'package:ebook22/customwidgets/bookmarks_container.dart';
import 'package:ebook22/models/resources.dart';
import 'package:ebook22/notifiers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: bmchangedlengthnotifier,
      builder: (context, value, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView.builder(
              itemCount: bookmarkBM.length,
              itemBuilder: (context, index) {
                return BookmarkContainer(index);
              },
            ),
          ),
        );
      }
    );
  }
}
