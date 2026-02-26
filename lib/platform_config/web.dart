/// A utility class to determine the current platform the app is running on.
/// This is the web-specific implementation.
class AppPlatform {
  /// Whether the app is running on Android.
  static bool isAndroid = false;

  /// Whether the app is running on iOS.
  static bool isIOS = false;

  /// Whether the app is running on Fuchsia.
  static bool isFuchsia = false;

  /// Whether the app is running on Windows.
  static bool isWindows = false;

  /// Whether the app is running on Linux.
  static bool isLinux = false;

  /// Whether the app is running on macOS.
  static bool isMacOS = false;

  /// Whether the app is running on the Web.
  static bool isWeb = true;

  /// Whether the app is running on a desktop platform.
  static bool isDesktop = false;

  /// Whether the app is running on a mobile platform.
  static bool isPhone = false;
}
