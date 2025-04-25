import 'package:ebook22/models/resources.dart';
import 'package:flutter/material.dart';

ValueNotifier<int> selectedpagenotifier = ValueNotifier(0);

ValueNotifier<int> rchangedlengthnotifier = ValueNotifier(readingBM.length);
ValueNotifier<int> bchangedlengthnotifier = ValueNotifier(browseM.length);
ValueNotifier<int> bmchangedlengthnotifier = ValueNotifier(bookmarkBM.length);