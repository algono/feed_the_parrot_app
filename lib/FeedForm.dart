import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Feed.dart';
import 'main.dart';

class FeedForm extends StatefulWidget {
  final User user;
  final Feed feed;
  final Set<String> namesEn, namesEs;

  String title(BuildContext context) => (feed == null)
      ? AppLocalizations.of(context).feedFormNewTitle
      : AppLocalizations.of(context).feedFormEditTitle;

  static bool Function(String) _filterFeedNames(String currentFeedName) {
    return (String element) =>
        element != null && element.isNotEmpty && element != currentFeedName;
  }

  FeedForm({this.user, this.feed, List<Feed> feedList})
      : namesEn = feedList
            .map((feed) => feed.nameEn)
            .where(_filterFeedNames(feed?.nameEn))
            .toSet(),
        namesEs = feedList
            .map((feed) => feed.nameEs)
            .where(_filterFeedNames(feed?.nameEs))
            .toSet();

  @override
  _FeedFormState createState() => _FeedFormState();
}

class _FeedFormState extends State<FeedForm> {
  final nameEnController = TextEditingController();
  final nameEsController = TextEditingController();
  final urlController = TextEditingController();

  final itemLimitController = TextEditingController();
  final truncateContentAtController = TextEditingController();

  String languageValue;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final nameField = AppLocalizations.of(context).nameField;

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title(context)),
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
                  labelText: '🇺🇸 $nameField',
                ),
                validator: (value) {
                  if (widget.namesEn.contains(value))
                    return AppLocalizations.of(context)
                        .valueShouldBeUniqueErrorMessage;
                  else
                    return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                autofocus: false,
                controller: nameEsController,
                decoration: InputDecoration(
                  labelText: '🇪🇸 $nameField',
                ),
                validator: (value) {
                  if (widget.namesEs.contains(value))
                    return AppLocalizations.of(context)
                        .valueShouldBeUniqueErrorMessage;
                  else
                    return null;
                },
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                autofocus: false,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).languageField,
                ),
                items: [
                  DropdownMenuItem(
                      value: 'en',
                      child: Text(
                          '🇺🇸 ${AppLocalizations.of(context).englishLanguage}')),
                  DropdownMenuItem(
                      value: 'es',
                      child: Text(
                          '🇪🇸 ${AppLocalizations.of(context).spanishLanguage}')),
                ],
                value: languageValue,
                onChanged: (value) {
                  setState(() {
                    languageValue = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return AppLocalizations.of(context)
                        .requiredValueErrorMessage;
                  else
                    return null;
                },
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
                    return AppLocalizations.of(context)
                        .requiredValueErrorMessage;
                  else
                    return null;
                },
              ),
              SizedBox(height: 20.0),
              ExpansionTile(
                title: Text(AppLocalizations.of(context).optionsTileTitle),
                children: [
                  TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    controller: itemLimitController,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).itemLimitField,
                        hintText: AppLocalizations.of(context).itemLimitHint),
                    validator: (value) {
                      if (value.isNotEmpty && int.tryParse(value) == null)
                        return AppLocalizations.of(context)
                            .valueShouldBeANumberErrorMessage;
                      else
                        return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    controller: truncateContentAtController,
                    decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context).truncateContentAtField,
                        hintText:
                            AppLocalizations.of(context).truncateContentAtHint),
                    validator: (value) {
                      if (value.isNotEmpty && int.tryParse(value) == null)
                        return AppLocalizations.of(context)
                            .valueShouldBeANumberErrorMessage;
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
                    child: Text(
                        MaterialLocalizations.of(context).cancelButtonLabel),
                    onPressed: () => Navigator.pop<bool>(context, false),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: FlatButton(
                    child:
                        Text(MaterialLocalizations.of(context).okButtonLabel),
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
            language: languageValue,
            url: urlController.text,
            itemLimit: itemLimitController.text.isEmpty
                ? null
                : int.parse(itemLimitController.text),
            truncateContentAt: truncateContentAtController.text.isEmpty
                ? null
                : int.parse(truncateContentAtController.text))
        .create();
  }

  Future<void> editFeed() {
    widget.feed.nameEn = nameEnController.text.toLowerCase();
    widget.feed.nameEs = nameEsController.text.toLowerCase();
    widget.feed.language = languageValue;
    widget.feed.url = urlController.text;

    widget.feed.itemLimit = itemLimitController.text.isEmpty
        ? null
        : int.parse(itemLimitController.text);
    widget.feed.truncateContentAt = truncateContentAtController.text.isEmpty
        ? null
        : int.parse(truncateContentAtController.text);

    return widget.feed.update();
  }

  @override
  void initState() {
    super.initState();
    if (widget.feed != null) {
      nameEnController.text = widget.feed.nameEn ?? '';
      nameEsController.text = widget.feed.nameEs ?? '';
      languageValue = widget.feed.language ?? '';
      urlController.text = widget.feed.url;

      itemLimitController.text = widget.feed.itemLimit?.toString() ?? '';
      truncateContentAtController.text =
          widget.feed.truncateContentAt?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    nameEnController.dispose();
    nameEsController.dispose();
    urlController.dispose();

    super.dispose();
  }
}
