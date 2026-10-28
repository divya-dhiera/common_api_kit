import 'dart:async';
import 'package:flutter/foundation.dart';

/// A utility class to debounce rapid actions or search inputs.
class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  /// Creates a debouncer with the specified [milliseconds] delay (default is 500ms).
  Debouncer({this.milliseconds = 500});

  /// Runs the given [action] after the delay has elapsed. Cancels any previous pending timer.
  void run(VoidCallback action) {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer(Duration(milliseconds: milliseconds ?? 500), action);
  }
}
