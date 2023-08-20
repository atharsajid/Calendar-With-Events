import 'package:event_app/model/event.dart';
import 'package:flutter/material.dart';

abstract class EventDetailsEvent {
  const EventDetailsEvent();
}

class CreateCalendarEvent extends EventDetailsEvent {
  final Event event;
  final BuildContext context;
  CreateCalendarEvent({required this.event, required this.context});
}

class CheckEventExists extends EventDetailsEvent {
  final Event event;
  CheckEventExists({required this.event});
}
