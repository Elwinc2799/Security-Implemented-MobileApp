import 'package:logger/logger.dart';

Logger getLogger(String className) {
  return Logger(printer: SimpleLogPrinter(className));
}

class SimpleLogPrinter extends LogPrinter {
  final String className;
  SimpleLogPrinter(this.className);

  @override
  void log(LogEvent event) {
    final color = PrettyPrinter.levelColors[event.level];
    final emoji = PrettyPrinter.levelEmojis[event.level];

    DateTime timeNow = DateTime.now();
    var year = timeNow.year;
    var month = timeNow.month;
    var day = timeNow.day;
    var hour = timeNow.hour;
    var minute = timeNow.minute;
    var second = timeNow.second;
    var level = event.level;

    println(color('----------------------------------------------------------------------------------------------------------'));
    println(color('  Date: $year-$month-$day  Time: $hour:$minute:$second  '));
    println(color('  ${level}  $emoji$className: ${event.message}'));
    println(color('----------------------------------------------------------------------------------------------------------'));
  }
}