import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dart Dictionary',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.amberAccent[100],
      ),
      home: MyHomePage(title: 'Dart Dictionary'),
    );
  }
}

class Content {
  String category;
  List<String> data;
  Content(String category, Map<String, dynamic> jsonArray) {
    this.category = category;
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

Map<String, dynamic> content;
List<Content> contents;
List<String> entries;
bool _loaded = false;
String choice;
List<String> favorites = [];
String curTitle;
var information;

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
    // Load our json values into a usable string list
    var lessonsJson = jsonDecode(arrayText)['lessons'];
    List<String> lessons = lessonsJson != null ? List.from(lessonsJson) : null;
    entries = lessons;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushFavorites),
        ],
      ),
      body: Center(
        child: ListView.separated(

          padding: const EdgeInsets.all(8),
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {

            return _buildRow('${entries[index]}');
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.black45),
        ),
      ),
    );
  }

  void _pushFavorites() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Favorites'),
            ),
            body: Center(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: favorites.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container (
                      margin: EdgeInsets.all(10),
                      color: Colors.amber[100].withOpacity(0.65),
                      child: ListTile(
                        title: Text (
                            favorites[index]
                        ),
                      )
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.black45),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRow(entry) {
    return Container(
      height: 75,
      child: RaisedButton(
        color: Colors.amber[100],
        textColor: Colors.black,
        onPressed: () {
          choice = entry;
          Navigator.push( context,
            MaterialPageRoute(builder: (context) => SecondRoute()),
          );
        },
        child: new Text(entry,
            textAlign: TextAlign.center),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  final _contentLoaded = _loaded;
  final String userchoice = choice;
  @override
  Widget build(BuildContext context) {

    var contents = [];
    List<String> categories = [];
    Content mycontent;

    if (_contentLoaded) {
      var newJson = content[userchoice];
      newJson.forEach((k, v) {
        mycontent = new Content(k, v);
        contents.add(mycontent);
        categories.add(k);
      });
    }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(userchoice),
      ),
      body: _loaded ?
      Center(
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildRow('${categories[index]}', categories, contents, context);
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.black45),
        ),
      ) : new Center(
        child: new CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildRow(entry, categories, contents, context) {
    return Container(
      height: 75,
      width: 100,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: new BoxDecoration(
          color: Colors.amber[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 2.0, color: Colors.amber[200])
      ),
      child: ListTile(
          title: Center ( child: Text(
              entry
          )
          ),
          onTap: () {
            curTitle = entry;
            information = contents[categories.indexOf(entry)].data;
            Navigator.push( context,
              MaterialPageRoute(builder: (context) => ThirdRoute()),
            );
          }),
      //)
    );
  }
}

class ThirdRoute extends StatefulWidget {
  @override
  ThirdRouteState createState() => ThirdRouteState();
}

class ThirdRouteState extends State<ThirdRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(curTitle),
      ),
      body:  Center(
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: information.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildList('${information[index]}');
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.black45),
        ),
      ),
    );
  }

  Widget _buildList(entry) {
    final bool alreadySaved = favorites.contains(entry);
    return Container (
        margin: EdgeInsets.all(10),
        decoration: new BoxDecoration(
            color: Colors.amber[100].withOpacity(0.65),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 2.0, color: Colors.amber[200])
        ),
        child: ListTile(
          title: Text(
              entry
          ),
          trailing: Icon(
              alreadySaved ? Icons.star : Icons.star_border,
              color: alreadySaved ? Colors.teal[300] : null
          ),
          onTap: () {
            setState(() {
              if (alreadySaved) {
                favorites.remove(entry);
              }
              else {
                favorites.add(entry);
              }
            });
          },
        )
    );
  }
}

