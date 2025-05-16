import 'package:flutter/material.dart';
import 'screens/pomodoro_screen.dart';
import 'screens/milestones_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';

class DysphorApp extends StatefulWidget {
  DysphorApp({Key? key}) : super(key: key);

  // Static key to access the app state from anywhere
  static final GlobalKey<_DysphorAppState> appKey =
      GlobalKey<_DysphorAppState>();

  // Static method to navigate to a specific tab
  static void navigateToTab(int index) {
    appKey.currentState?.navigateToTab(index);
  }

  @override
  State<DysphorApp> createState() => _DysphorAppState();
}

class _DysphorAppState extends State<DysphorApp> {
  int _currentIndex = 0;
  bool _isLoading = true;

  // Method to navigate to a specific tab
  void navigateToTab(int index) {
    if (index >= 0 && index < _screens.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _onSplashComplete() {
    setState(() {
      _isLoading = false;
    });
  }

  // Keep track of screen instances to preserve state
  final List<Widget> _screens = [
    const MilestonesScreen(),
    const PomodoroScreen(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dysphor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF7F5AF0),
        scaffoldBackgroundColor: const Color(0xFF16161A),
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF7F5AF0),
          secondary: Color(0xFF2CB67D),
          background: Color(0xFF16161A),
          surface: Color(0xFF24263A),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF16161A),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        useMaterial3: true,
      ),
      home: _isLoading
          ? SplashScreen(onComplete: _onSplashComplete)
          : Scaffold(
              body: IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF24263A),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  backgroundColor: const Color(0xFF24263A),
                  selectedItemColor: const Color(0xFF7F5AF0),
                  unselectedItemColor: Colors.white.withOpacity(0.5),
                  type: BottomNavigationBarType.fixed,
                  elevation: 0,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today),
                      label: 'Milestones',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.timer),
                      label: 'Pomodoro',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.history),
                      label: 'History',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: 'Settings',
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
