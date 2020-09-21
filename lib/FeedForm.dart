import 'package:flutter/material.dart';

import 'Feed.dart';

class FeedForm extends StatefulWidget {
  final Feed feed;

  String get title => (feed == null) ? "New feed" : "Edit feed";

  FeedForm({this.feed});
  @override
  _FeedFormState createState() => _FeedFormState();
}

class _FeedFormState extends State<FeedForm> {
  final nameController = TextEditingController();
  final languageController = TextEditingController();
  final urlController = TextEditingController();

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
                controller: nameController,
                validator: (value) {
                  if (value.isEmpty)
                    return 'Name';
                  else
                    return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                autofocus: false,
                controller: languageController,
                validator: (value) {
                  if (value.isEmpty)
                    return 'Language';
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
                validator: (value) {
                  if (value.isEmpty)
                    return 'Url';
                  else
                    return null;
                },
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
                    child: Text("CANCELAR"), 
                    onPressed: () => Navigator.pop<bool>(context, false),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: FlatButton(
                    child: Text("ACEPTAR"), onPressed: () {
                      saveChanges();
                      Navigator.pop<bool>(context, true);
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

  void saveChanges() {
    widget.feed.name = nameController.text;
    widget.feed.language = languageController.text;
    widget.feed.url = urlController.text;
  }

  @override
  void initState() {
    super.initState();
    if (widget.feed != null) {
      nameController.text = widget.feed.name;
      languageController.text = widget.feed.language;
      urlController.text = widget.feed.url;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    languageController.dispose();
    urlController.dispose();

    super.dispose();
  }
}
