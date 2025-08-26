import 'package:flutter/material.dart';
import '../utils/constants.dart';

class VersionScreen extends StatelessWidget {
  const VersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Version Information'),
        backgroundColor: AppConstants.spaceIndigo600,
      ),
      body: GestureDetector(
        onTap: () =>
            FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.new_releases_outlined,
                      color: Colors.teal,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Version Information',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppConstants.cosmicBlue,
                          ),
                        ),
                        Text(
                          'Current Version: ${AppConstants.appVersion}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onBackground.withOpacity(
                              0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Current Version Card
              _buildVersionCard(
                context,
                version: '1.2.0',
                releaseDate: 'January 15, 2023',
                isCurrent: true,
                changes: [
                  'Added LED Scroller feature with full-screen mode',
                  'Improved Match Scorer with support for multiple sports',
                  'Enhanced Group Generator with skill-based team balancing',
                  'Redesigned Settings screen with improved navigation',
                  'Fixed various bugs and performance improvements',
                ],
              ),

              const SizedBox(height: 24),

              // Previous Version Cards
              _buildVersionCard(
                context,
                version: '1.1.0',
                releaseDate: 'November 10, 2022',
                changes: [
                  'Added Match Scorer feature for tracking game scores',
                  'Implemented save and load functionality for matches',
                  'Enhanced user interface with cosmic theme',
                  'Added support for different sports scoring rules',
                  'Various bug fixes and stability improvements',
                ],
              ),

              const SizedBox(height: 24),

              _buildVersionCard(
                context,
                version: '1.0.0',
                releaseDate: 'September 5, 2022',
                changes: [
                  'Initial release with Group Generator feature',
                  'Basic settings and preferences',
                  'Dark mode support',
                  'Simple team creation and management',
                ],
              ),

              const SizedBox(height: 32),

              // Update Check
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVersionCard(
    BuildContext context, {
    required String version,
    required String releaseDate,
    bool isCurrent = false,
    required List<String> changes,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: isCurrent ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isCurrent
            ? BorderSide(color: AppConstants.cosmicBlue, width: 1)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Version $version',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isCurrent ? AppConstants.cosmicBlue : null,
                  ),
                ),
                if (isCurrent) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppConstants.cosmicBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Current',
                      style: TextStyle(
                        color: AppConstants.cosmicBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Released: $releaseDate',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'What\'s New:',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ...changes.map((change) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isCurrent
                            ? AppConstants.cosmicBlue
                            : Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        change,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
