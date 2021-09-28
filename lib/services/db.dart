
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import './globals.dart';



class Document<T> {
  final Firestore _db = Firestore.instance;
  final String path; 
  late DocumentReference ref;

  Document({ required this.path }) {
    ref = _db.document(path);
  }

  Future<T> getData() {
    return ref.get().then((v) => Global.models[T](v.data) as T);
  }

  Stream<T> streamData() {
    return ref.snapshots().map((v) => Global.models[T](v.data) as T);
  }

  Future<void> upsert(Map data) {
    return ref.setData(Map<String, dynamic>.from(data), merge: true);
  }

}

class Collection<T> {
  final Firestore _db = Firestore.instance;
  final String path; 
  late CollectionReference ref;

  Collection({ required this.path }) {
    ref = _db.collection(path);
  }

  Future<List<T>> getData() async {
    var snapshots = await ref.getDocuments();
    return snapshots.documents.map((doc) => Global.models[T](doc.data) as T ).toList();
  }

  Stream<Iterable<T>> streamData() {
    return ref.snapshots().map((list) => list.documents.map((doc) => Global.models[T](doc.data) as T) );
  }
}

class UserData<T> {
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collection;

  UserData({ required this.collection });


  Stream<dynamic> get documentStream {

    return _auth.onAuthStateChanged.switchMap((user) {
      // ignore: unnecessary_null_comparison
      if (user != null) {
          Document<T> doc = Document<T>(path: '$collection/${user.uid}'); 
          return doc.streamData();
      } else {
          return Stream<dynamic>.value(null);
      }
    });
  }

  Future<dynamic> getDocument() async {
    FirebaseUser user = await _auth.currentUser();

    // ignore: unnecessary_null_comparison
    if (user != null) {
      Document doc = Document<T>(path: '$collection/${user.uid}'); 
      return doc.getData();
    } else {
      return null;
    }

  }

  Future<void> upsert(Map data) async {
    FirebaseUser user = await _auth.currentUser();
    Document<T> ref = Document(path:  '$collection/${user.uid}');
    return ref.upsert(data);
  }

}
