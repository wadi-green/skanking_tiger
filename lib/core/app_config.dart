class AppConfig {
  /// The base url used for the API requests
  /// NOTE: make sure it doesn't end with a trailing "/"
  static const baseUrl = 'http://192.168.178.54:8080/rest';

  /// Can be displayed to users when they need to contact the app's support
  static const supportEmail = 'support@wadi.green';
}

/// Keys used for shared preferences or local data
class LocalKeys {
  static const authUser = 'authUser';
  static const tokenData = 'tokenData';
}
