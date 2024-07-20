import 'package:latlong2/latlong.dart';

class OsrmRouteResponse {
  String? code;
  List<Routes>? routes;
  List<Waypoints>? waypoints;

  OsrmRouteResponse({this.code, this.routes, this.waypoints});

  OsrmRouteResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['routes'] != null) {
      routes = <Routes>[];
      json['routes'].forEach((v) {
        routes!.add(new Routes.fromJson(v));
      });
    }
    if (json['waypoints'] != null) {
      waypoints = <Waypoints>[];
      json['waypoints'].forEach((v) {
        waypoints!.add(new Waypoints.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.routes != null) {
      data['routes'] = this.routes!.map((v) => v.toJson()).toList();
    }
    if (this.waypoints != null) {
      data['waypoints'] = this.waypoints!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static List<LatLng> getLatLngFromRoute(Routes route) {
    List<LatLng> latLngList = [];

    if (route.legs != null) {
      for (Legs leg in route.legs!) {
        if (leg.steps != null) {
          for (Steps step in leg.steps!) {
            if (step.intersections != null) {
              for (Intersections intersection in step.intersections!) {
                if (intersection.location != null &&
                    intersection.location!.length == 2) {
                  double longitude = intersection.location![0];
                  double latitude = intersection.location![1];
                  latLngList.add(LatLng(latitude, longitude));
                }
              }
            }
          }
        }
      }
    }

    return latLngList;
  }
}

class Routes {
  List<Legs>? legs;
  String? weightName;
  dynamic weight;
  dynamic duration;
  dynamic distance;

  Routes(
      {this.legs, this.weightName, this.weight, this.duration, this.distance});

  Routes.fromJson(Map<String, dynamic> json) {
    if (json['legs'] != null) {
      legs = <Legs>[];
      json['legs'].forEach((v) {
        legs!.add(new Legs.fromJson(v));
      });
    }
    weightName = json['weight_name'];
    weight = json['weight'];
    duration = json['duration'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.legs != null) {
      data['legs'] = this.legs!.map((v) => v.toJson()).toList();
    }
    data['weight_name'] = this.weightName;
    data['weight'] = this.weight;
    data['duration'] = this.duration;
    data['distance'] = this.distance;
    return data;
  }
}

class Legs {
  List<Steps>? steps;
  String? summary;
  dynamic weight;
  dynamic duration;
  dynamic distance;

  Legs({this.steps, this.summary, this.weight, this.duration, this.distance});

  Legs.fromJson(Map<String, dynamic> json) {
    if (json['steps'] != null) {
      steps = <Steps>[];
      json['steps'].forEach((v) {
        steps!.add(new Steps.fromJson(v));
      });
    }
    summary = json['summary'];
    weight = json['weight'];
    duration = json['duration'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.steps != null) {
      data['steps'] = this.steps!.map((v) => v.toJson()).toList();
    }
    data['summary'] = this.summary;
    data['weight'] = this.weight;
    data['duration'] = this.duration;
    data['distance'] = this.distance;
    return data;
  }
}

class Steps {
  String? geometry;
  Maneuver? maneuver;
  String? mode;
  String? drivingSide;
  String? name;
  List<Intersections>? intersections;
  dynamic weight;
  dynamic duration;
  dynamic distance;
  String? ref;

  Steps(
      {this.geometry,
      this.maneuver,
      this.mode,
      this.drivingSide,
      this.name,
      this.intersections,
      this.weight,
      this.duration,
      this.distance,
      this.ref});

  Steps.fromJson(Map<String, dynamic> json) {
    geometry = json['geometry'];
    maneuver = json['maneuver'] != null
        ? new Maneuver.fromJson(json['maneuver'])
        : null;
    mode = json['mode'];
    drivingSide = json['driving_side'];
    name = json['name'];
    if (json['intersections'] != null) {
      intersections = <Intersections>[];
      json['intersections'].forEach((v) {
        intersections!.add(new Intersections.fromJson(v));
      });
    }
    weight = json['weight'];
    duration = json['duration'];
    distance = json['distance'];
    ref = json['ref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['geometry'] = this.geometry;
    if (this.maneuver != null) {
      data['maneuver'] = this.maneuver!.toJson();
    }
    data['mode'] = this.mode;
    data['driving_side'] = this.drivingSide;
    data['name'] = this.name;
    if (this.intersections != null) {
      data['intersections'] =
          this.intersections!.map((v) => v.toJson()).toList();
    }
    data['weight'] = this.weight;
    data['duration'] = this.duration;
    data['distance'] = this.distance;
    data['ref'] = this.ref;
    return data;
  }
}

class Maneuver {
  dynamic bearingAfter;
  dynamic bearingBefore;
  List<double>? location;
  String? type;
  String? modifier;

  Maneuver(
      {this.bearingAfter,
      this.bearingBefore,
      this.location,
      this.type,
      this.modifier});

  Maneuver.fromJson(Map<String, dynamic> json) {
    bearingAfter = json['bearing_after'];
    bearingBefore = json['bearing_before'];
    location = json['location'].cast<double>();
    type = json['type'];
    modifier = json['modifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bearing_after'] = this.bearingAfter;
    data['bearing_before'] = this.bearingBefore;
    data['location'] = this.location;
    data['type'] = this.type;
    data['modifier'] = this.modifier;
    return data;
  }
}

class Intersections {
  dynamic out;
  List<bool>? entry;
  List<int>? bearings;
  List<double>? location;
  dynamic inn;

  Intersections({this.out, this.entry, this.bearings, this.location, this.inn});

  Intersections.fromJson(Map<String, dynamic> json) {
    out = json['out'];
    entry = json['entry'].cast<bool>();
    bearings = json['bearings'].cast<int>();
    location = json['location'].cast<double>();
    inn = json['in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['out'] = this.out;
    data['entry'] = this.entry;
    data['bearings'] = this.bearings;
    data['location'] = this.location;
    data['in'] = this.inn;
    return data;
  }
}

class Waypoints {
  String? hint;
  dynamic distance;
  String? name;
  List<double>? location;

  Waypoints({this.hint, this.distance, this.name, this.location});

  Waypoints.fromJson(Map<String, dynamic> json) {
    hint = json['hint'];
    distance = json['distance'];
    name = json['name'];
    location = json['location'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hint'] = this.hint;
    data['distance'] = this.distance;
    data['name'] = this.name;
    data['location'] = this.location;
    return data;
  }
}
