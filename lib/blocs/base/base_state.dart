import 'package:code_space_client/models/app_exception.dart';
import 'package:equatable/equatable.dart';

enum StateStatus { initial, loading, success, error }

abstract class BaseState extends Equatable {
  final StateStatus stateStatus;
  final AppException? error;

  const BaseState({
    required this.stateStatus,
    this.error,
  });

  @override
  List<Object?> get props => [stateStatus, error];
}