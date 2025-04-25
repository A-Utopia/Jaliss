// ignore_for_file: unused_element, unnecessary_import, use_build_context_synchronously, avoid_print, unnecessary_to_list_in_spreads, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, unnecessary_brace_in_string_interps, avoid_unnecessary_containers, prefer_const_constructors

import 'dart:ui';
import 'package:epub_view/epub_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:ebook22/customwidgets/app_bar.dart';

// --- Constants ---
const Color primaryBgColor = Color(0xff092531);
const Color secondaryBgColor = Color(0xff113342);
const Color tertiaryBgColor = Color(0xff1D3E4C);
const Color accentColor = Colors.cyan;
const Color textColor = Colors.white;
const Color textColorSecondary = Colors.white70;
const Color errorColor = Colors.red;
const Color errorColorAccent = Colors.redAccent;
const double defaultPadding = 16.0;
const double smallPadding = 8.0;
const double borderRadiusValue = 8.0;
const double gridSpacing = 12.0;
const double gridChildAspectRatio = 2.5/3; // Aspect ratio for grid items
const int gridCrossAxisCount = 3;

// --- Data ---
List<String> randomizedCovers = [ // Renamed for clarity
  'assets/296fe121-5dfa-43f4-98b5-db50019738a7.jpg',
  'assets/Rectangle 3980.png',
  'assets/Rectangle 3978.png',
  'assets/Rectangle 3982.png',
  'assets/Rectangle 3978 (1).png',
  'assets/Rectangle 3985.png',
  'assets/Rectangle 3984.png',
  'assets/Rectangle 3984 (1).png',
  'assets/Rectangle 3985 (1).png',
  'assets/Rectangle 3996.png',
];

enum SelectionOption { all, myBooks, others }

// --- Models ---
class BookMetadata {
  final String filePath;
  final String originalName;
  final String fileType;
  final String coverImage;

  BookMetadata({
    required this.filePath,
    required this.originalName,
    required this.fileType,
    this.coverImage = 'assets/Rectangle 3985.png', // Default cover
  });

  Map<String, dynamic> toJson() => {
        'filePath': filePath,
        'originalName': originalName,
        'fileType': fileType,
        'coverImage': coverImage,
      };

  factory BookMetadata.fromJson(Map<String, dynamic> json) => BookMetadata(
        filePath: json['filePath'],
        originalName: json['originalName'],
        fileType: json['fileType'] ?? 'epub', // Default to epub if missing
        coverImage: json['coverImage'] ?? 'assets/Rectangle 3985.png', // Default cover if missing
      );
}

class BookCategory {
  String name;
  List<BookMetadata> books;
  bool isVisible;

  BookCategory({
    required this.name,
    required this.books,
    this.isVisible = true,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'books': books.map((book) => book.toJson()).toList(),
        'isVisible': isVisible,
      };

  factory BookCategory.fromJson(Map<String, dynamic> json) => BookCategory(
        name: json['name'],
        books: (json['books'] as List)
            .map((item) => BookMetadata.fromJson(item))
            .toList(),
        isVisible: json['isVisible'] ?? true, // Default to visible if missing
      );
}

// --- Main Widget ---
class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  // --- State Variables ---
  List<BookCategory> customCategories = [];
  List<BookMetadata> localBooks = [];
  List<BookMetadata> preferredBooks = []; // This seems unused in the UI logic provided? Consider removing if not needed.

  bool isGridView = false;
  bool visiblemybooks = true; // Controls visibility of "My Books" section
  SelectionOption? selectedOption = SelectionOption.all; // Filter selection

  // Example asset books (Consider loading these differently if needed)
  final List<String> assetBooks = [
    'assets/cervantes-don-quixote-part-1.epub',
    'assets/james-old-testament-legends.epub'
  ];

  // --- Lifecycle Methods ---
  @override
  void initState() {
    super.initState();
    _loadData(); // Load all data initially
  }

  // --- Data Loading/Saving ---
  Future<void> _loadData() async {
    await _loadExistingBooks();
    await _loadCategories();
  }

  Future<void> _loadExistingBooks() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final metadataFile = File('${appDir.path}/book_metadata.json');

      if (await metadataFile.exists()) {
        final String contents = await metadataFile.readAsString();
        final List<dynamic> jsonData = jsonDecode(contents);
        // Filter out books whose files no longer exist
        final loadedBooks = jsonData
            .map((item) => BookMetadata.fromJson(item))
            .where((book) => File(book.filePath).existsSync())
            .toList();
        setState(() {
          localBooks = loadedBooks;
        });
      }
      // Removed preferredBooks loading as it wasn't used in the provided UI logic.
      // Add it back if needed.

      // Clean up metadata file by saving only existing books
      await _saveMetadata();
    } catch (e) {
      print('Error loading books: $e');
      // Consider showing an error message to the user
      // _loadExistingBooksLegacy(); // Keep or remove legacy loading based on requirements
    }
  }

  Future<void> _loadCategories() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final categoriesFile = File('${appDir.path}/categories.json');

      if (await categoriesFile.exists()) {
        final String contents = await categoriesFile.readAsString();
        final List<dynamic> jsonData = jsonDecode(contents);

        final loadedCategories = jsonData
            .map((item) => BookCategory.fromJson(item))
            .toList();

        // Filter out books within categories that no longer exist
        for (var category in loadedCategories) {
          category.books = category.books
              .where((book) => File(book.filePath).existsSync())
              .toList();
        }

        setState(() {
          customCategories = loadedCategories;
        });

        // Save categories again to remove non-existent books
        await _saveCategories();
      }
    } catch (e) {
      print('Error loading categories: $e');
      // Consider showing an error message
    }
  }

  Future<void> _saveMetadata() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final metadataFile = File('${appDir.path}/book_metadata.json');
      final jsonData = localBooks.map((book) => book.toJson()).toList();
      await metadataFile.writeAsString(jsonEncode(jsonData));
      // Removed preferredBooks saving
    } catch (e) {
      print('Error saving metadata: $e');
    }
  }

  Future<void> _saveCategories() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final categoriesFile = File('${appDir.path}/categories.json');
      final jsonData = customCategories.map((category) => category.toJson()).toList();
      await categoriesFile.writeAsString(jsonEncode(jsonData));
    } catch (e) {
      print('Error saving categories: $e');
    }
  }

  // --- Book/Category Management ---

  String _getRandomBookCoverAsset() {
    if (randomizedCovers.isEmpty) return 'assets/Rectangle 3985.png'; // Fallback
    return randomizedCovers[DateTime.now().millisecondsSinceEpoch % randomizedCovers.length];
  }

  Future<void> _addNewBook({BookCategory? selectedCategory}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['epub', 'pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        final sourcePath = file.path; // Path from picker
        if (sourcePath == null) {
          _showSnackBar('Error: Could not get file path.');
          return;
        }

        final originalName = file.name;
        final fileExt = path.extension(originalName).toLowerCase();
        final fileType = (fileExt == '.pdf') ? 'pdf' : 'epub';

        // Copy file to app's documents directory to ensure persistence
        final appDir = await getApplicationDocumentsDirectory();
        final booksDir = Directory('${appDir.path}/books');
        if (!await booksDir.exists()) {
          await booksDir.create(recursive: true);
        }

        // Create a unique filename to avoid conflicts
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final newFileName = '${timestamp}_${path.basename(originalName)}';
        final newPath = path.join(booksDir.path, newFileName);

        await File(sourcePath).copy(newPath);

        final newBook = BookMetadata(
          filePath: newPath,
          originalName: path.basenameWithoutExtension(originalName),
          fileType: fileType,
          coverImage: _getRandomBookCoverAsset(),
        );

        setState(() {
          localBooks.add(newBook);
          if (selectedCategory != null) {
            // Avoid adding duplicates
            if (!selectedCategory.books.any((b) => b.filePath == newBook.filePath)) {
               selectedCategory.books.add(newBook);
            }
          }
        });

        await _saveMetadata();
        if (selectedCategory != null) {
          await _saveCategories();
          _showSnackBar('Added "${newBook.originalName}" to ${selectedCategory.name}');
        } else {
          _showSnackBar('Added "${newBook.originalName}"');
        }
      }
    } catch (e) {
      print('Error adding book: $e');
      _showSnackBar('Error adding book: ${e.toString()}');
    }
  }

  Future<void> _deleteBook(BookMetadata book) async {
    try {
      // 1. Delete the actual file
      final bookFile = File(book.filePath);
      if (await bookFile.exists()) {
        await bookFile.delete();
      }

      // 2. Remove from local books list and all categories
      setState(() {
        localBooks.removeWhere((b) => b.filePath == book.filePath);
        for (var category in customCategories) {
          category.books.removeWhere((b) => b.filePath == book.filePath);
        }
      });

      // 3. Save changes
      await _saveMetadata();
      await _saveCategories();

      _showSnackBar('Deleted "${book.originalName}"');
    } catch (e) {
      print('Error deleting book: $e');
      _showSnackBar('Error deleting book: ${e.toString()}');
    }
  }

  Future<void> _createNewCategory(String categoryName) async {
    final trimmedName = categoryName.trim();
    if (trimmedName.isEmpty) {
      _showSnackBar('Category name cannot be empty.');
      return;
    }

    if (customCategories.any((category) => category.name.toLowerCase() == trimmedName.toLowerCase())) {
      _showSnackBar('Category "$trimmedName" already exists.');
      return;
    }

    final newCategory = BookCategory(
      name: trimmedName,
      books: [],
      isVisible: true,
    );

    setState(() {
      customCategories.add(newCategory);
    });

    await _saveCategories();
    _showSnackBar('Created new category: $trimmedName');
  }

    Future<void> _renameCategory(BookCategory category, String newName) async {
    final trimmedName = newName.trim();
    if (trimmedName.isEmpty) {
      _showSnackBar('Category name cannot be empty.');
      return;
    }
    // Check if another category with the new name already exists (case-insensitive)
    if (customCategories.any((c) => c != category && c.name.toLowerCase() == trimmedName.toLowerCase())) {
      _showSnackBar('Another category named "$trimmedName" already exists.');
      return;
    }

    setState(() {
      category.name = trimmedName;
    });
    await _saveCategories();
    _showSnackBar('Category renamed to "$trimmedName"');
  }


  Future<void> _deleteCategory(BookCategory category) async {
    setState(() {
      customCategories.remove(category);
    });
    await _saveCategories();
    _showSnackBar('Deleted category: ${category.name}');
  }

  Future<void> _addBookToCategory(BookMetadata book, BookCategory category) async {
    if (category.books.any((b) => b.filePath == book.filePath)) {
      _showSnackBar('Book is already in this category.');
      return;
    }

    setState(() {
      category.books.add(book);
    });
    await _saveCategories();
    _showSnackBar('Added "${book.originalName}" to ${category.name}');
  }

  Future<void> _removeBookFromCategory(BookMetadata book, BookCategory category) async {
    setState(() {
      category.books.removeWhere((b) => b.filePath == book.filePath);
    });
    await _saveCategories();
    _showSnackBar('Removed "${book.originalName}" from ${category.name}');
  }

  void _toggleCategoryVisibility(BookCategory category) {
    setState(() {
      category.isVisible = !category.isVisible;
    });
    _saveCategories(); // Save visibility state
  }

  Future<void> _clearBooks() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final booksDir = Directory('${appDir.path}/books');

      // Delete all files in the books directory
      if (await booksDir.exists()) {
        final files = booksDir.listSync();
        for (var file in files) {
          if (file is File) {
             // Only delete files directly managed by this app (based on naming convention or metadata)
             // This example assumes all files in 'books' dir are managed here.
             // Be cautious if other files might exist there.
            await file.delete();
          }
        }
      }

      // Clear the local state and metadata
      setState(() {
        localBooks.clear();
        // Also clear books from custom categories if they were from the main 'books' dir
         for (var category in customCategories) {
           // This assumes category books are references to localBooks.
           // If categories can contain independent copies, adjust logic.
           category.books.clear();
         }
      });

      await _saveMetadata(); // Save empty list
      await _saveCategories(); // Save categories with potentially empty book lists

      _showSnackBar('My Books cleared');
    } catch (e) {
      print('Error clearing books: $e');
      _showSnackBar('Error clearing books: ${e.toString()}');
    }
  }


  // --- Book Opening ---
  Future<void> _openLocalBook(BookMetadata book) async {
    final file = File(book.filePath);
    if (!await file.exists()) {
      _showSnackBar('Error: Book file not found. It might have been moved or deleted.');
      // Optionally remove the book metadata here
      // _deleteBook(book); // Uncomment carefully, might be unexpected for the user
      return;
    }

    try {
      if (book.fileType == 'pdf') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(title: Text(book.originalName)),
              body: PDFView(
                filePath: book.filePath,
                enableSwipe: true,
                swipeHorizontal: false,
                autoSpacing: false,
                pageFling: false,
                onError: (error) {
                   print(error.toString());
                  _showSnackBar('Error loading PDF: ${error.toString()}');
                },
                onPageError: (page, error) {
                  print('$page: ${error.toString()}');
                   _showSnackBar('Error on PDF page $page: ${error.toString()}');
                },
              ),
            ),
          ),
        );
      } else { // Assume EPUB
        // For EPUB, opening directly from the file path is fine
        final controller = EpubController(
          document: EpubDocument.openFile(file),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(title: Text(book.originalName)),
              body: EpubView(controller: controller),
            ),
          ),
        );
      }
    } catch (e) {
      print('Error opening book: $e');
      _showSnackBar('Error opening book: ${e.toString()}');
    }
  }

  // --- UI Helper Methods ---
  void _showSnackBar(String message) {
    if (!mounted) return; // Check if the widget is still in the tree
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Durations.extralong1,
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 131, 145, 151),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _getBookIcon(BookMetadata book, {double width = 80, double height = 100}) {
    // Use a placeholder if the cover image asset doesn't exist or is invalid
    // This requires checking if the asset exists, which is complex.
    // A simpler approach is to ensure randomizedCovers contains valid assets.
    ImageProvider imageProvider = AssetImage(book.coverImage);

    // Basic error handling for AssetImage (won't catch all issues)
    imageProvider.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((_, __) {}, onError: (exception, stackTrace) {
        print("Error loading cover image ${book.coverImage}: $exception");
        // Potentially update state to use a default image here if needed
      })
    );


    if (book.fileType == 'pdf') {
      return Icon(Icons.picture_as_pdf, color: errorColor, size: 30);
    } else {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadiusValue / 2), // Smaller radius for inner image
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            // Basic fallback color while loading or if error occurs
             onError: (exception, stackTrace) {
               print("Error loading image: $exception");
             },
          ),
           color: secondaryBgColor, // Background color for placeholder
        ),
         // Show file type initials as a fallback

      );
    }
  }


  // --- Dialogs ---

  void _showAddBookWithCategoryDialog() {
    if (customCategories.isEmpty) {
      _addNewBook(); // No categories, just add to "My Books"
      return;
    }

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: secondaryBgColor,
        title: const Text('Add Book to Category'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _addNewBook(); // Add to My Books (default)
            },
            child: const Row(
              children: [
                Icon(Icons.book, color: accentColor),
                SizedBox(width: defaultPadding),
                Text('My Books (Default)'),
              ],
            ),
          ),
          ...customCategories.map((category) => SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  _addNewBook(selectedCategory: category); // Add directly to this category
                },
                child: Row(
                  children: [
                    const Icon(Icons.category, color: accentColor),
                    const SizedBox(width: defaultPadding),
                    Text(category.name),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // Dialog to choose adding a new file OR adding an existing book from "My Books"
  void _showAddSourceSelectionDialog(BookCategory category) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: secondaryBgColor,
        title: Text('Add Book to ${category.name}'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _addNewBook(selectedCategory: category); // Import new file directly to category
            },
            child: const Row(
              children: [
                Icon(Icons.file_upload, color: accentColor),
                SizedBox(width: defaultPadding),
                Text('Import New Book'),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _showAddExistingBookToCategoryDialog(category); // Show list of existing books
            },
            child: const Row(
              children: [
                Icon(Icons.book_online, color: accentColor), // Changed icon
                SizedBox(width: defaultPadding),
                Text('Choose from My Books'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Dialog to select an *existing* book from "My Books" to add to a category
 void _showAddExistingBookToCategoryDialog(BookCategory category) {
    // Filter books from 'localBooks' that are NOT already in the target category
    final availableBooks = localBooks
        .where((book) => !category.books.any((b) => b.filePath == book.filePath))
        .toList();

    if (availableBooks.isEmpty) {
      _showSnackBar('All books from "My Books" are already in this category.');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: secondaryBgColor,
        title: Text('Add Book to ${category.name}'),
        children: availableBooks.map((book) => SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _addBookToCategory(book, category);
              },
              child: Row(
                children: [
                  _getBookIcon(book, width: 30, height: 45), // Smaller icon
                  const SizedBox(width: smallPadding),
                  Expanded(
                    child: Text(
                      book.originalName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )).toList(),
      ),
    );
  }

void _showCreateCategoryDialog() {
  final textController = TextEditingController();
  
  showDialog(
    context: context,
    builder: (context) => Dialog(
      clipBehavior: null,
      backgroundColor: Color(0xff284d5d),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color(0xff113342))),
                    icon: Icon(CupertinoIcons.back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'New Collection',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Satoshi-Bold'
                    ),
                  ),
                  IconButton(
                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color(0xff113342))),
                    icon: Icon(CupertinoIcons.checkmark_alt, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                      _createNewCategory(textController.text.trim());
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
              height: 32,
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  
                  hintText: 'Search here...',
                  prefixIcon: ImageIcon(AssetImage('assets/Icons/Search_alt.png'),color: Color(0xff808080),),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.only(top:5),
                ),
              ),
            ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recommanded',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,

                        fontFamily: 'Satoshi-Bold'
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        
                        color: Color(0xFF113342),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'show more',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Satoshi_Regular'
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_double_arrow_right,
                            color: Colors.white70,
                            size: 12,
                          ),
                        ],
                      ),
                      
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                  _buildRecommendedBook('The Kite Runner', 'Kristin Watson', false, 0),
                  _buildRecommendedBook('The Meta', 'Albert Flores', true, 1),
                  _buildRecommendedBook('Nightmare', 'Eleanor Pena', false, 2),
                  _buildRecommendedBook('Fourth Book', 'Jane Doe', false, 3),
          
                    
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Collection name',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Satoshi-Bold'
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: textController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Ex: My Files',
                    hintStyle: TextStyle(fontFamily: 'Satoshi-Bold'),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  void _showMyBooksOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: secondaryBgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: defaultPadding),
                child: Text(
                  'My Books Options',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.add_circle_outline_outlined, color: Colors.white),
                title: const Text('Add New Book'),
                onTap: () {
                  Navigator.pop(context);
                  _addNewBook();
                },
              ),
              ListTile(
                leading: const Icon(Icons.sort, color: Colors.white),
                title: const Text('Sort Books'),
                onTap: () {
                  Navigator.pop(context);
                  _showSortOptionsDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline_outlined, color: errorColor),
                title: const Text('Clear All Books', style: TextStyle(color: errorColor)),
                onTap: () {
                  Navigator.pop(context);
                  _showClearBooksConfirmation();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSortOptionsDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: secondaryBgColor,
        title: const Text('Sort Books By'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                localBooks.sort((a, b) => a.originalName.toLowerCase().compareTo(b.originalName.toLowerCase()));
              });
              _saveMetadata();
            },
            child: const Text('Name (A-Z)'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                localBooks.sort((a, b) => b.originalName.toLowerCase().compareTo(a.originalName.toLowerCase()));
              });
              _saveMetadata();
            },
            child: const Text('Name (Z-A)'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                // Sort by file type, then by name
                localBooks.sort((a, b) {
                  int typeCompare = a.fileType.compareTo(b.fileType);
                  if (typeCompare != 0) return typeCompare;
                  return a.originalName.toLowerCase().compareTo(b.originalName.toLowerCase());
                });
              });
              _saveMetadata();
            },
            child: const Text('File Type'),
          ),
        ],
      ),
    );
  }

  void _showClearBooksConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: secondaryBgColor,
        title: const Text('Clear All Books'),
        content: const Text('Are you sure you want to delete all books from "My Books" and their files? This action cannot be undone.'),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: textColorSecondary)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Clear', style: TextStyle(color: errorColor)),
            onPressed: () {
              Navigator.pop(context);
              _clearBooks();
            },
          ),
        ],
      ),
    );
  }

  // Dialog for options on a book within "My Books"
 void _showBookOptionsDialog(BookMetadata book) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: secondaryBgColor,
        title: Text(book.originalName, style: const TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _openLocalBook(book);
            },
            child: const Text('Open Book'),
          ),
          if (customCategories.isNotEmpty) // Only show if categories exist
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _showAddToCategoryDialog(book); // Show categories to add this book to
              },
              child: const Text('Add to Collection'), // Renamed for consistency
            ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _confirmDeleteBook(book); // Confirm permanent deletion
            },
            child: const Text('Delete Book', style: TextStyle(color: errorColor)),
          ),
        ],
      ),
    );
  }

  // Dialog to select a category to add a specific book to
  void _showAddToCategoryDialog(BookMetadata book) {
     // Filter categories where the book is NOT already present
     final availableCategories = customCategories
         .where((category) => !category.books.any((b) => b.filePath == book.filePath))
         .toList();

     if (availableCategories.isEmpty) {
       _showSnackBar('This book is already in all your collections.');
       return;
     }

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: secondaryBgColor,
        title: const Text('Add to Collection', style: TextStyle(fontSize: 16)),
        children: availableCategories.map((category) => SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _addBookToCategory(book, category);
              },
              child: Text(category.name),
            )).toList(),
      ),
    );
  }

  // Confirmation dialog before permanently deleting a book
  void _confirmDeleteBook(BookMetadata book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: secondaryBgColor,
        title: const Text('Delete Book'),
        content: Text('Are you sure you want to permanently delete "${book.originalName}" and its file? This action cannot be undone.'),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: textColorSecondary)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: errorColor)),
            onPressed: () {
              Navigator.pop(context);
              _deleteBook(book); // Call the actual delete function
            },
          ),
        ],
      ),
    );
  }

  // Dialog for options on a book within a specific category
 void _showBookOptionsInCategoryDialog(BookMetadata book, BookCategory category) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: secondaryBgColor,
        title: Text(book.originalName, style: const TextStyle(fontSize: 16, fontFamily: 'Satoshi-Bold'), overflow: TextOverflow.ellipsis),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _openLocalBook(book);
            },
            child: const Text('Open Book'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _removeBookFromCategory(book, category); // Just remove reference
            },
            child: const Text('Remove from this Collection', style: TextStyle(color: errorColorAccent)),
          ),
           SimpleDialogOption( // Option to move to another category?
             onPressed: () {
               Navigator.pop(context);
               _showMoveToCategoryDialog(book, category); // New dialog needed
             },
             child: const Text('Move to another Collection'),
           ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _confirmDeleteBook(book); // Confirm permanent deletion
            },
            child: const Text('Delete Book Permanently', style: TextStyle(color: errorColor)),
          ),
        ],
      ),
    );
  }

  // New Dialog: Choose another category to move the book to
  void _showMoveToCategoryDialog(BookMetadata book, BookCategory currentCategory) {
    final availableCategories = customCategories
        .where((cat) => cat != currentCategory && !cat.books.any((b) => b.filePath == book.filePath))
        .toList();

    if (availableCategories.isEmpty) {
      _showSnackBar('No other collections available to move this book to.');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: secondaryBgColor,
        title: Text('Move "${book.originalName}" to:'),
        children: availableCategories.map((targetCategory) => SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
            // 1. Add to new category
            _addBookToCategory(book, targetCategory);
            // 2. Remove from old category
            _removeBookFromCategory(book, currentCategory);
            _showSnackBar('Moved "${book.originalName}" to ${targetCategory.name}');
          },
          child: Text(targetCategory.name),
        )).toList(),
      ),
    );
  }


  // Confirmation dialog before removing a book reference from a category
  void _confirmRemoveBookFromCategory(BookMetadata book, BookCategory category) {
     showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: secondaryBgColor,
        title: const Text('Remove Book'),
        content: Text('Remove "${book.originalName}" from ${category.name}? The book file will not be deleted.'),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: textColorSecondary)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Remove', style: TextStyle(color: errorColorAccent)),
            onPressed: () {
              Navigator.pop(context);
              _removeBookFromCategory(book, category);
            },
          ),
        ],
      ),
    );
  }

  // --- Category Options Dialogs ---

  void _showCategoryOptionsBottomSheet(BookCategory category) {
    showModalBottomSheet(
      context: context,
      backgroundColor: secondaryBgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Padding(
                padding: const EdgeInsets.only(bottom: defaultPadding),
                child: Text(
                  'Collection Options: ${category.name}', // Include name
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ListTile(
                 // Use standard Icons for clarity
                leading: const Icon(Icons.edit, color: Colors.white),
                title: const Text('Rename'),
                onTap: () {
                  Navigator.pop(context);
                  _showRenameCategoryDialog(category);
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_circle, color: Colors.white), // Icon for adding
                title: const Text('Add/Remove Books'), // Clarified text
                onTap: () {
                  Navigator.pop(context);
                  _showEditCategoryBooksDialog(category); // Opens add source selection
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline_outlined, color: errorColor),
                title: const Text('Delete Collection', style: TextStyle(color: errorColor)),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteCategoryConfirmation(category);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRenameCategoryDialog(BookCategory category) {
    final textController = TextEditingController(text: category.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog( // Using AlertDialog for simpler layout
        backgroundColor: secondaryBgColor,
        title: const Text('Rename Collection'),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter new name',
            // Add styling if needed
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: textColorSecondary)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Save', style: TextStyle(color: accentColor)),
            onPressed: () {
               final newName = textController.text;
               Navigator.pop(context); // Pop before async operation
               _renameCategory(category, newName); // Call rename function
            },
          ),
        ],
      ),
    );
  }

  // Reusing the add source selection dialog for editing content
  void _showEditCategoryBooksDialog(BookCategory category) {
    _showAddSourceSelectionDialog(category);
  }

  void _showDeleteCategoryConfirmation(BookCategory category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: secondaryBgColor,
        title: const Text('Delete Collection'),
        content: Text('Are you sure you want to delete the collection "${category.name}"? Books within the collection will NOT be deleted from your device.'),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: textColorSecondary)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: errorColor)),
            onPressed: () {
              Navigator.pop(context);
              _deleteCategory(category);
            },
          ),
        ],
      ),
    );
  }


  // --- Build Methods ---

  @override
  Widget build(BuildContext context) {
    // Get screen height for potential calculations (though trying to avoid fixed heights)
    final screenHeight = MediaQuery.of(context).size.height;

    return DefaultTextStyle(
      style: const TextStyle(fontFamily: 'Satoshi', color: textColor), // Set default text color
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryBgColor,
        appBar: PreferredSize(
          // Adjust height based on needs, maybe make it slightly smaller
          preferredSize: Size.fromHeight(screenHeight * 0.179),
          child: CustomAppBar( // Ensure CustomAppBar is implemented correctly
            isGridView: isGridView,
            onViewToggle: () {
              setState(() {
                isGridView = !isGridView;
                // When switching view, ensure categories respect their visibility state
                // (No automatic expansion needed unless desired)
              });
            },
            onFilterTap: () {
              // Filter logic seems complex and tied to 'visiblemybooks'
              // Consider simplifying filter logic if possible
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  backgroundColor: primaryBgColor, // Match theme
                  title: const Text('Filter'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                      child: Column(
                        // Using stateful builder to manage radio state locally if needed
                        // Or manage 'selectedOption' in the main state as done currently
                        children: [
                          RadioListTile<SelectionOption>(
                            title: const Text("All"),
                            value: SelectionOption.all,
                            groupValue: selectedOption,
                            onChanged: (value) {
                              Navigator.pop(context); // Close dialog on selection
                              setState(() {
                                selectedOption = value;
                                visiblemybooks = true; // Show My Books
                                // Potentially show all categories too
                                // customCategories.forEach((c) => c.isVisible = true);
                              });
                            },
                            activeColor: accentColor,
                          ),
                          RadioListTile<SelectionOption>(
                            title: const Text("My Books", style: TextStyle(fontFamily: 'Satoshi-Bold'),),
                            value: SelectionOption.myBooks,
                            groupValue: selectedOption,
                            onChanged: (value) {
                              Navigator.pop(context);
                              setState(() {
                                selectedOption = value;
                                visiblemybooks = true; // Show My Books
                                // Hide other categories?
                                // customCategories.forEach((c) => c.isVisible = false);
                              });
                            },
                            activeColor: accentColor,
                          ),
                          RadioListTile<SelectionOption>(
                            title: const Text("Collections"), // Renamed
                            value: SelectionOption.others,
                            groupValue: selectedOption,
                            onChanged: (value) {
                              Navigator.pop(context);
                              setState(() {
                                selectedOption = value;
                                visiblemybooks = false; // Hide My Books
                                // Show categories?
                                // customCategories.forEach((c) => c.isVisible = true);
                              });
                            },
                            activeColor: accentColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(smallPadding), // Reduced padding
          // Removed unnecessary Flexible widget here
          child: Column( // Main content column
            children: [
              Expanded( // Make the scroll view take remaining space
                child: SingleChildScrollView( // Allows content to scroll
                  child: Column(
                    children: [
                      // --- My Books Section ---
                      if (selectedOption != SelectionOption.others) // Conditionally show based on filter
                       _buildMyBooksSection(),

                      const SizedBox(height: smallPadding), // Consistent spacing

                      // --- Custom Categories Section ---
                      if (selectedOption != SelectionOption.myBooks) // Conditionally show based on filter
                        ...customCategories.map((category) => _buildCategorySection(category)),

                       const SizedBox(height: 80), // Add padding at the bottom for FAB
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
// Try setting a specific FloatingActionButtonLocation
    floatingActionButton: Container(
      margin: const EdgeInsets.only(bottom: 110),
      child: FloatingActionButton(
        
        backgroundColor: tertiaryBgColor,
        onPressed: _showCreateCategoryDialog,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: textColor),
      ),
    ),     
    floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    ),

    );
  }

  // --- Section Build Methods ---

  Widget _buildMyBooksSection() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              visiblemybooks = !visiblemybooks;
            });
          },
          onLongPress: _showMyBooksOptionsBottomSheet, // Options for the whole section
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding, horizontal: smallPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: defaultPadding), // Indent title slightly
                  child: Text('My Books',
                      style: TextStyle(
                        fontSize: 22, // Slightly smaller
                        fontWeight: FontWeight.bold, // Bolder
                      )),
                ),
                Container(
                  padding: const EdgeInsets.all(smallPadding / 2),
                  decoration: BoxDecoration(
                    color: secondaryBgColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    visiblemybooks ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: textColorSecondary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: isGridView
              // Grid View for My Books: Build the grid directly.
              // It handles the empty case by showing only the add button.
              ? _buildBooksGrid(localBooks, isCategory: false) // Pass false here
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                  // List View for My Books: Pass isCategory=false
                  child: _buildVerticalBookList(localBooks, isCategory: false),
                ),
          secondChild: const SizedBox.shrink(), // Collapsed state
          crossFadeState: visiblemybooks ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }

  Widget _buildCategorySection(BookCategory category) {
  // Check if we should show this category
  if (selectedOption == SelectionOption.myBooks) return const SizedBox.shrink();

  return Column(
    children: [
      // Header - modified for long-press gesture
      InkWell(
        onTap: () => _toggleCategoryVisibility(category),
        onLongPress: () => _showCategoryOptionsBottomSheet(category),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding, horizontal: smallPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: defaultPadding),
                child: Text(
                  category.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'Satoshi-Medium',
                  ),
                  overflow: TextOverflow.ellipsis, // Handle long names
                ),
              ),
              Container(
                padding: const EdgeInsets.all(smallPadding / 2),
                margin: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Color(0xff113342),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  category.isVisible ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.white70,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
      
      AnimatedCrossFade(
        firstChild: isGridView
            ? _buildBooksGrid(category.books, category: category, isCategory: true)
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: _buildVerticalBookList(
                  category.books, 
                  isCategory: true, 
                  category: category,
                ),
              ),
        secondChild: const SizedBox.shrink(),
        crossFadeState: category.isVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 300),
      ),
    ],
  );
}


  // --- List/Grid Build Methods ---

  // Builds the vertical list view for books
Widget _buildVerticalBookList(List<BookMetadata> books, {required bool isCategory, BookCategory? category}) {
  // If the list is empty, always show the add button (for both categories and "My Books")
  if (books.isEmpty) {
    return ListTile(
      
      leading:  Padding(
        padding: EdgeInsets.only(left: defaultPadding),
        child: FloatingActionButton.small( // Using .small constructor for smaller size
              backgroundColor: Color(0xFF1D3E4C),
              onPressed: () {_addNewBook();},
              elevation: 0,
              child: const Icon(Icons.add, size: 20, color: Colors.white,), // Reduced icon size too
            ),
      ),
      title: const Text('Add File'),
      onTap: () => isCategory && category != null
          ? _showAddSourceSelectionDialog(category)
          : _addNewBook(), // Use existing _addNewBook() for My Books
    );
  }

  // Build list + add button for both category and "My Books"
  return ListView.builder(
  shrinkWrap: true, // Already have this
  physics: const NeverScrollableScrollPhysics(), // Already have this
  padding: EdgeInsets.zero, // Add this to remove default padding
  itemExtent: null, // Add this to ensure items take only needed space
  itemCount: books.length + 1,
  itemBuilder: (context, index) {
      // Check if it's the last item (for both category and "My Books" list)
      if (index == books.length) {
        // Build the "Add a book" tile
        return ListTile(
          leading: Padding(
            padding: EdgeInsets.only(left: defaultPadding*3), // Indent icon
            child: FloatingActionButton.small( // Using .small constructor for smaller size
              backgroundColor: Color(0xFF1D3E4C),
              onPressed: () {_addNewBook();},
              elevation: 0,
              child: const Icon(Icons.add, size: 20, color: Colors.white,), // Reduced icon size too
            ),
          ),
          title: const Text('Add Something'),
          onTap: () => isCategory && category != null
              ? _showAddSourceSelectionDialog(category)
              : _addNewBook(), 
        );
      }

      // Build regular book item
      final book = books[index];
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: smallPadding / 2), // Add vertical spacing
        child: Card( // Use Card for better visual separation
          color: secondaryBgColor, // Use secondary color for card
          elevation: 2.0, // Add subtle elevation
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(borderRadiusValue),
           ),
          child: InkWell(
            onTap: () => _openLocalBook(book),
            // Long press action depends on whether it's in a category or "My Books"
            onLongPress: isCategory && category != null
                ? () => _showBookOptionsInCategoryDialog(book, category) // Options within category context
                : () => _showBookOptionsDialog(book), // Options for "My Books"
             borderRadius: BorderRadius.circular(borderRadiusValue),
            child: Padding(
              padding: const EdgeInsets.all(smallPadding),
              child: Row(
                children: [
                  // Book cover/icon
                  Padding(
                    padding: const EdgeInsets.only(right: defaultPadding),
                    child: _getBookIcon(book, width: 60, height: 90), // Slightly adjusted size
                  ),
                  // Book information (takes remaining space)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // Prevent column from expanding vertically
                      children: [
                        Text(
                          book.originalName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500), // Adjusted style
                          maxLines: 2, // Allow two lines for title
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: smallPadding / 2),
                        Text(
                          book.fileType.toUpperCase(),
                          style: const TextStyle(fontSize: 10, color: textColorSecondary),
                        ),
                      ],
                    ),
                  ),
                  // Options button
                  IconButton(
                     // Action depends on context (category or My Books)
                    onPressed: isCategory && category != null
                        ? () => _showBookOptionsInCategoryDialog(book, category)
                        : () => _showBookOptionsDialog(book),
                    icon: const Icon(CupertinoIcons.ellipsis_vertical, color: textColorSecondary),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}


  // Builds the grid view for books (used for My Books and Categories)
Widget _buildBooksGrid(List<BookMetadata> books, {BookCategory? category, required bool isCategory}) {

    const double widerGridChildAspectRatio = gridChildAspectRatio *0.77;
    
    // If you need to reduce items per row to make each item wider
    // Uncomment this line and use reducedCrossAxisCount instead of gridCrossAxisCount
    // const int reducedCrossAxisCount = (gridCrossAxisCount > 2) ? gridCrossAxisCount - 1 : gridCrossAxisCount;

    return GridView.builder(
      shrinkWrap: true, // Essential for nesting in SingleChildScrollView
      physics: const NeverScrollableScrollPhysics(), // Disable grid's own scrolling
      padding: const EdgeInsets.all(defaultPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridCrossAxisCount, // Use fewer items per row for wider items
        childAspectRatio: widerGridChildAspectRatio, // Use the reduced aspect ratio
        crossAxisSpacing: gridSpacing, // Use constant
        mainAxisSpacing: gridSpacing, // Use constant
      ),
      // Add 1 for the "Add book" button
      itemCount: books.length + 1,
      itemBuilder: (context, index) {
        // --- Add Book Tile ---
        if (index == books.length) {
          return _buildAddBookGridTile(
            onTap: isCategory && category != null
                ? () => _showAddSourceSelectionDialog(category) // Add to specific category
                : _addNewBook, // Add to "My Books"
            // Use different placeholder images for category vs My Books add button?
            image1: isCategory ? 'assets/Rectangle 3982.png' : 'assets/Rectangle 3980.png',
            image2: isCategory ? 'assets/Rectangle 3984.png' : 'assets/Rectangle 3978.png',
          );
        }

        // --- Regular Book Tile ---
        final book = books[index];
        return InkWell(
          onTap: () => _openLocalBook(book),
           // Long press action depends on context
          onLongPress: isCategory && category != null
              ? () => _showBookOptionsInCategoryDialog(book, category)
              : () => _showBookOptionsDialog(book),
          borderRadius: BorderRadius.circular(borderRadiusValue),
          child: Card(
             color: secondaryBgColor,
             elevation: 2,
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(borderRadiusValue),
             ),
             child: Padding( 
               padding: const EdgeInsets.all(smallPadding /2),
               child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
                children: [
                  // Make icon/cover take most space
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: smallPadding),
                      child: _getBookIcon(book, width: double.infinity, height: double.infinity), // Let icon expand
                    ),
                  ),
                  // Book title below cover
                  Text(
                    book.originalName,
                    maxLines: 2, // Allow two lines
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
               ),
             ),
          ),
        );
      },
    );
  }

// New extracted method for consistent book tiles
Widget _buildBookGridTile({
  required BookMetadata book,
  required VoidCallback onTap,
  required VoidCallback onLongPress,
}) {
  return InkWell(
    onTap: onTap,
    onLongPress: onLongPress,
    borderRadius: BorderRadius.circular(borderRadiusValue),
    child: Card(
      color: secondaryBgColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusValue),
      ),
      child: Padding(
        padding: const EdgeInsets.all(smallPadding / 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Make icon/cover take most space
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(bottom: smallPadding),
                child: _getBookIcon(book, width: double.infinity, height: double.infinity),
              ),
            ),
            // Book title below cover
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  book.originalName,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// Modified "Add Book" tile to match the structure of regular book tiles
Widget _buildAddBookGridTile({
  required VoidCallback onTap,
  required String image1,
  required String image2,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(borderRadiusValue),
    child: Card(
      color: tertiaryBgColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusValue),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Cover images at the top - same flex as book covers
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(bottom: smallPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(image1),
                            fit: BoxFit.cover,
                            onError: (e, s) => print("Error loading add tile image1: $e"),
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(borderRadiusValue),
                          ),
                          color: secondaryBgColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(image2),
                            fit: BoxFit.cover,
                            onError: (e, s) => print("Error loading add tile image2: $e"),
                          ),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(borderRadiusValue),
                          ),
                          color: secondaryBgColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Add icon - same flex as book title
            Expanded(
              flex: 1,
              child: Center(
                child: Icon(
                  CupertinoIcons.add,
                  weight: 1200,
                  
                  color: textColor,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


Widget _buildRecommendedBook(String title, String author, bool isSelected, int imageIndex) {

  int safeIndex = imageIndex % randomizedCovers.length;
  String coverAsset = randomizedCovers[safeIndex];

  return Container(
    
    width: 80,
    margin: EdgeInsets.only(right: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(coverAsset),  // Use the unique cover asset
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            if (isSelected)
              Positioned(
                right: 5,
                top: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(fontSize: 10, color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          'by : $author',
          style: TextStyle(fontSize: 8, color: Colors.white70),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}

}