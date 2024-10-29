import 'dart:developer';

void console(dynamic message, {Object? error, StackTrace? stackTrace}) {
  log("$message", error: error, stackTrace: stackTrace);
}

void logger(dynamic message, {Object? error, StackTrace? stackTrace}) {
  log("$message", error: error, stackTrace: stackTrace);
}
