import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feed_the_parrot/firebase_middleware/lib/DBComponent.dart';
import 'package:flutter/material.dart';

class FeedDB {

  static const String
    usersCollectionName = "users";

  static const String
    publicCollectionName = "public_feeds",
    privateCollectionName = "feeds";

  static String getCollectionNameFromUser(String userId) => "$usersCollectionName/$userId/$privateCollectionName";

  static const String 
    nameAttribute = "name",
    languageAttribute = "language",
    urlAttribute = "url";
}

class Feed extends DBComponent {
  String name;
  String language; // TODO: Use the Locale type
  String url;

  Feed({String userId, this.name, this.language, this.url}) : super(
    collection: userId == null ? FeedDB.publicCollectionName : FeedDB.getCollectionNameFromUser(userId));

  Feed.fromReference(DocumentReference reference, {bool init = true})
      : super.fromReference(reference, init: init);

  Feed.fromSnapshot(DocumentSnapshot snapshot)
      : super.fromSnapshot(snapshot);

  DataRow toDataRow({bool selected, void Function(Feed) openFeedForm, void Function(Feed, bool) updateSelected}) {
    return DataRow(
      selected: selected,
      onSelectChanged: (selected) => updateSelected(this, selected),
      cells: [
        DataCell(Text(this.name), showEditIcon: true, onTap: () => openFeedForm(this)),
        DataCell(Text(this.language)),
        DataCell(Text(this.url)),
      ],
    );
  }
  
  @override
  Future<void> loadFromSnapshot(DocumentSnapshot snapshot) async {
    this.name = snapshot.get(FeedDB.nameAttribute);
    this.language = snapshot.get(FeedDB.languageAttribute);
    this.url = snapshot.get(FeedDB.urlAttribute);
  }

  @override
  Future<Map<String, dynamic>> toMap() async {
    Map<String, dynamic> map = Map<String, dynamic>();

    map[FeedDB.nameAttribute] = this.name;
    map[FeedDB.languageAttribute] = this.language;
    map[FeedDB.urlAttribute] = this.url;

    return map;
  }
}
