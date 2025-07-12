import 'package:flutter/material.dart';
import 'dart:math';
import '../utils/app_colors.dart';

class MoodHeatmap extends StatelessWidget {
  const MoodHeatmap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 这是一个模拟数据，实际应用中会从 StorageService 获取
    final random = Random();
    final data = List.generate(140, (index) => random.nextDouble());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 月份标签
        const Padding(
          padding: EdgeInsets.only(left: 32.0, bottom: 8.0),
          child: Row(
            children: [
              Expanded(child: Text('Mar', style: TextStyle(color: AppColors.textSecondary, fontSize: 12))),
              Expanded(child: Text('Apr', style: TextStyle(color: AppColors.textSecondary, fontSize: 12))),
              Expanded(child: Text('May', style: TextStyle(color: AppColors.textSecondary, fontSize: 12))),
              Expanded(child: Text('Jun', style: TextStyle(color: AppColors.textSecondary, fontSize: 12))),
            ],
          ),
        ),
        Row(
          children: [
            // 星期标签
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('M', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  SizedBox(height: 16),
                  Text('W', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  SizedBox(height: 16),
                  Text('F', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            // 热力图网格
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: 140,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final intensity = data[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.accentTeal.withOpacity(intensity * 0.8 + 0.1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
         // 图例
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('Less', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(width: 4),
            Container(width: 12, height: 12, color: AppColors.accentTeal.withOpacity(0.2),),
            const SizedBox(width: 2),
            Container(width: 12, height: 12, color: AppColors.accentTeal.withOpacity(0.5),),
            const SizedBox(width: 2),
            Container(width: 12, height: 12, color: AppColors.accentTeal.withOpacity(0.8),),
            const SizedBox(width: 4),
            const Text('More', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
