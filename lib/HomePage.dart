import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feed_the_parrot/firebase_middleware/lib/DataRetriever.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Feed.dart';
import 'FeedForm.dart';
import 'LoginForm.dart';

class MyHomePage extends StatefulWidget {
  final User user;

  MyHomePage({Key key, this.title, this.user}) : super(key: key);

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
        actions: [
          Transform.rotate(
            angle: math.pi,
            child: IconButton(
              icon: Icon(
                Icons.exit_to_app,
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                // Open the login form
                await Navigator.of(context).pushReplacement<Null, Null>(
                    MaterialPageRoute<Null>(
                        builder: (BuildContext context) => LoginForm()));
              },
            ),
          ),
        ],
      ),
      body: Column(
        // SingleChildScrollView lets the user scroll the table horizontally
        children: [
          DataRetriever.getCollectionStreamBuilder(
              collectionPath: widget.user == null
                  ? FeedDB.publicCollectionName
                  : FeedDB.getCollectionNameFromUser(widget.user.uid),
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
                      DataColumn(label: Text('Name (en)')),
                      DataColumn(label: Text('Name (es)')),
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
                onPressed: selectedFeeds.isEmpty
                    ? null
                    : () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Are you sure?'),
                            content: Text(
                                'Are you sure you want to delete the following elements:\n\n' +
                                    selectedFeeds.fold(
                                        '',
                                        (previousValue, element) =>
                                            previousValue +
                                            '- ' +
                                            element.nameEn +
                                            '\n')),
                            actions: [
                              FlatButton(
                                child: Text('No'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              FlatButton(
                                child: Text('Yes'),
                                onPressed: () {
                                  _deleteSelectedFeeds();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
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
            builder: (BuildContext context) =>
                FeedForm(user: widget.user, feed: feed)))
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
