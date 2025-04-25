import 'package:flutter/material.dart';


class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<String> testData = ['One', 'Two'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Stops widgets from being moved by keyboard
      appBar: AppBar(title: const Text('Test')),
      body: Column(children: [
        Flexible(
            flex: 1,
            child: ListView.builder(
                itemCount: testData.length,
                itemBuilder: (context, index) {
                  return Card(child: Text(testData[index]));
                })),
        Flexible(
            flex: 1,
            child: Row(children: [
              ElevatedButton(
                  child: const Text('Add'),
                  onPressed: () {
                    setState(() {
                      testData.add('Test');
                    });
                  }),
              ElevatedButton(
                  child: const Text('Remove'),
                  onPressed: () {
                    setState(() {
                      if(testData.isNotEmpty){
                        testData.removeLast();
                      }
                    });
                  }),
            ])),
            
      ]),

      
    );
  }
}