import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import 'base_repository.dart';


class UserRepository extends BaseRepository {
  final CollectionReference collection;

  UserRepository() : collection = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(UserModel user) async {
    await collection.doc(user.userId).set(user.toJson());
  }

  Future<UserModel?> getUser(String userId) async {
    final doc = await collection.doc(userId).get();
    if (!doc.exists) return null;
    return UserModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  Stream<UserModel> getUserStream(String userId) {
    return collection.doc(userId)
        .snapshots()
        .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>));
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await collection.doc(userId).update(data);
  }
}