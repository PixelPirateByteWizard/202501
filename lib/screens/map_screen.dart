import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

import '../widgets/progress_bar.dart';
import '../services/game_data_service.dart';
import '../models/expedition.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GameDataService _gameDataService = GameDataService();
  List<Expedition> _expeditions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExpeditions();
  }

  Future<void> _loadExpeditions() async {
    final expeditions = await _gameDataService.getExpeditions();
    setState(() {
      _expeditions = expeditions;
      _isLoading = false;
    });
  }

  void _dispatchExpedition(Expedition expedition) {
    if (expedition.status == ExpeditionStatus.ready) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.slateBlue,
          title: Text(
            expedition.name,
            style: const TextStyle(color: AppColors.vintageGold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                expedition.description,
                style: const TextStyle(color: AppColors.lavenderWhite),
              ),
              const SizedBox(height: 16),
              Text(
                'Duration: ${expedition.duration.inHours}h ${expedition.duration.inMinutes % 60}m',
                style: const TextStyle(color: AppColors.lavenderWhite),
              ),
              const SizedBox(height: 8),
              Text(
                'Success Rate: ${(expedition.successRate * 100).toInt()}%',
                style: const TextStyle(color: AppColors.vintageGold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Requirements:',
                style: TextStyle(
                  color: AppColors.vintageGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...expedition.requirements.entries.map(
                (entry) => Text(
                  '• ${entry.key}: ${entry.value}',
                  style: const TextStyle(color: AppColors.lavenderWhite),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Potential Rewards:',
                style: TextStyle(
                  color: AppColors.vintageGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...expedition.rewards.entries.map(
                (entry) => Text(
                  '• ${entry.key}: ${entry.value}',
                  style: const TextStyle(color: AppColors.statusOptimal),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.lavenderWhite),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startExpedition(expedition);
              },
              child: const Text('Dispatch'),
            ),
          ],
        ),
      );
    }
  }

  void _startExpedition(Expedition expedition) {
    final updatedExpedition = expedition.copyWith(
      status: ExpeditionStatus.inProgress,
      startTime: DateTime.now(),
    );

    setState(() {
      final index = _expeditions.indexWhere((e) => e.id == expedition.id);
      if (index != -1) {
        _expeditions[index] = updatedExpedition;
      }
    });

    _gameDataService.saveExpeditions(_expeditions);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${expedition.name} expedition dispatched!'),
        backgroundColor: AppColors.statusOptimal,
      ),
    );
  }

  void _onMapLocationTap(String locationName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.slateBlue,
        title: Text(
          locationName,
          style: const TextStyle(color: AppColors.vintageGold),
        ),
        content: const Text(
          'This location has been explored. Check the archive for discovered clues.',
          style: TextStyle(color: AppColors.lavenderWhite),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: AppColors.vintageGold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.vintageGold),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.deepNavy, AppColors.slateBlue],
          ),
        ),
        child: SafeArea(
          child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Header
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.lavenderWhite,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'World Map',
                              style: Theme.of(context).textTheme.displaySmall,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // Interactive Map Container
                              GlassCard(
                                child: Container(
                                  height: 400,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.deepNavy,
                                        AppColors.slateBlue,
                                      ],
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      // Background terrain
                                      Positioned.fill(
                                        child: CustomPaint(
                                          painter: MapTerrainPainter(),
                                        ),
                                      ),

                                      // Fog of war effect
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          gradient: RadialGradient(
                                            center: const Alignment(0.2, -0.2),
                                            radius: 1.2,
                                            colors: [
                                              Colors.transparent,
                                              AppColors.deepNavy.withValues(alpha: 0.3),
                                              AppColors.deepNavy.withValues(alpha: 0.8),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Districts
                                      Positioned(
                                        top: 80,
                                        left: 40,
                                        child: _buildDistrict(
                                          'Old Town\nDistrict',
                                          140,
                                          100,
                                          true,
                                        ),
                                      ),
                                      Positioned(
                                        top: 60,
                                        left: 200,
                                        child: _buildDistrict(
                                          'Industrial\nQuarter',
                                          120,
                                          80,
                                          false,
                                        ),
                                      ),
                                      Positioned(
                                        top: 200,
                                        left: 80,
                                        child: _buildDistrict(
                                          'Underground\nTunnels',
                                          160,
                                          60,
                                          false,
                                        ),
                                      ),

                                      // Points of Interest with enhanced markers
                                      Positioned(
                                        top: 120,
                                        left: 90,
                                        child: _buildEnhancedMarker(
                                          Icons.book,
                                          'Old Library',
                                          'Discovered',
                                          AppColors.statusOptimal,
                                          () => _onMapLocationTap('Old Library'),
                                        ),
                                      ),
                                      Positioned(
                                        top: 180,
                                        left: 150,
                                        child: _buildEnhancedMarker(
                                          Icons.factory,
                                          'Abandoned Factory',
                                          'Exploring',
                                          AppColors.statusWarning,
                                          () => _onMapLocationTap('Abandoned Factory'),
                                        ),
                                      ),
                                      Positioned(
                                        top: 90,
                                        left: 210,
                                        child: _buildEnhancedMarker(
                                          Icons.apartment,
                                          'Clock Tower',
                                          'Locked',
                                          AppColors.statusError,
                                          () => _onMapLocationTap('Clock Tower'),
                                        ),
                                      ),
                                      Positioned(
                                        top: 250,
                                        left: 120,
                                        child: _buildEnhancedMarker(
                                          Icons.train,
                                          'Railway Station',
                                          'Unknown',
                                          AppColors.lavenderWhite,
                                          () => _onMapLocationTap('Railway Station'),
                                        ),
                                      ),
                                      Positioned(
                                        top: 140,
                                        left: 260,
                                        child: _buildEnhancedMarker(
                                          Icons.water_drop,
                                          'Steam Vents',
                                          'Active',
                                          AppColors.accentRose,
                                          () => _onMapLocationTap('Steam Vents'),
                                        ),
                                      ),

                                      // Expedition routes
                                      CustomPaint(
                                        size: const Size(400, 400),
                                        painter: ExpeditionRoutesPainter(),
                                      ),

                                      // Legend
                                      Positioned(
                                        bottom: 16,
                                        right: 16,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.deepNavy.withValues(alpha: 0.8),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: AppColors.vintageGold.withValues(alpha: 0.3),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildLegendItem(AppColors.statusOptimal, 'Discovered'),
                                              _buildLegendItem(AppColors.statusWarning, 'Exploring'),
                                              _buildLegendItem(AppColors.statusError, 'Locked'),
                                              _buildLegendItem(AppColors.lavenderWhite, 'Unknown'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Expedition Planning
                              GlassCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Expedition Planning',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineMedium,
                                    ),
                                    const SizedBox(height: 16),

                                    // Scout Automaton Status
                                    Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.slateBlue,
                                          ),
                                          child: const Icon(
                                            Icons.smart_toy,
                                            color: AppColors.vintageGold,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Scout Automaton',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                              ),
                                              Text(
                                                'Ready for deployment',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color:
                                                          AppColors.vintageGold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Customize feature coming soon...',
                                                ),
                                                backgroundColor:
                                                    AppColors.slateBlue,
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Customize',
                                            style: TextStyle(
                                              color: AppColors.vintageGold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),

                                    // Automaton Stats
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Durability',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                              ),
                                              const SizedBox(height: 4),
                                              const CustomProgressBar(
                                                value: 0.7,
                                                color: AppColors.vintageGold,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Analysis',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                              ),
                                              const SizedBox(height: 4),
                                              const CustomProgressBar(
                                                value: 0.45,
                                                color: AppColors.vintageGold,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Available Expeditions
                              ..._expeditions.map(
                                (expedition) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: GlassCard(
                                    onTap: () =>
                                        _dispatchExpedition(expedition),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              _getExpeditionIcon(
                                                expedition.status,
                                              ),
                                              color: _getExpeditionColor(
                                                expedition.status,
                                              ),
                                              size: 24,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    expedition.name,
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.headlineSmall,
                                                  ),
                                                  Text(
                                                    expedition.description,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          color: AppColors
                                                              .lavenderWhite
                                                              .withValues(
                                                                alpha: 0.7,
                                                              ),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              _getStatusText(expedition.status),
                                              style: TextStyle(
                                                color: _getExpeditionColor(
                                                  expedition.status,
                                                ),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (expedition.status ==
                                            ExpeditionStatus.inProgress) ...[
                                          const SizedBox(height: 12),
                                          const LinearProgressIndicator(
                                            color: AppColors.vintageGold,
                                            backgroundColor:
                                                AppColors.slateBlue,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildEnhancedMarker(
    IconData icon,
    String label,
    String status,
    Color statusColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor,
              border: Border.all(
                color: AppColors.deepNavy,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: statusColor.withValues(alpha: 0.5),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.deepNavy, size: 18),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.deepNavy.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: statusColor.withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: statusColor,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistrict(String name, double width, double height, bool isExplored) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: isExplored ? AppColors.vintageGold : AppColors.lavenderWhite.withValues(alpha: 0.3),
          width: isExplored ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isExplored
            ? AppColors.vintageGold.withValues(alpha: 0.1)
            : AppColors.lavenderWhite.withValues(alpha: 0.05),
      ),
      child: Center(
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isExplored ? AppColors.vintageGold : AppColors.lavenderWhite.withValues(alpha: 0.7),
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.lavenderWhite,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getExpeditionIcon(ExpeditionStatus status) {
    switch (status) {
      case ExpeditionStatus.ready:
        return Icons.send;
      case ExpeditionStatus.inProgress:
        return Icons.hourglass_empty;
      case ExpeditionStatus.completed:
        return Icons.check_circle;
      case ExpeditionStatus.failed:
        return Icons.error;
    }
  }

  Color _getExpeditionColor(ExpeditionStatus status) {
    switch (status) {
      case ExpeditionStatus.ready:
        return AppColors.vintageGold;
      case ExpeditionStatus.inProgress:
        return AppColors.statusWarning;
      case ExpeditionStatus.completed:
        return AppColors.statusOptimal;
      case ExpeditionStatus.failed:
        return AppColors.statusError;
    }
  }

  String _getStatusText(ExpeditionStatus status) {
    switch (status) {
      case ExpeditionStatus.ready:
        return 'READY';
      case ExpeditionStatus.inProgress:
        return 'IN PROGRESS';
      case ExpeditionStatus.completed:
        return 'COMPLETED';
      case ExpeditionStatus.failed:
        return 'FAILED';
    }
  }
}

class MapTerrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.lavenderWhite.withValues(alpha: 0.1);

    // Draw terrain lines
    for (int i = 0; i < 10; i++) {
      final y = (size.height / 10) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    for (int i = 0; i < 15; i++) {
      final x = (size.width / 15) * i;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw some terrain features
    final terrainPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.vintageGold.withValues(alpha: 0.05);

    // Hills
    final path = Path();
    path.moveTo(size.width * 0.1, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.6,
      size.width * 0.5,
      size.height * 0.8,
    );
    path.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.9,
      size.width * 0.9,
      size.height * 0.8,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, terrainPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ExpeditionRoutesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.accentRose.withValues(alpha: 0.3);

    // Draw expedition routes as dashed lines
    final dashWidth = 5.0;
    final dashSpace = 3.0;

    // Route 1: Library to Factory
    _drawDashedLine(
      canvas,
      const Offset(90, 120),
      const Offset(150, 180),
      paint,
      dashWidth,
      dashSpace,
    );

    // Route 2: Factory to Tower
    _drawDashedLine(
      canvas,
      const Offset(150, 180),
      const Offset(210, 90),
      paint,
      dashWidth,
      dashSpace,
    );

    // Route 3: Tower to Railway
    _drawDashedLine(
      canvas,
      const Offset(210, 90),
      const Offset(120, 250),
      paint,
      dashWidth,
      dashSpace,
    );
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint,
    double dashWidth,
    double dashSpace,
  ) {
    final distance = (end - start).distance;
    final dashCount = (distance / (dashWidth + dashSpace)).floor();
    final direction = (end - start) / distance;

    for (int i = 0; i < dashCount; i++) {
      final dashStart = start + direction * (dashWidth + dashSpace) * i.toDouble();
      final dashEnd = dashStart + direction * dashWidth;
      canvas.drawLine(dashStart, dashEnd, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
