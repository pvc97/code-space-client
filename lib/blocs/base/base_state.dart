import 'package:code_space_client/models/app_exception.dart';
import 'package:equatable/equatable.dart';

enum StateStatus { initial, loading, success, error }

/// All states of blocs should extend this class
/// Derived class can use stateStatus to manage an state (EX: load data from server)
/// If it wants to manage more than one status like update, delete, create,...
/// It can add more StateStatus
abstract class BaseState extends Equatable {
  final StateStatus stateStatus;
  final AppException? error;

  const BaseState({
    required this.stateStatus,
    this.error,
  });

  // @override
  // List<Object?> get props => [stateStatus, error];
}
