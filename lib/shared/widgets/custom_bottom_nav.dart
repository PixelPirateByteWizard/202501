import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: const Color(0xFF24293A).withOpacity(0.85),
        border: const Border(
          top: BorderSide(color: Colors.white10, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem(0, Icons.dashboard, '仪表盘'),
          _buildTabItem(1, Icons.pie_chart, '市场'),
          _buildAIButton(),
          _buildTabItem(3, Icons.article_outlined, '资讯'),
          _buildTabItem(4, Icons.person_outline, '我的'),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, String label) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive ? const Color(0xFF4A90E2) : const Color(0xFF8B949E),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? const Color(0xFF4A90E2) : const Color(0xFF8B949E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIButton() {
    return GestureDetector(
      onTap: () => onTap(2),
      child: Transform.translate(
        offset: const Offset(0, -25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}