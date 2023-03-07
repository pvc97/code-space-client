import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class CreateProblemSuccessEvent {
  final String courseId;

  CreateProblemSuccessEvent({required this.courseId});
}

class CreateAccountSuccessEvent {}
