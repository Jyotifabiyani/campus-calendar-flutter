import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/event_service.dart';
import '../models/event_model.dart';

class StudentHomeScreen extends StatefulWidget {
  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final EventService _eventService = EventService();
  late Future<List<EventModel>> _eventsFuture;
  Map<DateTime, List<String>> _markedEvents = {};
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _eventsFuture = _eventService.getEvents();
    _loadMarkedEvents();
  }

  /// Load marked events from SharedPreferences
  Future<void> _loadMarkedEvents() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('marked_events');
    if (data != null) {
      setState(() {
        _markedEvents = (jsonDecode(data) as Map<String, dynamic>).map(
          (key, value) => MapEntry(DateTime.parse(key), List<String>.from(value)),
        );
      });
    }
  }

  /// Save marked events to SharedPreferences
  Future<void> _saveMarkedEvents() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('marked_events', jsonEncode(_markedEvents.map(
      (key, value) => MapEntry(key.toIso8601String(), value),
    )));
  }

  /// Mark an event on the calendar
  void _markEvent(EventModel event) {
    setState(() {
      DateTime eventDate = DateTime(event.date.year, event.date.month, event.date.day);

      if (_markedEvents.containsKey(eventDate)) {
        if (!_markedEvents[eventDate]!.contains(event.name)) {
          _markedEvents[eventDate]!.add(event.name);
        }
      } else {
        _markedEvents[eventDate] = [event.name];
      }

      _saveMarkedEvents();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${event.name} marked on calendar!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View & Mark Events")),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<EventModel>>(
              future: _eventsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No events available."));
                }

                List<EventModel> events = snapshot.data!;

                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    EventModel event = events[index];

                    return Card(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ✅ Display poster image at the top if available
                          if (event.posterUrl.isNotEmpty)
                            Image.network(
                              event.posterUrl,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 100),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListTile(
                              title: Text(event.name, style: TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                "Created by: ${event.createdBy}\n"
                                "Date: ${event.date.toLocal().toString().split(' ')[0]}\n"
                                "Time: ${event.time.hour}:${event.time.minute}\n"
                                "Venue: ${event.venue}\n"
                                "${event.description}",
                              ),
                              trailing: ElevatedButton(
                                onPressed: () => _markEvent(event),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                child: Text("Mark on Calendar"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          /// ✅ Calendar Widget
          Container(
            padding: EdgeInsets.all(10),
            child: TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime(2022),
              lastDay: DateTime(2030),

              /// ✅ Loads marked events on the calendar
              eventLoader: (date) {
                return _markedEvents[DateTime(date.year, date.month, date.day)] ?? [];
              },

              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                
                /// ✅ Green marker for marked events
                markerDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                markersAlignment: Alignment.bottomCenter, // ✅ Align markers properly
              ),
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

