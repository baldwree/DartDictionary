import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        scaffoldBackgroundColor: Colors.amber[100],
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

/*class Section {
  String title;
  List<String> categories;
  Section(String title, Map<String, dynamic> jsonArray) {
    this.title = title;
    this.categories = [];
    jsonArray[title].forEach((k, v) => this.categories.add(k));
  }
}*/

class Content {
  String category;
  /*List<String> dart;
  List<String> java;
  List<String> swift;*/
  List<String> data;
  Content(String category, Map<String, dynamic> jsonArray) {
    this.category = category;
    /*this.dart = [];
    jsonArray["Dart"].forEach((k, v) => this.dart.add(v));
    this.java = [];
    jsonArray["Java"].forEach((k, v) => this.java.add(v));
    this.swift = [];
    jsonArray["Swift"].forEach((k, v) => this.swift.add(v));*/
    this.data = [];
    jsonArray["Dart"].forEach((k, v) => this.data.add(v));
    jsonArray["Java"].forEach((k, v) => this.data.add(v));
    jsonArray["Swift"].forEach((k, v) => this.data.add(v));
  }
}

Future<String> loadContentAsset() async {
  return await rootBundle.loadString('assets/content.json');
}

Future<Map<String, dynamic>> loadContent() async {
  String jsonString = await loadContentAsset();
  final jsonResponse = json.decode(jsonString);
  return jsonResponse;
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
      '"Java Strings are just ok.",'
      '"Java Strings are just fine.",'
      '"Java Strings are just great!"'
      ']}';
  List<String> entries = [];
  final Set<String> _saved = Set<String>();
  int _counter = 0;
  final List<int> colorCodes = <int>[600, 500, 100];

  Map<String, dynamic> content;
  List<Content> contents;
  bool _loaded = false;
  @override
  void initState() {
    super.initState();
    loadContent().then((s) => setState(() {
      content = s;
      _loaded = true;
    }));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    // Load our json values into a usable string list
    //var lessonsJson = jsonDecode(arrayText)['lessons'];
    contents = [];
    List<String> categories = [];
    Content mycontent;
    String userchoice = "Data";
    if (_loaded) {
      var newJson = content[userchoice];
      newJson.forEach((k, v) {
        mycontent = new Content(k, v);
        contents.add(mycontent);
        categories.add(k);
      });
    }

    //List<String> lessons = lessonsJson != null ? List.from(lessonsJson) : null;
    if (_loaded) {
      //entries = mycontent.swift;
      //contents.forEach((content) => entries.add(content.category));
      entries = categories;
    }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: _loaded ?
        Center(
          child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildRow('${entries[index]}');
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.black45),
          ),
        ) : new Center(
          child: new CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildRow(entry) {
    return Container(
        height: 75,
        width: 100,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        color: Colors.amber[200],
        child: ListTile(
          title: Text(
            entry
          ),
          onTap: () {
            _pushSaved(entry, contents[entries.indexOf(entry)].data);
          }),
        //)
    );
  }

  void _pushSaved(String title, List<String> entries) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            body:  Center(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildList('${entries[index]}');
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.black45),
              ),
            ),
          );
        }
      )
    );
  }

  Widget _buildList(entry) {
    final bool alreadySaved = _saved.contains(entry);
    return ListTile(
      title: Text(
          entry
      ),
    );
  }

}
