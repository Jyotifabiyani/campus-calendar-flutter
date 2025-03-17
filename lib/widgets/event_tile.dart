import 'dart:io';
import 'package:flutter/material.dart';
import '../models/event_model.dart';

class EventTile extends StatelessWidget {
  final EventModel event;

  const EventTile({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          if (event.posterUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.file(File(event.posterUrl), height: 200, width: double.infinity, fit: BoxFit.cover),
            ),
          ListTile(
            title: Text(event.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${event.description} • ${event.venue}"),
                Text("🗣 Speaker: ${event.speakerName}", style: const TextStyle(fontWeight: FontWeight.w500)),
                Text("📅 ${event.date.toLocal().toString().split(' ')[0]} at ⏰ ${event.time.format(context)}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
