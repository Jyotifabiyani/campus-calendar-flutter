import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../services/event_service.dart';
import '../models/event_model.dart';
import 'package:uuid/uuid.dart';

class AddEventScreen extends StatefulWidget {
  final String adminName;

  const AddEventScreen({Key? key, required this.adminName}) : super(key: key);

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _speakerController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  XFile? _selectedImage;
  final EventService _eventService = EventService();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _venueController.dispose();
    _speakerController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => _selectedImage = pickedFile);
    }
  }

  void _addEvent() {
    if (_nameController.text.isEmpty ||
        _descController.text.isEmpty ||
        _venueController.text.isEmpty ||
        _speakerController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null ||
        _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields & select an image")),
      );
      return;
    }

    EventModel event = EventModel(
      id: Uuid().v4(),
      name: _nameController.text,
      description: _descController.text,
      venue: _venueController.text,
      speaker: _speakerController.text,
      posterUrl: _selectedImage!.path,  // Store image path or URL
      date: _selectedDate!,
      time: _selectedTime!,
      createdBy: widget.adminName,
    );

    _eventService.addEvent(event);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Event Added Successfully")),
    );
    Navigator.pop(context);
  }

  Widget displayImage(String path) {
    if (kIsWeb) {
      return Image.network(path, height: 150, width: 150, fit: BoxFit.cover);
    } else {
      return Image.file(File(path), height: 150, width: 150, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Event")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Event Name"),
              ),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextField(
                controller: _venueController,
                decoration: const InputDecoration(labelText: "Venue"),
              ),
              TextField(
                controller: _speakerController,
                decoration: const InputDecoration(labelText: "Speaker Name"),
              ),
              // Date Picker
              ListTile(
                title: Text(
                  _selectedDate == null
                      ? "Select Date"
                      : "Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate != null) {
                    setState(() => _selectedDate = pickedDate);
                  }
                },
              ),
              // Time Picker
              ListTile(
                title: Text(
                  _selectedTime == null
                      ? "Select Time"
                      : "Time: ${_selectedTime!.format(context)}",
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() => _selectedTime = pickedTime);
                  }
                },
              ),
              const SizedBox(height: 10),
              // Image Picker
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text("Pick Poster"),
                  ),
                  const SizedBox(width: 10),
                  _selectedImage != null ? displayImage(_selectedImage!.path) : Container(),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _addEvent, child: const Text("Add Event")),
            ],
          ),
        ),
      ),
    );
  }
}
