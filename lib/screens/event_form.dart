import 'package:device_calendar_example/bloc/event_bloc.dart';
import 'package:device_calendar_example/bloc/event_details_event.dart';
import 'package:device_calendar_example/bloc/event_state.dart';
import 'package:device_calendar_example/model/event.dart';
import 'package:device_calendar_example/screens/custom_text_Field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EventForm extends StatelessWidget {
  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  final TextEditingController eventTitle = TextEditingController();
  final TextEditingController eventDescription = TextEditingController();
  final CalendarBloc bloc = CalendarBloc();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      bloc: bloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Event Form'),
          ),
          body: Column(
            children: [
              CustomTextField(
                inputController: eventTitle,
                hintText: 'Event Title',
              ),
              CustomTextField(
                inputController: eventDescription,
                hintText: 'Event Description',
              ),
              CustomDateField(
                inputController: startDate,
                onTap: () async {
                  DateTime? _date = await _showDatePicker(context);
                  if (_date != null) {
                    startDate.text = DateFormat('MMM d, yyyy').format(_date);
                  }
                },
                hintText: 'Event Start Date',
              ),
              CustomDateField(
                inputController: endDate,
                onTap: () async {
                  DateTime? _date = await _showDatePicker(context);
                  if (_date != null) {
                    endDate.text = DateFormat('MMM d, yyyy').format(_date);
                  }
                },
                hintText: 'Event End Date',
              ),
              ElevatedButton(
                onPressed: () {
                  bloc.add(CreateCalendarEvent(
                      event: Event.creatEvent(
                        name: eventTitle.text,
                        startDate: startDate.text,
                        endDate: endDate.text,
                        detail: eventDescription.text,
                      ),
                      context: context));
                },
                child: Text('Add Event'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<DateTime?> _showDatePicker(BuildContext context) async {
    return showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2024));
  }
}
