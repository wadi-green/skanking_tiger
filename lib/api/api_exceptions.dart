import 'package:flutter/material.dart';

import '../utils/strings.dart';

/// Custom [Exception] used to pass API messages to the user
@immutable
class ApiException implements Exception {
  /// Creates an ApiException with the given message
  const ApiException({String message, this.code}) : _message = message;

  /// The message to be displayed to the user
  /// Defaults to "Something went wrong"
  final String _message;
  String get message => _message ?? Strings.genericError;

  /// Optional error code returned by the API
  final int code;

  @override
  String toString() => message;
}

class ServerErrorException implements Exception {
  const ServerErrorException();

  @override
  String toString() => Strings.serverError500;
}
