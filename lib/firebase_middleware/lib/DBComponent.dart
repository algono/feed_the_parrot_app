import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DBComponent {
  final CollectionReference collection;

  DocumentReference _reference;
  DocumentReference get reference => _reference;
  String get id => reference?.id;

  Future<void> _init;
  Future<void> waitForInit() => _init;

  DBComponent({String collection})
  : this.collection = collection == null ? null : FirebaseFirestore.instance.collection(collection);

  DBComponent.fromReference(DocumentReference reference, {bool init = true}) :
    this._reference = reference,
    this.collection = reference?.parent {
      if (init && reference != null) this._init = revert();
      else this._init = Future.value();
    }

  DBComponent.fromSnapshot(DocumentSnapshot snapshot)
  : this.collection = snapshot.reference.parent {
    _init = this.loadFromSnapshot(snapshot);
  }

  @override
  bool operator ==(o) => o is DBComponent && o?.id == id;

  @override
  int get hashCode => id.hashCode;

  Future<void> loadFromSnapshot(DocumentSnapshot snapshot) async {
    this._reference = snapshot.reference;
  }

  Future<Map<String, dynamic>> toMap();

  Future<void> create() async {
    Map<String, dynamic> map = await this.toMap();
    if (map != null) {
      if (reference == null) {
        return collection.add(map).then((reference) {
          this._reference = reference;
        });
      } else {
        return reference.set(map);
      }
    } else {
      throw UnsupportedError("Creating this object type in the database is not supported");
    }
  }

  Future<void> update() async {
    Map<String, dynamic> map = await this.toMap();
    if (map != null) {
      return reference?.update(map);
    } else {
      throw UnsupportedError("This object type is readonly");
    }
  }

  Future<void> revert() => reference?.get()?.then((snapshot) {
    if (snapshot.exists) {
      return loadFromSnapshot(snapshot);
    } else {
      throw StateError("This object does not exist in the database");
    }
  });

  Future<void> delete() => reference?.delete();
}