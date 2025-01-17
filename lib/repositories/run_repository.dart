import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/run.dart';
import 'base_repository.dart';

class RunRepository extends BaseRepository {
  final CollectionReference collection;

  RunRepository() : collection = FirebaseFirestore.instance.collection('runs');

  RunRepository.withMockFirestore(super.firestore)
      : collection = firestore.collection('runs'),
        super.withMockFirestore();

  Future<Run> addRun(Run run) async {
    try {
      final docRef = await collection.add(run.toJson());
      Run? createdRun = await getRunById(docRef.id);
      if (createdRun == null) {
        throw Exception('Error creating run');
      }

      createdRun.id = docRef.id;

      return createdRun;
    } catch (e) {
      throw Exception('Error adding run: $e');
    }
  }

  Future<Run?> getRunById(String? runId) async {
    try {
      if (runId == null) {
        throw Exception('Error getting run by ID: run ID is null');
      }

      final doc = await collection.doc(runId).get();
      if (!doc.exists) return null;
      Run run = Run.fromJson(doc.data() as Map<String, dynamic>);
      run.id = doc.id;
      return run;
    } catch (e) {
      throw Exception('Error getting run by ID: $e');
    }
  }

  Future<List<Run>> getAllRuns() async {
    try {
      final snapshot = await collection.get();
      return snapshot.docs.map((doc) {
        Run run = Run.fromJson(doc.data() as Map<String, dynamic>);
        run.id = doc.id;
        return run;
      }).toList();
    } catch (e) {
      throw Exception('Error getting all runs: $e');
    }
  }

  Future<List<Run>> getRunsByUserId(String userId) async {
    try {
      final querySnapshot = await collection.where('userId', isEqualTo: userId).get();
      return querySnapshot.docs
          .map((doc) {
            Run run = Run.fromJson(doc.data() as Map<String, dynamic>);
            run.id = doc.id;
            return run;
          })
          .toList();
    } catch (e) {
      throw Exception('Error getting runs by user ID: $e');
    }
  }

  Future<List<Run>> getRunsByChallengeId(String challengeId) async {
    try {
      final querySnapshot = await collection.where('challengeId', isEqualTo: challengeId).get();
      return querySnapshot.docs
          .map((doc) {
            Run run = Run.fromJson(doc.data() as Map<String, dynamic>);
            run.id = doc.id;
            return run;
          })
          .toList();
    } catch (e) {
      throw Exception('Error getting runs by challenge ID: $e');
    }
  }

  Future<List<Run>> getRunsByUserIdAndChallengeId(String userId, String challengeId) async {
    try {
      final querySnapshot = await collection
          .where('userId', isEqualTo: userId)
          .where('challengeId', isEqualTo: challengeId)
          .get();
      return querySnapshot.docs
          .map((doc) {
            Run run = Run.fromJson(doc.data() as Map<String, dynamic>);
            run.id = doc.id;
            return run;
          })
          .toList();
    } catch (e) {
      throw Exception('Error getting runs by user ID and challenge ID: $e');
    }
  }

  Future<Run> getRunLatestByUserId(String userId) async {
    try {
      final querySnapshot = await collection
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return  Run(userId: "", date: new DateTime(2020, 10, 10)); // Return an empty run object if no runs are found
      }

      return querySnapshot.docs
          .map((doc) {
        Run run = Run.fromJson(doc.data() as Map<String, dynamic>);
        run.id = doc.id;
        return run;
      })
          .first;
    } catch (e) {
      throw Exception('Error getting latest run by user ID: $e');
    }
  }

  Future<List<Run>> getTopKRunsLatestByUserId(String userId, int k) async {
    try {
      final querySnapshot = await collection
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .limit(k)
          .get();
      return querySnapshot.docs
          .map((doc) {
            Run run = Run.fromJson(doc.data() as Map<String, dynamic>);
            run.id = doc.id;
            return run;
          })
          .toList();
    } catch (e) {
      throw Exception('Error getting top $k latest runs by user ID: $e');
    }
  }

  Future<Run> updateRun(Run run) async {
    try {
      await collection.doc(run.id).update(run.toJson());
      Run? updatedRun = await getRunById(run.id);
      if (updatedRun == null) {
        throw Exception('Error updating run');
      }

      return updatedRun;
    } catch (e) {
      throw Exception('Error updating run: $e');
    }
  }

  Future<Run> updateRunChallengeId(String runId, String challengeId) async {
    try {
      await collection.doc(runId).update({'challengeId': challengeId});
      Run? updatedRun = await getRunById(runId);
      if (updatedRun == null) {
        throw Exception('Error updating run challenge ID');
      }

      return updatedRun;
    } catch (e) {
      throw Exception('Error updating run challenge ID: $e');
    }
  }

  Future<Run> updateDistanceAndDuration(String runId, double distance, Duration duration) async {
    try {
      await collection.doc(runId).update({'distance': distance, 'duration': duration});
      Run? updatedRun = await getRunById(runId);
      if (updatedRun == null) {
        throw Exception('Error updating run distance and duration');
      }

      return updatedRun;
    } catch (e) {
      throw Exception('Error updating run distance and duration: $e');
    }
  }

  Future<Run> updateRoute(String runId, List<LatLngPoint> route) async {
    try {
      await collection.doc(runId).update({'route': route.map((point) => point.toJson()).toList()});
      Run? updatedRun = await getRunById(runId);
      if (updatedRun == null) {
        throw Exception('Error updating run route');
      }

      return updatedRun;
    } catch (e) {
      throw Exception('Error updating run route: $e');
    }
  }

  Future<Run> addRoutePoint(String runId, LatLngPoint point) async {
    try {
      final doc = await collection.doc(runId).get();
      if (!doc.exists) {
        throw Exception('Error adding route point: run does not exist');
      }

      final run = Run.fromJson(doc.data() as Map<String, dynamic>);
      run.id = doc.id;
      run.route.add(point);
      await collection.doc(runId).update({'route': run.route.map((point) => point.toJson()).toList()});
      Run? updatedRun = await getRunById(runId);
      if (updatedRun == null) {
        throw Exception('Error adding route point');
      }

      return updatedRun;
    } catch (e) {
      throw Exception('Error adding route point: $e');
    }
  }

  Future<Run> updateStepsAndCalories(String runId, int steps, double calories) async {
    try {
      await collection.doc(runId).update({'steps': steps, 'calories': calories});
      Run? updatedRun = await getRunById(runId);
      if (updatedRun == null) {
        throw Exception('Error updating run steps and calories');
      }

      return updatedRun;
    } catch (e) {
      throw Exception('Error updating run steps and calories: $e');
    }
  }

  Future<Run> updateAveragePaceAndSpeed(String runId, double averagePace, double averageSpeed) async {
    try {
      await collection.doc(runId).update({'averagePace': averagePace, 'averageSpeed': averageSpeed});
      Run? updatedRun = await getRunById(runId);
      if (updatedRun == null) {
        throw Exception('Error updating run average pace and speed');
      }

      return updatedRun;
    } catch (e) {
      throw Exception('Error updating run average pace and speed: $e');
    }
  }

  Future<Run> updateDistanceAndDurationAndRouteAndStepsAndCaloriesAndAveragePaceAndAverageSpeed(
      String runId, double distance, Duration duration, List<LatLngPoint> route, int steps, double calories, double averagePace, double averageSpeed) async {
    try {
      await collection.doc(runId).update({
        'distance': distance,
        'duration': duration,
        'route': route.map((point) => point.toJson()).toList(),
        'steps': steps,
        'calories': calories,
        'averagePace': averagePace,
        'averageSpeed': averageSpeed,
      });
      Run? updatedRun = await getRunById(runId);
      if (updatedRun == null) {
        throw Exception('Error updating run distance, duration, route, steps, calories, average pace, and average speed');
      }

      return updatedRun;
    } catch (e) {
      throw Exception('Error updating run distance, duration, route, steps, calories, average pace, and average speed: $e');
    }
  }

  Future<void> deleteRun(String runId) async {
    try {
      await collection.doc(runId).delete();
    } catch (e) {
      throw Exception('Error deleting run: $e');
    }
  }

  Future<int> getStreakByUserID(String userID) async {
    int streak = 0;
    try {
      await collection.where('userId', isEqualTo: userID).orderBy('date', descending: true).get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          Run run = Run.fromJson(doc.data() as Map<String, dynamic>);
          run.id = doc.id;
          if (run.date.difference(DateTime.now()).inDays == 1) {
            streak++;
          }
        });
      });
    } catch (e) {
      throw Exception('Error getting streak by user ID: $e');
    }
      return streak;
    }
  }
