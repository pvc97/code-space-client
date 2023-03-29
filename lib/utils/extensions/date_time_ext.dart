import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String get type1 {
    return DateFormat('HH:mm dd/MM/yyyy').format(this);
  }
}
