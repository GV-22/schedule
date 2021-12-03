import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

String translate(
  String key,
  BuildContext context,
  Map<String, Map<String, String>> localizedValues,
) {
  // printLog(message: 'translate loc values: ${localizedValues.hashCode}');
  final locale = Localizations.localeOf(context);
  final languageCode = locale.languageCode;
  final defaultLocValues = localizedValues['en'];
  // printLog(message: 'localeCode => $languageCode');
  // print('localeCode => $languageCode');
  final locValues = localizedValues[languageCode] ?? defaultLocValues;

  if (locValues == null) return key;
  if (locValues.containsKey(key)) return locValues[key]!;
  if (defaultLocValues == null) return key;
  if (defaultLocValues.containsKey(key)) return defaultLocValues[key]!;

  return key;
}

int getIndex<T>(T item, List<T> arrays) {
  final int index = arrays.indexOf(item);
  if (index == -1) {
    throw "Unknown $T: '${item.toString()}'";
  }

  return index;
}

String toCapitalize(String value) =>
    "${value[0].toUpperCase()}${value.substring(1, value.length)}";

void printLog({required String message, int? width, bool throttled = false}) {
  if (throttled) {
    debugPrintThrottled(message, wrapWidth: width);
  } else {
    debugPrintSynchronously(message, wrapWidth: width);
  }
}

double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

MaterialColor createMaterialColor(Color color) {
  final List<double> strengths = [.05];
  final Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  // ignore: avoid_function_literals_in_foreach_calls
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
