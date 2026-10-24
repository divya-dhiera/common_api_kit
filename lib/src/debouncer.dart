import 'dart:async';
import 'package:flutter/foundation.dart';

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  Debouncer({this.milliseconds = 500});

  void run(VoidCallback action) {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer(Duration(milliseconds: milliseconds ?? 500), action);
  }
}
