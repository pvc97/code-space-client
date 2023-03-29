import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String get hhmmddMMyyyy {
    return DateFormat('HH:mm dd/MM/yyyy').format(this);
  }
}
