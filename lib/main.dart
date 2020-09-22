import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feed_the_parrot/firebase_middleware/lib/DataRetriever.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Feed.dart';
import 'FeedForm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feed the Parrot',
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
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Feed the Parrot'),
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
  List<Feed> feeds;
  final Set<Feed> selectedFeeds = Set<Feed>();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        // SingleChildScrollView lets the user scroll the table horizontally
        children: [
          DataRetriever.getCollectionStreamBuilder(
              collectionPath: FeedDB.publicCollectionName,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: const CircularProgressIndicator());

                List<DocumentSnapshot> collection = snapshot.data.docs;

                feeds =
                    collection.map((doc) => Feed.fromSnapshot(doc)).toList();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Language')),
                      DataColumn(label: Text('URL')),
                    ],
                    rows: feeds
                        .map((feed) => feed.toDataRow(
                            selected: selectedFeeds.contains(feed),
                            openFeedForm: _openFeedForm,
                            updateSelected: _updateSelected))
                        .toList(),
                  ),
                );
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                child: Text('New'),
                onPressed: _openFeedForm,
              ),
              FlatButton(
                child: Text('Delete'),
                onPressed: selectedFeeds.isEmpty ? null : _deleteSelectedFeeds,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openFeedForm([Feed feed]) async {
    return Navigator.of(context)
        .push<dynamic>(MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => FeedForm(feed: feed)))
        .then((modified) {
      if (modified == true) {
        setState(() {});
      }
    });
  }

  void _updateSelected(Feed feed, bool selected) {
    setState(() {
      if (selected) {
        selectedFeeds.add(feed);
      } else {
        selectedFeeds.remove(feed);
      }
    });
  }

  void _deleteSelectedFeeds() async {
    await Future.forEach<Feed>(selectedFeeds, (feed) => feed.delete());
    selectedFeeds.clear();
  }
}
