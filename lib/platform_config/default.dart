import 'dart:io';

/// A utility class to determine the current platform the app is running on.
/// This is the default implementation for non-web platforms.
class AppPlatform {
  /// Whether the app is running on Android.
  static bool isAndroid = Platform.isAndroid;

  /// Whether the app is running on iOS.
  static bool isIOS = Platform.isIOS;

  /// Whether the app is running on Fuchsia.
  static bool isFuchsia = Platform.isFuchsia;

  /// Whether the app is running on Windows.
  static bool isWindows = Platform.isWindows;

  /// Whether the app is running on Linux.
  static bool isLinux = Platform.isLinux;

  /// Whether the app is running on macOS.
  static bool isMacOS = Platform.isMacOS;

  /// Whether the app is running on the Web.
  static bool isWeb = false;

  /// Whether the app is running on a desktop platform (macOS, Windows, or Linux).
  static bool isDesktop = isMacOS || isWindows || isLinux;

  /// Whether the app is running on a mobile platform (Android, iOS, or Fuchsia).
  static bool isPhone = isAndroid || isIOS || isFuchsia;
}
