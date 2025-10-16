import 'package:flutter/material.dart';

class OnboardingPage {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final List<String> features;
  final String? backgroundPattern;

  const OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.features,
    this.backgroundPattern,
  });
}