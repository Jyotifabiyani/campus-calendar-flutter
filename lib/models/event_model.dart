import 'package:flutter/material.dart';

class EventModel {
  final String id;
  final String name;
  final String description;
  final String venue;
  final String speaker;
  final String posterUrl; // New field for image
  final DateTime date;
  final TimeOfDay time;
  final String createdBy;

  EventModel({
    required this.id,
    required this.name,
    required this.description,
    required this.venue,
    required this.speaker,
    required this.posterUrl,
    required this.date,
    required this.time,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'venue': venue,
      'speaker': speaker,
      'posterUrl': posterUrl,
      'date': date.toIso8601String(),
      'time': '${time.hour}:${time.minute}',
      'createdBy': createdBy,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      venue: map['venue'],
      speaker: map['speaker'],
      posterUrl: map['posterUrl'],
      date: DateTime.parse(map['date']),
      time: TimeOfDay(
        hour: int.parse(map['time'].split(':')[0]),
        minute: int.parse(map['time'].split(':')[1]),
      ),
      createdBy: map['createdBy'],
    );
  }
}
