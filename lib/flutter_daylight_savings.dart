import 'dart:async';
import 'package:flutter/services.dart';

class DstTransition {
  final int timestamp;
  final int offset; /// in minutes

  DstTransition({required this.timestamp, required this.offset});

  factory DstTransition.fromMap(Map<dynamic, dynamic> map) {
    return DstTransition(
      timestamp: map['timestamp'].toInt(),
      offset: map['offset'].toInt(),
    );
  }
}


class FlutterDaylightSavings {
  static const MethodChannel _channel = const MethodChannel('flutter_daylight_savings/methods');

  /// Get the next daylight savings transitions for the current timezone
  static Future<List<DstTransition>> getNextTransitions({required int count}) async {
    final List<dynamic> result = await _channel.invokeMethod('getNextTransitions', {
      'count': count,
    });

    return result.map((item) => DstTransition.fromMap(item)).toList();
  }
}
