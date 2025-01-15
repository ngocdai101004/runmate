class RoutePoint {
  final double lat;
  final double lng;

  RoutePoint({required this.lat, required this.lng});

  factory RoutePoint.fromJson(Map<String, dynamic> json) {
    return RoutePoint(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}

class RunModel {
  final String runId;
  final double distance;
  final int duration;
  final DateTime startTime;
  final DateTime endTime;
  final List<RoutePoint> route;

  RunModel({
    required this.runId,
    required this.distance,
    required this.duration,
    required this.startTime,
    required this.endTime,
    required this.route,
  });

  factory RunModel.fromJson(Map<String, dynamic> json) {
    var routeList = (json['route'] as List)
        .map((point) => RoutePoint.fromJson(point as Map<String, dynamic>))
        .toList();

    return RunModel(
      runId: json['runId'] as String,
      distance: (json['distance'] as num).toDouble(),
      duration: json['duration'] as int,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      route: routeList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'runId': runId,
      'distance': distance,
      'duration': duration,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'route': route.map((point) => point.toJson()).toList(),
    };
  }
}
