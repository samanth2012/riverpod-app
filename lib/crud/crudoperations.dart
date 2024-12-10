import 'package:cloud_firestore/cloud_firestore.dart';

class FiresStore {
  final CollectionReference notes =
      FirebaseFirestore.instance.collection("listitems");
  Future<void> addto(String note, String Descr) {
    return notes.add({
      "title": note,
      "description": Descr,
      "timestamp": Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getstream() {
    final notestream =
        notes.orderBy('timestamp', descending: false).snapshots();
    return notestream;
  }

  Future<void> updatefileds(String docuid, newone, String newtwo) {
    return notes.doc(docuid).update({
      "title": newone,
      "description": newtwo,
      "timestamp": Timestamp.now(),
    });
  }

  Future<void> deletelist(String docuid) {
    return notes.doc(docuid).delete();
  }
}
