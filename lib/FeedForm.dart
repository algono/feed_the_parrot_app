import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Feed.dart';

class FeedForm extends StatefulWidget {
  final User user;
  final Feed feed;

  String get title => (feed == null) ? "New feed" : "Edit feed";

  FeedForm({this.user, this.feed});
  @override
  _FeedFormState createState() => _FeedFormState();
}

class _FeedFormState extends State<FeedForm> {
  final nameEnController = TextEditingController();
  final nameEsController = TextEditingController();
  final languageController = TextEditingController();
  final urlController = TextEditingController();

  final itemLimitController = TextEditingController();
  final truncateSummaryAtController = TextEditingController();

  String name;
  String language;
  String url;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: ListView(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            children: <Widget>[
              SizedBox(height: 10.0),
              TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                autofocus: false,
                controller: nameEnController,
                decoration: InputDecoration(
                  labelText: '🇺🇸 - Name',
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                autofocus: false,
                controller: nameEsController,
                decoration: InputDecoration(
                  labelText: '🇪🇸 - Name',
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                autofocus: false,
                controller: languageController,
                decoration: InputDecoration(
                  labelText: 'Language',
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                autofocus: false,
                controller: urlController,
                decoration: InputDecoration(
                  labelText: 'URL',
                ),
                validator: (value) {
                  if (value.isEmpty)
                    return 'Required';
                  else
                    return null;
                },
              ),
              SizedBox(height: 20.0),
              ExpansionTile(
                title: Text('Options'),
                children: [
                  // TODO: Add form for read fields
                  TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    controller: itemLimitController,
                    decoration: InputDecoration(
                        labelText: 'Item limit',
                        hintText:
                            'Max number of items this feed should return'),
                    validator: (value) {
                      if (value.isNotEmpty && int.tryParse(value) == null)
                        return 'This should be a number';
                      else
                        return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    controller: truncateSummaryAtController,
                    decoration: InputDecoration(
                        labelText: 'Truncate summary at',
                        hintText:
                            'Max number of characters the summary should have'),
                    validator: (value) {
                      if (value.isNotEmpty && int.tryParse(value) == null)
                        return 'This should be a number';
                      else
                        return null;
                    },
                  ),
                ],
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
        bottomNavigationBar: Stack(
          overflow: Overflow.visible,
          alignment: FractionalOffset(5, 0.5),
          children: [
            Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: FlatButton(
                    child: Text("Cancel"),
                    onPressed: () => Navigator.pop<bool>(context, false),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: FlatButton(
                    child: Text("OK"),
                    onPressed: () async {
                      bool success = await saveChanges();
                      if (success) Navigator.pop<bool>(context, true);
                    },
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> saveChanges() {
    if (_formKey.currentState.validate()) {
      if (widget.feed == null)
        return createFeed().then<bool>((_) => true);
      else
        return editFeed().then<bool>((_) => true);
    }
    return Future.value(false);
  }

  Future<void> createFeed() {
    return Feed(
            userId: widget.user?.uid,
            nameEn: nameEnController.text.toLowerCase(),
            nameEs: nameEsController.text.toLowerCase(),
            language: languageController.text,
            url: urlController.text,
            itemLimit: itemLimitController.text.isEmpty
                ? null
                : int.parse(itemLimitController.text),
            truncateSummaryAt: truncateSummaryAtController.text.isEmpty
                ? null
                : int.parse(truncateSummaryAtController.text))
        .create();
  }

  Future<void> editFeed() {
    widget.feed.nameEn = nameEnController.text.toLowerCase();
    widget.feed.nameEs = nameEsController.text.toLowerCase();
    widget.feed.language = languageController.text;
    widget.feed.url = urlController.text;

    widget.feed.itemLimit = itemLimitController.text.isEmpty
        ? null
        : int.parse(itemLimitController.text);
    widget.feed.truncateSummaryAt = truncateSummaryAtController.text.isEmpty
        ? null
        : int.parse(truncateSummaryAtController.text);

    return widget.feed.update();
  }

  @override
  void initState() {
    super.initState();
    if (widget.feed != null) {
      nameEnController.text = widget.feed.nameEn ?? '';
      nameEsController.text = widget.feed.nameEs ?? '';
      languageController.text = widget.feed.language ?? '';
      urlController.text = widget.feed.url;

      itemLimitController.text = widget.feed.itemLimit?.toString() ?? '';
      truncateSummaryAtController.text =
          widget.feed.truncateSummaryAt?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    nameEnController.dispose();
    nameEsController.dispose();
    languageController.dispose();
    urlController.dispose();

    super.dispose();
  }
}
