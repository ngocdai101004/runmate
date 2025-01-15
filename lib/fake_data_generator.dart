import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'models/user_model.dart';
import 'models/challenge_model.dart';
import 'models/participant_model.dart';
import 'models/run_model.dart';
import 'models/invitation_model.dart';


class FakeDataGenerator {
  final faker = Faker();
  final firestore = FirebaseFirestore.instance;

  Future<void> generateFakeData() async {
    await _generateUsers(10);

    await _generateChallenges(5);

    await _generateParticipants();

    await _generateRuns();

    await _generateInvitations();

  }

  Future<void> _generateUsers(int count) async {
    final usersCollection = firestore.collection('users');
    for (int i = 0; i < count; i++) {
      final user = UserModel(
        userId: faker.guid.guid(),
        name: faker.person.name(),
        email: faker.internet.email(),
        avatarUrl: faker.image.image(),
        totalDistance: faker.randomGenerator.decimal(scale: 1000),
        totalTime: faker.randomGenerator.integer(10000),
        createdAt: faker.date.dateTimeBetween(DateTime(2019, 1, 1), DateTime(2020, 1, 1)),
      );
      await usersCollection.doc(user.userId).set(user.toJson());
    }
  }

  Future<void> _generateChallenges(int count) async {
    final challengesCollection = firestore.collection('challenges');
    final usersSnapshot = await firestore.collection('users').get();
    final userIds = usersSnapshot.docs.map((doc) => doc.id).toList();

    for (int i = 0; i < count; i++) {
      final challenge = ChallengeModel(
        challengeId: faker.guid.guid(),
        ownerId: faker.randomGenerator.element(userIds),
        name: faker.lorem.sentence(),
        description: faker.lorem.sentences(3).join(' '),
        type: faker.randomGenerator.element(['public', 'private']),
        startDate: faker.date.dateTimeBetween(DateTime(2020, 6, 1), DateTime(2020, 7, 1)),
        endDate: faker.date.dateTimeBetween(DateTime(2020, 7, 2), DateTime(2020, 8, 1)),
        goalDistance: faker.randomGenerator.decimal(scale: 100),
        createdAt: faker.date.dateTimeBetween(DateTime(2020, 5, 1), DateTime(2020, 6, 1)),
      );
      await challengesCollection.doc(challenge.challengeId).set(challenge.toJson());
    }
  }

  Future<void> _generateParticipants() async {
    final challengesCollection = firestore.collection('challenges');
    final usersCollection = firestore.collection('users');

    final challengesSnapshot = await challengesCollection.get();
    final usersSnapshot = await usersCollection.get();

    final userIds = usersSnapshot.docs.map((doc) => doc.id).toList();


    for (var challengeDoc in challengesSnapshot.docs) {
      final challengeId = challengeDoc.id;
      final numParticipants = faker.randomGenerator.integer(userIds.length, min: 1);
      // final challengeStartDate = (challengeDoc.data())['startDate'];
      // final challengeEndDate = (challengeDoc.data())['endDate'];
      for (int i = 0; i < numParticipants; i++) {
        final participant = ParticipantModel(
          participantId: faker.guid.guid(),
          userId: faker.randomGenerator.element(userIds),
          status: faker.randomGenerator.element(['joined', 'completed']),
          totalDistance: faker.randomGenerator.decimal(scale: 100),
          createdAt: faker.date.dateTimeBetween(DateTime(2020, 5, 1), DateTime(2020, 6, 1)),
        );
        await challengesCollection
            .doc(challengeId)
            .collection('participants')
            .doc(participant.participantId)
            .set(participant.toJson());
      }
    }
  }

  Future<void> _generateRuns() async {
    final usersCollection = firestore.collection('users');
    final usersSnapshot = await usersCollection.get();

    for (var userDoc in usersSnapshot.docs) {
      final userId = userDoc.id;
      final numRuns = faker.randomGenerator.integer(10, min: 1);

      for (int i = 0; i < numRuns; i++) {
        final startTime = faker.date.dateTimeBetween(DateTime(2020, 1, 1), DateTime.now());
        final endTime =  faker.date.dateTimeBetween(startTime, DateTime.now());
        final run = RunModel(
          runId: faker.guid.guid(),
          distance: faker.randomGenerator.decimal(scale: 10),
          duration: endTime.difference(startTime).inSeconds,
          startTime: startTime,
          endTime: endTime,
          route: _generateRoute(),
        );
        await usersCollection
            .doc(userId)
            .collection('runs')
            .doc(run.runId)
            .set(run.toJson());
      }
    }
  }

  List<RoutePoint> _generateRoute() {
    final numPoints = faker.randomGenerator.integer(20, min: 5);
    final route = <RoutePoint>[];
    for (int i = 0; i < numPoints; i++) {
      route.add(RoutePoint(
        lat: faker.geo.latitude(),
        lng: faker.geo.longitude(),
      ));
    }
    return route;
  }

  Future<void> _generateInvitations() async {
    final invitationsCollection = firestore.collection('invitations');
    final challengesCollection = firestore.collection('challenges');
    final usersCollection = firestore.collection('users');

    final challengesSnapshot = await challengesCollection.get();
    final usersSnapshot = await usersCollection.get();

    final userEmails = usersSnapshot.docs.map((doc) => doc.data()['email'] as String).toList();

    for (var challengeDoc in challengesSnapshot.docs) {
      final challengeId = challengeDoc.id;
      final numInvitations = faker.randomGenerator.integer(userEmails.length, min: 1);

      for (int i = 0; i < numInvitations; i++) {
        final invitation = InvitationModel(
          invitationId: faker.guid.guid(),
          challengeId: challengeId,
          email: faker.randomGenerator.element(userEmails),
          status: faker.randomGenerator.element(['pending', 'accepted', 'rejected']),
          sentAt: faker.date.dateTimeBetween(DateTime(2020, 1, 1), DateTime.now()),
        );
        await invitationsCollection.doc(invitation.invitationId).set(invitation.toJson());
      }
    }
  }

}