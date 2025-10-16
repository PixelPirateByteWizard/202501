import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';

class CustomStatusBar extends StatefulWidget {
  const CustomStatusBar({super.key});

  @override
  State<CustomStatusBar> createState() => _CustomStatusBarState();
}

class _CustomStatusBarState extends State<CustomStatusBar> {
  late Timer _timer;
  String _currentTime = '';
  int _batteryLevel = 100;
  final bool _isCharging = false;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
      _simulateBatteryDrain();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    });
  }

  void _simulateBatteryDrain() {
    // Simulate slow battery drain for immersion
    if (!_isCharging && _batteryLevel > 0) {
      setState(() {
        if (DateTime.now().second % 30 == 0) {
          _batteryLevel = (_batteryLevel - 1).clamp(0, 100);
        }
      });
    }
  }

  IconData _getBatteryIcon() {
    if (_isCharging) return Icons.battery_charging_full;
    if (_batteryLevel > 90) return Icons.battery_full;
    if (_batteryLevel > 60) return Icons.battery_6_bar;
    if (_batteryLevel > 30) return Icons.battery_4_bar;
    if (_batteryLevel > 10) return Icons.battery_2_bar;
    return Icons.battery_alert;
  }

  Color _getBatteryColor() {
    if (_isCharging) return AppColors.statusOptimal;
    if (_batteryLevel > 20) return AppColors.lavenderWhite;
    return AppColors.statusError;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: const BoxDecoration(
        color: AppColors.slateBlue,
        border: Border(
          bottom: BorderSide(color: AppColors.glassBorder, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Time and Game Status
            Row(
              children: [
                Text(
                  _currentTime,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.vintageGold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'ACTIVE',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.vintageGold,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // System Status Icons
            Row(
              children: [
                const Icon(
                  Icons.signal_cellular_4_bar,
                  color: AppColors.lavenderWhite,
                  size: 16,
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.wifi,
                  color: AppColors.lavenderWhite,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Icon(_getBatteryIcon(), color: _getBatteryColor(), size: 16),
                const SizedBox(width: 2),
                Text(
                  '$_batteryLevel%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _getBatteryColor(),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
