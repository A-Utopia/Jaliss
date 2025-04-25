import 'package:ebook22/customwidgets/history_app_bar.dart';
import 'package:ebook22/pages/History_page/bookmarks.dart';
import 'package:ebook22/pages/History_page/reading_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: CustomAppBar(),
          body: Column(
            children: [
              SizedBox(height: 14),
              const TabBar(
              padding: EdgeInsets.symmetric(horizontal: 30),
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              labelStyle: TextStyle(fontSize: 16),
              indicatorWeight: 3,
              tabs: [
                Tab(
                  text: 'Reading',
                ),
                Tab(
                  text: 'Bookmarks',
                ),
              ],
            ),
              Expanded(
                child: const TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    ReadingPage(),
                    BookmarksPage(),
                  ],
                ),
              ),
            ],
          ),
          
        ),
      );
  }
}