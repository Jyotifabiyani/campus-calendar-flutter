import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_model.dart';

class AdminEventScreen extends StatefulWidget {
  @override
  _AdminEventScreenState createState() => _AdminEventScreenState();
}

class _AdminEventScreenState extends State<AdminEventScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  _saveEvent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime eventDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    Event newEvent = Event(
      name: _nameController.text,
      description: _descController.text,
      venue: _venueController.text,
      dateTime: eventDateTime,
    );

    List<String> events = prefs.getStringList('events') ?? [];
    events.add(newEvent.toJson().toString());
    prefs.setStringList('events', events);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Event Added!")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Event")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: "Event Name")),
            TextField(controller: _descController, decoration: InputDecoration(labelText: "Description")),
            TextField(controller: _venueController, decoration: InputDecoration(labelText: "Venue")),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _pickDate, child: Text("Select Date")),
            ElevatedButton(onPressed: _pickTime, child: Text("Select Time")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveEvent, child: Text("Save Event")),
          ],
        ),
      ),
    );
  }
}
