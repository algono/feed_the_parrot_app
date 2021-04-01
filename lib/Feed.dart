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

  static const String itemLimitAttribute = "itemLimit",
      truncateContentAtAttribute = "truncateContentAt",
      readFullContentAttribute = "readFullContent";

  static const String filterTextAttribute = "filterByText",
      filterTextMatchAttribute = "filterByTextMatchAll",
      filterCategoryAttribute = "filterByCategory",
      filterCategoryMatchAttribute = "filterByCategoryMatchAll";
}

class Filter {
  Set<String> values = Set();
  bool matchAll = false;

  Filter({this.values, this.matchAll});
}

class Feed extends DBComponent {
  String nameEn, nameEs;
  String language;
  String url;

  int itemLimit;
  int truncateContentAt;
  bool readFullContent;

  Filter filterText;
  Filter filterCategory;

  Feed({
    String userId,
    this.nameEn,
    this.nameEs,
    this.language,
    @required this.url,
    this.itemLimit,
    this.truncateContentAt,
    this.readFullContent,
    this.filterText,
    this.filterCategory,
  }) : super(
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

    this.itemLimit = data[FeedDB.itemLimitAttribute];
    this.truncateContentAt = data[FeedDB.truncateContentAtAttribute];
    this.readFullContent = data[FeedDB.readFullContentAttribute];

    this.filterCategory = Filter(
      values: (data[FeedDB.filterCategoryAttribute] as List)
          ?.map((e) => e as String)
          ?.toSet(),
      matchAll: data[FeedDB.filterCategoryMatchAttribute] ?? false,
    );

    this.filterText = Filter(
      values: (data[FeedDB.filterTextAttribute] as List)
          ?.map((e) => e as String)
          ?.toSet(),
      matchAll: data[FeedDB.filterTextMatchAttribute] ?? false,
    );
  }

  @override
  Future<Map<String, dynamic>> toMap() async {
    Map<String, dynamic> map = Map<String, dynamic>();

    map[FeedDB.nameEnAttribute] = this.nameEn;
    map[FeedDB.nameEsAttribute] = this.nameEs;
    map[FeedDB.languageAttribute] = this.language;
    map[FeedDB.urlAttribute] = this.url;

    map[FeedDB.itemLimitAttribute] = this.itemLimit;
    map[FeedDB.truncateContentAtAttribute] = this.truncateContentAt;
    map[FeedDB.readFullContentAttribute] = this.readFullContent;

    map[FeedDB.filterCategoryAttribute] = this.filterCategory.values.toList();
    map[FeedDB.filterCategoryMatchAttribute] = this.filterCategory.matchAll;
    map[FeedDB.filterTextAttribute] = this.filterText.values.toList();
    map[FeedDB.filterTextMatchAttribute] = this.filterText.matchAll;

    return map;
  }
}
