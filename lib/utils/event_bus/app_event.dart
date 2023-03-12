import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class CreateProblemSuccessEvent {
  final String courseId;

  CreateProblemSuccessEvent({required this.courseId});
}

class CreateAccountSuccessEvent {}

// UpdateCourseSuccessEvent: I use event class from course_bloc
// If using cubit instead of bloc, I will create UpdateCourseSuccessEvent right here
