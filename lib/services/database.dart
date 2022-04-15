import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String uid;
  DatabaseService(this.uid);
  //get collection from reference
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  //update the document by reference of uid
  Future updateUserdata(String sugars, String name, int strength) async {
    return await brewCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  //get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map((_brewListFromSnapshot));
  }

  //get Brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Brew(doc.get('name') ?? '', doc.get('sugars') ?? 0,
          doc.get('strength') ?? '');
    }).toList();
  }

  //get user Doc Stream
  Stream<UserData> get userData {
    return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  //UserData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(uid, snapshot.get('name'), snapshot.get('strength'),
        snapshot.get('sugars'));
  }
}
