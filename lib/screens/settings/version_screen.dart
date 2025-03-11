import 'package:flutter/material.dart';

class VersionScreen extends StatelessWidget {
  const VersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Version History',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildHeaderCard(context),
            const SizedBox(height: 16),
            const _VersionItem(
              version: '1.2.0',
              date: 'March 25, 2024',
              type: 'Major Update',
              iconColor: Colors.blue,
              changes: [
                'Introduced AI-powered outfit recommendations',
                'Added virtual wardrobe try-on feature',
                'Enhanced user interface with Material Design 3',
                'Implemented advanced search and filtering',
                'Added support for multiple wardrobes',
              ],
              improvements: [
                'Improved app performance by 40%',
                'Enhanced photo recognition accuracy',
                'Optimized storage usage',
              ],
              fixes: [
                'Fixed camera orientation issues',
                'Resolved notification scheduling bugs',
              ],
            ),
            const _VersionItem(
              version: '1.1.0',
              date: 'February 15, 2024',
              type: 'Feature Update',
              iconColor: Colors.green,
              changes: [
                'Added seasonal wardrobe planning',
                'Introduced outfit sharing feature',
                'Implemented wardrobe statistics',
                'Added outfit favorites system',
                'Integrated weather-based suggestions',
              ],
              improvements: [
                'Enhanced color matching algorithm',
                'Improved image compression',
                'Faster loading times',
              ],
              fixes: [
                'Fixed category sorting issues',
                'Resolved sync conflicts',
              ],
            ),
            const _VersionItem(
              version: '1.0.1',
              date: 'January 10, 2024',
              type: 'Maintenance Update',
              iconColor: Colors.orange,
              changes: [
                'Added support for dark mode',
                'Implemented data backup feature',
                'Enhanced search functionality',
                'Added outfit history tracking',
                'Introduced quick actions menu',
              ],
              improvements: [
                'Reduced app size by 20%',
                'Improved startup time',
                'Enhanced UI responsiveness',
              ],
              fixes: [
                'Fixed login issues on iOS',
                'Resolved image upload errors',
              ],
            ),
            const _VersionItem(
              version: '1.0.0',
              date: 'December 1, 2023',
              type: 'Initial Release',
              iconColor: Colors.purple,
              changes: [
                'Core wardrobe management features',
                'Basic outfit recommendations',
                'User profile and preferences',
                'Photo capture and management',
                'Category and tag system',
              ],
              improvements: [],
              fixes: [],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.new_releases,
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Release Notes',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                      ),
                      const Text(
                        'Current Version: 1.2.0',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Track our journey of continuous improvement and feature additions. Each update brings new capabilities to enhance your style management experience.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VersionItem extends StatelessWidget {
  final String version;
  final String date;
  final String type;
  final Color iconColor;
  final List<String> changes;
  final List<String> improvements;
  final List<String> fixes;

  const _VersionItem({
    required this.version,
    required this.date,
    required this.type,
    required this.iconColor,
    required this.changes,
    required this.improvements,
    required this.fixes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.new_releases,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Version $version',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$type • $date',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (changes.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'New Features',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              ...changes.map((change) => _buildListItem(change)),
            ],
            if (improvements.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Improvements',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              ...improvements.map((improvement) => _buildListItem(improvement)),
            ],
            if (fixes.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Bug Fixes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 8),
              ...fixes.map((fix) => _buildListItem(fix)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 20,
            color: Colors.green,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
