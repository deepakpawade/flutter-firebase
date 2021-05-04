import 'package:brew_crew/models/brew.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  //collection reference
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection
        .doc(uid)
        .set({'sugar': sugars, 'name': name, 'strength': strength});
  }

  //brewlist from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      return Brew(
          name: e.data()['name'] ?? '',
          sugars: e.data()['sugars'] ?? '0',
          strength: e.data()['strength'] ?? 0);
    }).toList();
  }

//get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  //get user doc stream
  Stream<DocumentSnapshot> get userData {
    return brewCollection.doc(uid).snapshots();
  }
}
