import 'package:intl/intl.dart';

class DateUtil {
  final _formatter =  DateFormat('yyyy-MM-dd HH:mm:ss');

//  static DateTime dateTimeFrom(int timestampInSeconds) => new DateTime.fromMillisecondsSinceEpoch(timestampInSeconds * 1000);

  String dateTimeFrom(int timestampInSeconds) {
    final datatime = DateTime.fromMillisecondsSinceEpoch(timestampInSeconds * 1000);

    return _formatter.format(datatime);
  }
}