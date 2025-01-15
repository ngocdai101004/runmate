
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/run_model.dart';
import 'base_repository.dart';


class RunRepository extends BaseRepository {
  CollectionReference getUserRunsCollection(String userId) {
    return firestore.collection('users/$userId/runs');
  }

  Future<String> addRun(String userId, RunModel run) async {
    final docRef = await getUserRunsCollection(userId).add(run.toJson());
    return docRef.id;
  }

  Stream<List<RunModel>> getRunsStream(String userId) {
    return getUserRunsCollection(userId)
        .orderBy('startTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => RunModel.fromJson(
        doc.data() as Map<String, dynamic>))
        .toList());
  }
}