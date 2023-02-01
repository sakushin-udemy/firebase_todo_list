import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../data/db_user.dart';

class UserRepository {
  late final _collection = GetIt.I<FirebaseFirestore>().collection('user');

  Future<void> add(DbUser dbUser) async {
    _collection.doc(dbUser.authenticationId).set(dbUser.toJson());
  }

  Future<DbUser> find(String uid) async {
    final doc = await _collection.doc(uid).get();

    if (doc.exists) {
      return DbUser.fromJson(doc.data()!);
    } else {
      throw Exception('No user: $uid');
    }
  }
}
