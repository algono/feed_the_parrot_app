import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'MultipleCollectionStreamSystem.dart';
import 'DBComponent.dart';

class DataRetriever {
  // STREAMS

  // Multiple Collection
  static MultipleCollectionStreamSystem getMultipleCollectionStream(
          Map<Type, String> collectionPaths) =>
      MultipleCollectionStreamSystem(collectionPaths.map(
          (type, collectionPath) => MapEntry(type, getCollection(collectionPath).snapshots())));

  static StreamBuilder<Map<Type, QuerySnapshot>>
      getStreamBuilderFromMultipleCollectionStreamSystem(
          MultipleCollectionStreamSystem multipleCollectionStreamSystem,
          Widget Function(BuildContext, AsyncSnapshot<Map<Type, QuerySnapshot>>)
              builder) {
    return StreamBuilder<Map<Type, QuerySnapshot>>(
      stream: multipleCollectionStreamSystem.stream,
      builder: builder,
    );
  }

  // Collection
  static StreamBuilder<QuerySnapshot> getCollectionStreamBuilder(
      String collectionPath,
      Widget Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return getCollectionStreamBuilderFromReference(
        getCollection(collectionPath), builder);
  }

  static StreamBuilder<QuerySnapshot>
      getCollectionStreamBuilderFromReference(
          CollectionReference collectionReference,
          Widget Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return StreamBuilder<QuerySnapshot>(
      stream: collectionReference.snapshots(),
      builder: builder,
    );
  }

  // Document (Doc)
  static StreamBuilder<DocumentSnapshot> getDocStreamBuilder(
      String documentPath,
      Widget Function(BuildContext, AsyncSnapshot<DocumentSnapshot>) builder) {
    return getDocStreamBuilderFromReference(
        getDoc(documentPath), builder);
  }

  static StreamBuilder<DocumentSnapshot>
      getDocStreamBuilderFromReference(
          DocumentReference documentReference,
          Widget Function(BuildContext, AsyncSnapshot<DocumentSnapshot>)
              builder) {
    return StreamBuilder<DocumentSnapshot>(
      stream: documentReference.snapshots(),
      builder: builder,
    );
  }

  // HELPER FUNCTIONS

  static CollectionReference getCollection(String collectionPath) =>
      FirebaseFirestore.instance.collection(collectionPath);

  static DocumentReference getDoc(String documentPath) =>
      FirebaseFirestore.instance.doc(documentPath);

  
  static Future<DocumentReference> createDoc(
      String collectionPath, Map<String, dynamic> data) {
    return FirebaseFirestore.instance.collection(collectionPath).add(data);
  }

  static Future<void> removeAllComponents<T extends DBComponent>(
          Iterable<T> list) =>
      Future.forEach(list, (component) => component.delete());

  static Widget getListViewItem<T>(
      {T item,
      String displayName,
      bool selected = false,
      Color selectedColor = Colors.blue,
      Function(T) onSelected}) {
    Function onTap;
    if (onSelected != null) {
      onTap = () => onSelected(item);
    }

    return Container(
      color: selected ? selectedColor : null,
      child: ListTile(
        title: Wrap(
          direction: Axis.horizontal,
          children: <Widget>[
            Text(
              displayName,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
