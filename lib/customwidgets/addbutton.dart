import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddbuttonContainer extends StatelessWidget {
  const AddbuttonContainer({super.key});

  // Function to show popup with the link
  void _showBooksLinkPopup(BuildContext context) {
    const String booksUrl = 'https://rentry.co/megathread-books'; // Replace with your actual books URL
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xff284D5D),
          title: const Text('📚 Megathread', style: TextStyle(fontWeight:FontWeight.w600),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Ultimate map For the best tools:', style: TextStyle(fontSize: 16),),
              const SizedBox(height: 16),
              Container(
                
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(

                  color: Color(0xff092534),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        booksUrl,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 9, 32, 45)),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      tooltip: 'Copy to clipboard',
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: booksUrl));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Link copied to clipboard')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      
      autofocus: false,
      highlightColor: null,
      onTap: () => _showBooksLinkPopup(context),
      child: Card(
        elevation: 0,
        color: Color(0xff092531),
        shadowColor: null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top:6.0, left:12 ,bottom: 6, right: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26.0),
                  child: FloatingActionButton(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    onPressed: () => _showBooksLinkPopup(context),
                    child: const ImageIcon(AssetImage('assets/Icons/Group.png'), color: Colors.white,),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: SizedBox(
                  height: 90,
                  child: Center(
                    child: Text(
                      'Some Reliable Sources',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Satoshi-Bold',
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}