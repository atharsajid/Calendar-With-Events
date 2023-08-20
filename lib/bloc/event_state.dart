

abstract class EventDetailsState {
  const EventDetailsState();
}

class EventDetailsInitial extends EventDetailsState {}

class EventDetailsLoading extends EventDetailsState {}

class EventDetailsLoaded extends EventDetailsState {
  final bool eventExists;
  final bool showLoadingIndicator;
  EventDetailsLoaded({
    required this.eventExists,
    this.showLoadingIndicator = false,
  });
}

class EventDetailsError extends EventDetailsState {
  final String message;
  final bool isError;

  EventDetailsError({
    required this.message,
    this.isError = false,
  });
}
