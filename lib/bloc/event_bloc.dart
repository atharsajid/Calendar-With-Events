import 'dart:developer';

import 'package:device_calendar/device_calendar.dart' as cal;
import 'package:device_calendar_example/bloc/event_details_event.dart';
import 'package:device_calendar_example/bloc/event_state.dart';
import 'package:device_calendar_example/controller/event_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarBloc extends Bloc<EventDetailsEvent, CalendarState> {
  static CalendarBloc bloc = CalendarBloc();

  late cal.DeviceCalendarPlugin _deviceCalendarPlugin;
  bool _requestSent = false;
  String kErrorStringGeneric = 'Oops Something went wrong';
  CalendarBloc() : super(EventDetailsInitial()) {
    _deviceCalendarPlugin = cal.DeviceCalendarPlugin();
    on<CreateCalendarEvent>((CreateCalendarEvent event, Emitter<CalendarState> emit) async {
      try {
        cal.Result<bool> permissionResult = await _deviceCalendarPlugin.requestPermissions();
        if (!_requestSent) {
          if (permissionResult.isSuccess) {
            final bool result = await CalendarEventsRepository.repo.saveOrDeleteEvent(event.event);
            if (result) {
              emit(
                EventDetailsLoaded(
                  eventExists: await CalendarEventsRepository.repo.eventExists(event.event),
                  showLoadingIndicator: true,
                ),
              );
            } else {
              emit(
                EventDetailsError(
                  message: kErrorStringGeneric,
                  isError: true,
                ),
              );
            }
            _requestSent = true;
          } else {
            permissionResult = await _deviceCalendarPlugin.hasPermissions();
            if (permissionResult.isSuccess) {
              final bool result = await CalendarEventsRepository.repo.saveOrDeleteEvent(event.event);
              if (result) {
                emit(
                  EventDetailsLoaded(
                    eventExists: await CalendarEventsRepository.repo.eventExists(event.event),
                    showLoadingIndicator: true,
                  ),
                );
              } else {
                emit(
                  EventDetailsError(
                    message: kErrorStringGeneric,
                    isError: true,
                  ),
                );
              }
              _requestSent = true;
            } else {
              if (permissionResult.hasErrors) {
                for (final cal.ResultError error in permissionResult.errors) {
                  log(
                    error.errorMessage,
                    error: Exception('Error on EventsDetails'),
                  );
                  _requestSent = true;
                }
              }
            }
          }

          Future<dynamic>.delayed(
            const Duration(
              seconds: 1,
            ),
          ).then(
            (dynamic value) => <dynamic>{
              _requestSent = false,
            },
          );
        }
      } catch (error, stackTrace) {
        log('Error', error: error);
      }
    });
    on<CheckEventExists>((CheckEventExists event, Emitter<CalendarState> emit) async {
      try {
        cal.Result<bool> permissionResult = await _deviceCalendarPlugin.requestPermissions();
        if (permissionResult.isSuccess) {
          final bool result = await CalendarEventsRepository.repo.eventExists(event.event);
          emit(EventDetailsLoaded(eventExists: result));
        } else {
          permissionResult = await _deviceCalendarPlugin.hasPermissions();
          if (permissionResult.isSuccess) {
            final bool result = await CalendarEventsRepository.repo.eventExists(event.event);
            emit(EventDetailsLoaded(eventExists: result));
          } else {
            if (permissionResult.hasErrors) {
              for (final cal.ResultError error in permissionResult.errors) {
                log(
                  error.errorMessage,
                  error: Exception('Error on EventsDetails'),
                );
              }
            }
          }
        }
      } catch (error, stackTrace) {
        log('Error', error: error);
      }
    });
  }
}
