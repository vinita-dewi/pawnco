import 'package:intl/intl.dart';

class Date {
  static String convert(DateTime date) => DateFormat.yMMMEd().format(date);
}
