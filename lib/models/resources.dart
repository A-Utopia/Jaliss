// class Resources {
//   static List <String> covers = ['cover.jpeg','cover2.jpg','cover3.png'];
//   static List <String> books = ['Practical Electronics','The 4-Hour Workweek','Start with Why'];
//   static List<int> pages = [1200,544,200];
//   int numOfItems = covers.length;
// }

import 'package:flutter/material.dart';

List<BrowseModel> browseM = [
  BrowseModel(img: 'sushiimg.png',libraryName: 'Z-Library',numOfUsers: '1M',numOfBooks: '10M',link: 'https://z-lib.id/'),
  BrowseModel(img: 'paintimg.png',libraryName: 'Lib Gen',numOfUsers: '1M',numOfBooks: '10M',link: 'https://libgen.is/'),
  
];



List<BookModel> readingBM = [
  BookModel(cover: 'cover4.jpg',bookName: 'Work Rules!',pages: 416 ,progress: 0.1),
  BookModel(cover: 'cover5.jpg',bookName: 'The Art of Electronics',pages:522,progress: 0.5),
  BookModel(cover: 'cover6.jpg',bookName: 'Beautiful Ruins',pages: 368,progress: 0.9),
  BookModel(cover: 'cover7.jpg',bookName: 'The C Programming',pages: 288,progress: 0.7),
  BookModel(cover: 'cover4.jpg',bookName: 'Work Rules!',pages: 416 ,progress: 0.1),
  BookModel(cover: 'cover5.jpg',bookName: 'The Art of Electronics',pages:522,progress: 0.5),
  BookModel(cover: 'cover6.jpg',bookName: 'Beautiful Ruins',pages: 368,progress: 0.9),
  BookModel(cover: 'cover7.jpg',bookName: 'The C Programming',pages: 288,progress: 0.7),
];

List<BookModel> bookmarkBM = [
  BookModel(cover: 'cover4.jpg',bookName: 'Work Rules!',pages: 416 ,progress: 0.1),
  BookModel(cover: 'cover5.jpg',bookName: 'The Art of Electronics',pages:522,progress: 0.5),
  BookModel(cover: 'cover6.jpg',bookName: 'Beautiful Ruins',pages: 368,progress: 0.9),
  BookModel(cover: 'cover7.jpg',bookName: 'The C Programming',pages: 288,progress: 0.7),
];


class BrowseModel {
  String? img;
  String? libraryName;
  String? numOfUsers;
  String? numOfBooks;
  String? link;

  BrowseModel({this.img,this.libraryName,this.numOfUsers,this.numOfBooks,this.link});
 
}

class BookModel {
  String? cover;
  String? bookName;
  int? pages;
  double? progress;

  BookModel({this.cover,this.bookName,this.pages,this.progress});
}


class UserData {
  String? userName;
  String? userEmail;
  String? userAvatar;

  UserData({this.userName,this.userEmail,this.userAvatar});
}


List<UserData> userData = [
  UserData(userName: 'User',userEmail: 'user@gmail.com',userAvatar: 'avatar.jpg'),
  UserData(userName: 'User',userEmail: 'user@gmail.com',userAvatar: 'avatar.jpg'),
];