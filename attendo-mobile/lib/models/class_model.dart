import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

typedef Map<String, dynamic> StudentDetails(params);

class ClassModel {
  bool live = false;
  final String name;
  final Timestamp createdOn;
  final Map<String, dynamic> attendees;
  ClassModel({
    required this.live,
    required this.name,
    required this.createdOn,
    required this.attendees,
  });

  ClassModel copyWith({
    bool? live,
    String? name,
    Timestamp? createdOn,
    Map<String, StudentDetails>? attendees,
  }) {
    return ClassModel(
      live: live ?? this.live,
      name: name ?? this.name,
      createdOn: createdOn ?? this.createdOn,
      attendees: attendees ?? this.attendees,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'live': live,
      'name': name,
      'createdOn': createdOn,
      'attendees': attendees,
    };
  }

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      live: map['live'],
      name: map['name'],
      createdOn: map['createdOn'],
      attendees: Map<String, dynamic>.from(map['attendees']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassModel.fromJson(String source) =>
      ClassModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ClassModel(live: $live, name: $name, createdOn: $createdOn, attendees: $attendees)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClassModel &&
        other.live == live &&
        other.name == name &&
        other.createdOn == createdOn &&
        mapEquals(other.attendees, attendees);
  }

  @override
  int get hashCode {
    return live.hashCode ^
        name.hashCode ^
        createdOn.hashCode ^
        attendees.hashCode;
  }
}
