import 'package:equatable/equatable.dart';

class AppException extends Equatable implements Exception {
  final int code;
  final String? message;

  const AppException({this.code = 0, this.message});

  @override
  List<Object?> get props => [code, message];
}

class UnAuthException extends AppException {
  const UnAuthException(String message) : super(message: message);
}

class NoNetworkException extends AppException {
  const NoNetworkException();
}

class CommonException extends AppException {
  const CommonException({String? message = 'Something went wrong'})
      : super(message: message);
}
