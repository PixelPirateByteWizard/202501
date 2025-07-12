import 'dart:math';
import 'dart:ui';
import 'package:astrelexis/models/journal_entry.dart';
import 'package:astrelexis/screens/journal/add_journal_screen.dart';
import 'package:astrelexis/screens/memory/add_memory_screen.dart';
import 'package:astrelexis/screens/todo/add_todo_screen.dart';
import 'package:astrelexis/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FabMenu extends StatefulWidget {
  final VoidCallback? onJournalAdded;
  final VoidCallback? onTodoAdded;
  final VoidCallback? onMemoryAdded;

  const FabMenu({
    super.key,
    this.onJournalAdded,
    this.onTodoAdded,
    this.onMemoryAdded,
  });

  @override
  State<FabMenu> createState() => _FabMenuState();
}

class _FabMenuState extends State<FabMenu> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Full screen backdrop overlay
        if (_controller.status != AnimationStatus.dismissed)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleMenu,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
          ),
        // Menu items and FAB positioned at bottom right
        Positioned(
          bottom: 100,
          right: 24,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              ..._buildMenuItems(),
              _buildFab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFab() {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [AppColors.fabGradientStart, AppColors.fabGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: _toggleMenu,
          child: RotationTransition(
            turns: _rotationAnimation,
            child: const Icon(Icons.add, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMenuItems() {
    final menuItems = [
      {
        'icon': FontAwesomeIcons.bookOpen,
        'label': 'Entry',
        'angle': -pi / 2, // Directly up
        'action': () => _openAddJournalScreen(),
      },
      {
        'icon': FontAwesomeIcons.squareCheck,
        'label': 'To-Do',
        'angle': -pi * 2 / 3, // Upper left
        'action': () => _openAddTodoScreen(),
      },
      {
        'icon': FontAwesomeIcons.image,
        'label': 'Memory',
        'angle': -pi * 4 / 6, // Left
        'action': () => _openAddMemoryScreen(),
      },
    ];

    return menuItems.map((item) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final radius = 120.0 * _scaleAnimation.value;
          final angle = item['angle'] as double;
          return Transform.translate(
            offset: Offset(radius * cos(angle), radius * sin(angle)),
            child: Opacity(
              opacity: _scaleAnimation.value,
              child: child,
            ),
          );
        },
        child: _buildMenuItem(
          item['icon'] as IconData,
          item['label'] as String,
          item['action'] as VoidCallback,
        ),
      );
    }).toList();
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () {
          _toggleMenu();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.glassBg.withOpacity(0.9),
                  border: Border.all(color: AppColors.glassBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: AppColors.textPrimary, size: 20),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.glassBg.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openAddJournalScreen() {
    Navigator.of(context)
        .push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddJournalScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    )
        .then((result) {
      if (result is JournalEntry && widget.onJournalAdded != null) {
        widget.onJournalAdded!();
      }
    });
  }

  void _openAddTodoScreen() {
    Navigator.of(context)
        .push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddTodoScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    )
        .then((result) {
      if (result != null && widget.onTodoAdded != null) {
        widget.onTodoAdded!();
      }
    });
  }

  void _openAddMemoryScreen() {
    Navigator.of(context)
        .push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddMemoryScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    )
        .then((result) {
      if (result != null && widget.onMemoryAdded != null) {
        widget.onMemoryAdded!();
      }
    });
  }
}
