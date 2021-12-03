import 'package:flutter/material.dart';

TimeOfDay stringToTimeOfDay(String value) {
  final splited = value.split(":");

  if (splited.length != 2) throw "Cannot format $value to time of day";

  try {
    return TimeOfDay(
      hour: int.parse(splited[0]),
      minute: int.parse(splited[1]),
    );
  } catch (e) {
    rethrow;
  }
}

String timeOfDayToString(TimeOfDay? value) {
  if (value == null) {
    return '';
  }

  return "${to2Digits(value.hour)}:${to2Digits(value.minute)}";
}

String to2Digits(int value) => value.toString().padLeft(2, '0');

String colorToStringRGB(Color color) {
  return "${color.red}-${color.green}-${color.blue}";
}

Color stringRGBToColor(String value) {
  final splited = value.split("-");

  if (splited.length != 3) throw "Cannot format $value to color";

  return Color.fromRGBO(
    toInt(splited[0]),
    toInt(splited[1]),
    toInt(splited[2]),
    1,
  );
}

int toInt(String value) => int.parse(value);
