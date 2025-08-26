import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SkillSelector extends StatefulWidget {
  final String? initialSkill;
  final Function(String?) onSkillSelected;

  const SkillSelector({
    super.key,
    this.initialSkill,
    required this.onSkillSelected,
  });

  @override
  State<SkillSelector> createState() => _SkillSelectorState();
}

class _SkillSelectorState extends State<SkillSelector> {
  String? _selectedSkill;

  @override
  void initState() {
    super.initState();
    _selectedSkill = widget.initialSkill;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Player Skill Level',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _buildSkillChip('Beginner', Colors.green),
            _buildSkillChip('Intermediate', Colors.orange),
            _buildSkillChip('Advanced', Colors.red),
            _buildSkillChip(null, AppConstants.cosmicBlue, label: 'Clear'),
          ],
        ),
      ],
    );
  }

  Widget _buildSkillChip(String? skill, Color color, {String? label}) {
    final bool isSelected = _selectedSkill == skill;

    return FilterChip(
      label: Text(
        label ?? skill!,
        style: TextStyle(
          color: isSelected ? Colors.white : color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      showCheckmark: false,
      backgroundColor: color.withOpacity(0.1),
      selectedColor: color,
      side: BorderSide(color: color.withOpacity(isSelected ? 1.0 : 0.5)),
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedSkill = skill;
          } else {
            _selectedSkill = null;
          }
        });
        widget.onSkillSelected(_selectedSkill);
      },
    );
  }
}

class SkillLegend extends StatelessWidget {
  const SkillLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Skill Level Legend',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildLegendItem(
              'Beginner',
              Colors.green,
              'New or basic level players',
            ),
            const SizedBox(height: 4),
            _buildLegendItem(
              'Intermediate',
              Colors.orange,
              'Experienced amateur players',
            ),
            const SizedBox(height: 4),
            _buildLegendItem(
              'Advanced',
              Colors.red,
              'Competitive or professional level',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String skill, Color color, String description) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color.withOpacity(0.5), width: 1),
          ),
          child: Text(
            skill,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(description, style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}
