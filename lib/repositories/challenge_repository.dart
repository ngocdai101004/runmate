import '../models/challenge_model.dart';
import '../models/participant_model.dart';
import 'base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeRepository extends BaseRepository {
  final CollectionReference collection;

  ChallengeRepository()
      : collection = FirebaseFirestore.instance.collection('challenges');

  Future<String> createChallenge(ChallengeModel challenge) async {
    final docRef = await collection.add(challenge.toJson());
    return docRef.id;
  }

  Stream<List<ChallengeModel>> getChallengesStream({String? userId}) {
    Query query = collection;
    if (userId != null) {
      query = query.where('ownerId', isEqualTo: userId);
    } else {
      query = query.where('type', isEqualTo: 'public');
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['challengeId'] = doc.id;
        return ChallengeModel.fromJson(data);
      }).toList();
    });
  }

  Future<void> addParticipant(
      String challengeId,
      ParticipantModel participant
      ) async {
    await collection
        .doc(challengeId)
        .collection('participants')
        .doc(participant.userId)
        .set(participant.toJson());
  }

  Stream<List<ParticipantModel>> getParticipantsStream(String challengeId) {
    return collection
        .doc(challengeId)
        .collection('participants')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ParticipantModel.fromJson(
        doc.data() as Map<String, dynamic>))
        .toList());
  }
}
