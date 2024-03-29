import 'package:event_bus/event_bus.dart';

import 'package:code_space_client/models/user_model.dart';

EventBus eventBus = EventBus();

class CreateAccountSuccessEvent {
  final UserModel user;

  CreateAccountSuccessEvent({
    required this.user,
  });
}

class UpdateAccountSuccessEvent {
  final UserModel user;

  UpdateAccountSuccessEvent({
    required this.user,
  });
}

// UpdateCourseSuccessEvent: I use event class from course_bloc
// If using cubit instead of bloc, I will create UpdateCourseSuccessEvent right here
