import 'package:code_space_client/models/app_exception.dart';
import 'package:equatable/equatable.dart';

enum BaseStatus { initial, loading, success, error }

abstract class BaseState extends Equatable {
  final int page;
  final BaseStatus status;
  final AppException? error;

  const BaseState({
    this.page = 0,
    this.error,
    required this.status,
  });

  @override
  List<Object?> get props => [page, status, error];
}
