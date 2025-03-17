import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/event_model.dart';

class EventService {
  Future<void> addEvent(EventModel event) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> eventList = prefs.getStringList('events') ?? [];

    eventList.add(jsonEncode(event.toMap()));
    await prefs.setStringList('events', eventList);
  }

  Future<List<EventModel>> getEvents() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> eventList = prefs.getStringList('events') ?? [];

    return eventList.map((event) {
      return EventModel.fromMap(jsonDecode(event));
    }).toList();
  }
}
