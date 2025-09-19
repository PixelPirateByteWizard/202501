import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  // Callback to switch tabs in MainScreen
  void Function(int)? _tabSwitcher;
  
  void setTabSwitcher(void Function(int) switcher) {
    _tabSwitcher = switcher;
  }
  
  void switchToTab(int index) {
    _tabSwitcher?.call(index);
  }
  
  void switchToAgenda() {
    switchToTab(0);
  }
  
  void switchToForge() {
    switchToTab(1);
  }
  
  void switchToAIChat() {
    switchToTab(2);
  }
  
  void switchToSettings() {
    switchToTab(3);
  }
  
  BuildContext? get context => navigatorKey.currentContext;
}