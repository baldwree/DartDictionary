import 'dart:convert';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dart Dictionary',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Dart Dictionary'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String arrayText = '{"lessons": ['
      '"Input/Output",'
      '"Data",'
      '"Flow",'
      '"Functions",'
      '"History of Flutter and Dart"'
      ']}';
  List<String> entries;
  final Set<String> _saved = Set<String>();
  final List<int> colorCodes = <int>[600, 500, 100];


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    // Load our json values into a usable string list
    var lessonsJson = jsonDecode(arrayText)['lessons'];
    List<String> lessons = lessonsJson != null ? List.from(lessonsJson) : null;
    entries = lessons;

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView.separated(

          padding: const EdgeInsets.all(8),
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {

            return _buildRow('${entries[index]}');
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.black45),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildRow(entry) {

    final bool alreadySaved = _saved.contains(entry);
    return Container(
        height: 75,
        color: Colors.amber[100],


        child: RaisedButton(
//            padding: const EdgeInsets.all(8.0),
            textColor: Colors.white,
            //color: Colors.amber[100],
            //onPressed: addNumbers,
            child: new Text(entry,
                textAlign: TextAlign.center),
          ),

//        child: ListTile(
//          title: Text(
//              entry,
//              textAlign: TextAlign.center
//          ),
//        )
    );
  }
}
