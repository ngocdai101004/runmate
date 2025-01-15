import '../models/invitation_model.dart';
import 'base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class InvitationRepository extends BaseRepository {
  final CollectionReference collection;

  InvitationRepository()
      : collection = FirebaseFirestore.instance.collection('invitations');

  Future<void> createInvitation(InvitationModel invitation) async {
    await collection.add(invitation.toJson());
  }

  Stream<List<InvitationModel>> getInvitationsStream(String email) {
    return collection
        .where('email', isEqualTo: email)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => InvitationModel.fromJson(
        doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future<void> updateInvitationStatus(
      String invitationId,
      String status
      ) async {
    await collection.doc(invitationId).update({'status': status});
  }
}
