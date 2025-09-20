import 'dart:html' show window;

//For html (web): custom_datetime_web.dart
class CustomDateTime {
  /// Microseconds since Unix epoch.
  final int microsecondsSinceEpoch;

  const CustomDateTime._(this.microsecondsSinceEpoch);

  /// Create from microseconds since epoch.
  factory CustomDateTime.fromMicrosecondsSinceEpoch(int micros) =>
      CustomDateTime._(micros);

  /// Create from milliseconds since epoch.
  factory CustomDateTime.fromMillisecondsSinceEpoch(int millis) =>
      CustomDateTime._((millis * 1000));

  /// Now with improved precision on web using performance.timeOrigin + performance.now()
  ///
  /// Note: `performance.timeOrigin + performance.now()` gives a high-resolution
  /// timestamp in milliseconds relative to the Unix epoch (if supported).
  /// We multiply by 1000 to get microseconds and round to nearest int.
  factory CustomDateTime.now() {
    final perf = window.performance;
    // timeOrigin is usually available and represents epoch ms; performance.now()
    // is high-res (fractional ms) since timeOrigin.
    final timeOrigin = perf.timeOrigin ?? DateTime.now().millisecondsSinceEpoch;
    final highResMs = timeOrigin + perf.now();
    final micros = (highResMs * 1000).round();
    return CustomDateTime._(micros);
  }

  /// Convert to standard DateTime. On web this may lose sub-microsecond fidelity
  /// but preserves microseconds.
  DateTime toDateTime() =>
      DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch);

  /// ISO 8601 with microsecond precision (YYYY-MM-DDTHH:MM:SS.ssssssZ).
  String toIso8601String() {
    final dt = toDateTime().toUtc();
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    final ss = dt.second.toString().padLeft(2, '0');

    final micros = (microsecondsSinceEpoch % Duration.microsecondsPerSecond)
        .toString()
        .padLeft(6, '0');

    return '$y-$m-$d'
        'T$hh:$mm:$ss.${micros}Z';
  }

  /// Add a [Duration].
  CustomDateTime add(Duration d) =>
      CustomDateTime._(microsecondsSinceEpoch + d.inMicroseconds);

  /// Subtract a [Duration].
  CustomDateTime subtract(Duration d) =>
      CustomDateTime._(microsecondsSinceEpoch - d.inMicroseconds);

  /// Difference between two CustomDateTime as a Duration.
  Duration difference(CustomDateTime other) => Duration(
    microseconds: microsecondsSinceEpoch - other.microsecondsSinceEpoch,
  );

  @override
  String toString() => toIso8601String();
}

//For io (mobile): custom_datetime_io.dart
class CustomDateTime {
  /// Microseconds since Unix epoch.
  final int microsecondsSinceEpoch;

  const CustomDateTime._(this.microsecondsSinceEpoch);

  /// Create from microseconds since epoch.
  factory CustomDateTime.fromMicrosecondsSinceEpoch(int micros) =>
      CustomDateTime._(micros);

  /// Create from milliseconds since epoch (converts to microseconds).
  factory CustomDateTime.fromMillisecondsSinceEpoch(int millis) =>
      CustomDateTime._(millis * 1000);

  /// Now with microsecond precision (native DateTime already supports this).
  factory CustomDateTime.now() =>
      CustomDateTime._(DateTime.now().microsecondsSinceEpoch);

  /// Convert to standard DateTime (may be used when platform APIs expect DateTime).
  DateTime toDateTime() =>
      DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch);

  /// ISO 8601 with microsecond precision (YYYY-MM-DDTHH:MM:SS.ssssssZ).
  String toIso8601String() {
    final dt = toDateTime().toUtc();
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    final ss = dt.second.toString().padLeft(2, '0');

    // microseconds part
    final micros = (microsecondsSinceEpoch % Duration.microsecondsPerSecond)
        .toString()
        .padLeft(6, '0');

    return '$y-$m-$d'
        'T$hh:$mm:$ss.${micros}Z';
  }

  /// Add a [Duration].
  CustomDateTime add(Duration d) =>
      CustomDateTime._(microsecondsSinceEpoch + d.inMicroseconds);

  /// Subtract a [Duration].
  CustomDateTime subtract(Duration d) =>
      CustomDateTime._(microsecondsSinceEpoch - d.inMicroseconds);

  /// Difference between two CustomDateTime as a Duration.
  Duration difference(CustomDateTime other) => Duration(
    microseconds: microsecondsSinceEpoch - other.microsecondsSinceEpoch,
  );

  @override
  String toString() => toIso8601String();
}

import 'package:gapopa_test/tasks/day_1_4/custom_datetime_io.dart'
    if (dart.library.html) 'package:gapopa_test/tasks/day_1_4/custom_datetime_web.dart'; 

void main() {
  // Create a native and web implementations for a custom [DateTime], supporting
  // microseconds. Use conditional compilation to export the class for general
  // use on any platform.

  final now = CustomDateTime.now();
  print('CustomDateTime: $now'); // microsecond-precision ISO string

  final dt = now.toDateTime(); // interop with DateTime APIs
  print('Native DateTime: $dt');
}
