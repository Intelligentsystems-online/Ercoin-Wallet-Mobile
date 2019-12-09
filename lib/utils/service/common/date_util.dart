import 'package:intl/intl.dart';

class DateUtil {
  final _formatter =  DateFormat('yyyy-MM-dd HH:mm:ss');

  String dateTimeFrom(int timestampInSeconds) {
    final datetime = DateTime.fromMillisecondsSinceEpoch(timestampInSeconds * 1000);

    return _formatter.format(datetime);
  }
}