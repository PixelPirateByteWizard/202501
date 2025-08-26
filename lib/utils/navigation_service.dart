import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static NavigatorState? get navigator => navigatorKey.currentState;

  static Future<dynamic> navigateTo(Widget page) {
    return navigator!.push(MaterialPageRoute(builder: (context) => page));
  }

  static Future<dynamic> navigateToReplacement(Widget page) {
    return navigator!.pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static void goBack() {
    return navigator!.pop();
  }
}
