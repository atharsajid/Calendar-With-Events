

abstract class CalendarState {
  const CalendarState();
}

class EventDetailsInitial extends CalendarState {}

class EventDetailsLoading extends CalendarState {}

class EventDetailsLoaded extends CalendarState {
  final bool eventExists;
  final bool showLoadingIndicator;
  EventDetailsLoaded({
    required this.eventExists,
    this.showLoadingIndicator = false,
  });
}

class EventDetailsError extends CalendarState {
  final String message;
  final bool isError;

  EventDetailsError({
    required this.message,
    this.isError = false,
  });
}
