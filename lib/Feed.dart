import 'package:flutter/material.dart';

class Feed {
  String name;
  String language; // TODO: Use the Locale type
  String url;

  Feed({this.name, this.language, this.url});

  DataRow toDataRow(void Function(Feed) openFeedForm) {
    return DataRow(
      onSelectChanged: (_) => openFeedForm(this),
      cells: [
        DataCell(Text(this.name)),
        DataCell(Text(this.language)),
        DataCell(Text(this.url)),
      ],
    );
  }
}
