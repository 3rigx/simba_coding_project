import 'package:flutter/material.dart';

class Utils {
  static GlobalKey<NavigatorState> mainAppNav = GlobalKey();
  static GlobalKey<NavigatorState> inAppNav = GlobalKey();

  static String deviceSuffix(BuildContext context) {
    String deviceSuffix = '';
    TargetPlatform platform = Theme.of(context).platform;
    switch (platform) {
      case TargetPlatform.android:
        deviceSuffix = '_android';
        break;
      case TargetPlatform.iOS:
        deviceSuffix = '_ios';
        break;
      default:
        deviceSuffix = '';
        break;
    }
    return deviceSuffix;
  }
}
