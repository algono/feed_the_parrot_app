import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feed_the_parrot/firebase_middleware/lib/DBComponent.dart';
import 'package:flutter/material.dart';

class FeedDB {
  static const String usersCollectionName = "users";

  static const String publicCollectionName = "public_feeds",
      privateCollectionName = "feeds";

  static String getCollectionNameFromUser(String userId) =>
      "$usersCollectionName/$userId/$privateCollectionName";

  static const String nameEnAttribute = "name-en",
      nameEsAttribute = "name-es",
      languageAttribute = "language",
      urlAttribute = "url";

  static const String readFieldsAttribute = "readFields",
      itemLimitAttribute = "itemLimit",
      truncateSummaryAtAttribute = "truncateSummaryAt";

  static const String itemFieldNameAttribute = "name",
      itemFieldTruncateAtAttribute = "truncateAt";
}

class ItemField {
  String name;
  int truncateAt;

  ItemField({this.name, this.truncateAt});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map[FeedDB.itemFieldNameAttribute] = this.name;
    map[FeedDB.itemFieldTruncateAtAttribute] = this.truncateAt;

    return map;
  }
}

class Feed extends DBComponent {
  String nameEn, nameEs;
  String language; // TODO: Use the Locale type
  String url;

  List<ItemField> readFields;
  int itemLimit;
  int truncateSummaryAt;

  Feed(
      {String userId,
      this.nameEn,
      this.nameEs,
      this.language,
      this.url,
      this.readFields,
      this.itemLimit,
      this.truncateSummaryAt})
      : super(
            collection: userId == null
                ? FeedDB.publicCollectionName
                : FeedDB.getCollectionNameFromUser(userId));

  Feed.fromReference(DocumentReference reference, {bool init = true})
      : super.fromReference(reference, init: init);

  Feed.fromSnapshot(DocumentSnapshot snapshot) : super.fromSnapshot(snapshot);

  DataRow toDataRow(
      {bool selected,
      void Function(Feed) openFeedForm,
      void Function(Feed, bool) updateSelected}) {
    return DataRow(
      selected: selected,
      onSelectChanged: (selected) => updateSelected(this, selected),
      cells: [
        DataCell(Text(this.nameEn ?? ''),
            showEditIcon: true, onTap: () => openFeedForm(this)),
        DataCell(Text(this.nameEs ?? '')),
        DataCell(Text(this.language)),
        DataCell(Text(this.url)),
      ],
    );
  }

  @override
  Future<void> loadFromSnapshot(DocumentSnapshot snapshot) async {
    var data = snapshot.data();

    this.nameEn = data[FeedDB.nameEnAttribute];
    this.nameEs = data[FeedDB.nameEsAttribute];
    this.language = data[FeedDB.languageAttribute];
    this.url = data[FeedDB.urlAttribute];

    var readFieldsFromDB = data[FeedDB.readFieldsAttribute];

    this.readFields = readFieldsFromDB == null
        ? null
        : List<Map<String, dynamic>>.from(readFieldsFromDB)
            .map((itemFieldMap) => ItemField(
                name: itemFieldMap[FeedDB.itemFieldNameAttribute],
                truncateAt: itemFieldMap[FeedDB.itemFieldTruncateAtAttribute]))
            .toList();

    this.itemLimit = data[FeedDB.itemLimitAttribute];
    this.truncateSummaryAt = data[FeedDB.truncateSummaryAtAttribute];
  }

  @override
  Future<Map<String, dynamic>> toMap() async {
    Map<String, dynamic> map = Map<String, dynamic>();

    map[FeedDB.nameEnAttribute] = this.nameEn;
    map[FeedDB.nameEsAttribute] = this.nameEs;
    map[FeedDB.languageAttribute] = this.language;
    map[FeedDB.urlAttribute] = this.url;

    map[FeedDB.readFieldsAttribute] =
        this.readFields?.map((itemField) => itemField.toMap())?.toList();
    map[FeedDB.itemLimitAttribute] = this.itemLimit;
    map[FeedDB.truncateSummaryAtAttribute] = this.truncateSummaryAt;

    return map;
  }
}
