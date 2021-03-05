import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';

import '../../core/app_config.dart';
import '../api_exceptions.dart';

/// Timeout is increased because we live in Lebanon and we have shitty internet
/// connection.
BaseOptions _requestOptions([String token]) {
  return BaseOptions(
    baseUrl: AppConfig.baseUrl,
    connectTimeout: 5000, // in milliseconds, so = 5 seconds
    receiveTimeout: 20000, // when downloading for example, also in milliseconds
    // the api-key authentication is done on server side
    headers: token == null ? null : {'api-key': token},
    // Always check the response even if it's a 500 error
    validateStatus: (status) => true,
  );
}

Dio basicClient() => Dio(_requestOptions());

Dio authenticatedClient(String token) => Dio(_requestOptions(token));

Dio cachedClient([String token]) {
  final dio = Dio(_requestOptions(token));
  dio.interceptors.add(
    DioCacheManager(CacheConfig(baseUrl: AppConfig.baseUrl)).interceptor
        as InterceptorsWrapper,
  );
  return dio;
}

/// This function acts as a gate-keeper.
/// If the server returns any error, it throws the proper exception and stops
/// the execution of the rest of the code.
/// Any code that needs to be ran when the response is successful must be placed
/// after this function call.
/// This exception is rethrown by the caller so that the UI can handle it.
/// For custom error messages, pass the message as a parameter.
///
/// In case there is an exception by [Dio] it will be thrown when executing the
/// dio call, so before we even get here. [Dio] exceptions can also be handled
/// on the UI side.
void checkErrors(Response response, [String errorMsg]) {
  // Gate clause, nothing to do if request successful (200 code)
  // In case the api uses 200 for unsuccessful responses too, make sure to alter
  // this gate clause accordingly
  if (response.statusCode == 200) {
    return;
  }

  debugPrint(response.data.toString());
  final code = response.data['code'] as int;

  /// We can use the error code to throw custom exceptions when needed
  switch (code) {
    case 500:
      throw const ServerErrorException();
    case 429:
      throw ApiException(
        message: 'You have reached your rate limit. Please try again later',
        code: code,
      );
    default:
      throw ApiException(
        message: response.data['message'] as String,
        code: code,
      );
  }
}
