import 'package:flutter/material.dart';
import '../models/milestone_model.dart';

class MilestoneCard extends StatelessWidget {
  final Milestone milestone;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const MilestoneCard({
    Key? key,
    required this.milestone,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final daysRemaining = milestone.daysRemaining;

    // Choose an emoji based on milestone type
    String emoji = '🎉'; // Default emoji
    if (milestone.title.toLowerCase().contains('birthday') ||
        milestone.title.toLowerCase().contains('生日')) {
      emoji = '🎂';
    } else if (milestone.title.toLowerCase().contains('travel') ||
        milestone.title.toLowerCase().contains('trip') ||
        milestone.title.toLowerCase().contains('旅行') ||
        milestone.title.toLowerCase().contains('假期') ||
        milestone.title.toLowerCase().contains('vacation')) {
      emoji = '✈️';
    } else if (milestone.title.toLowerCase().contains('wedding') ||
        milestone.title.toLowerCase().contains('anniversary') ||
        milestone.title.toLowerCase().contains('结婚') ||
        milestone.title.toLowerCase().contains('周年')) {
      emoji = '💍';
    } else if (milestone.title.toLowerCase().contains('workout') ||
        milestone.title.toLowerCase().contains('gym') ||
        milestone.title.toLowerCase().contains('运动')) {
      emoji = '💪';
    } else if (milestone.title.toLowerCase().contains('deadline') ||
        milestone.title.toLowerCase().contains('截止')) {
      emoji = '⏰';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF24263A),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF7F5AF0).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    milestone.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    milestone.description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  daysRemaining.toString(),
                  style: const TextStyle(
                    color: Color(0xFF7F5AF0),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Days',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white70, size: 20),
                  onPressed: onEdit,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon:
                      const Icon(Icons.delete, color: Colors.white70, size: 20),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
