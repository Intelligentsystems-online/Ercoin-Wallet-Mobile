class DateUtil {
  static DateTime dateTimeFrom(int timestampInSeconds) => new DateTime.fromMillisecondsSinceEpoch(timestampInSeconds * 1000);
}