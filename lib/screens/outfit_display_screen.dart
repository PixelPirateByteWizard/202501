import 'package:flutter/material.dart';

class OutfitDisplayScreen extends StatelessWidget {
  final String title;
  final String gender;
  final String ageGroup;
  final String occasion;
  final String season;
  final String style;

  const OutfitDisplayScreen({
    super.key,
    required this.title,
    required this.gender,
    required this.ageGroup,
    required this.occasion,
    required this.season,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'StyleSync',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About Your Outfit'),
                  content: const SingleChildScrollView(
                    child: Text(
                      '• Each outfit is personalized based on your inputs\n'
                      '• Color combinations are carefully selected\n'
                      '• Style tips help you wear it perfectly\n'
                      '• Weather and occasion suggestions included\n\n'
                      'Tip: Use the share button to save or share your outfit!',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Personal Info Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 32,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Outfit Details',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildInfoRow(context, 'Style', title),
                            const SizedBox(height: 8),
                            _buildInfoRow(context, 'For', '$gender, $ageGroup'),
                            const SizedBox(height: 8),
                            _buildInfoRow(context, 'Occasion', occasion),
                            const SizedBox(height: 8),
                            _buildInfoRow(context, 'Season', season),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Outfit Recommendations Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.checkroom,
                                  size: 32,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Your Perfect Outfit',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildOutfitSection(
                              context,
                              icon: Icons.dry_cleaning,
                              title: 'Top',
                              content:
                                  'Light blue cotton Oxford shirt with rolled-up sleeves',
                            ),
                            const SizedBox(height: 16),
                            _buildOutfitSection(
                              context,
                              icon: Icons.accessibility,
                              title: 'Bottom',
                              content: 'Slim-fit dark navy chinos',
                            ),
                            const SizedBox(height: 16),
                            _buildOutfitSection(
                              context,
                              icon: Icons.water_drop,
                              title: 'Footwear',
                              content: 'Brown leather sneakers',
                            ),
                            const SizedBox(height: 16),
                            _buildOutfitSection(
                              context,
                              icon: Icons.watch,
                              title: 'Accessories',
                              content: '''• Minimalist silver watch
• Brown leather belt matching the shoes
• Classic aviator sunglasses''',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Style Guide Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.style,
                                  size: 32,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Style Guide',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildOutfitSection(
                              context,
                              icon: Icons.palette,
                              title: 'Color Coordination',
                              content:
                                  'The light blue shirt pairs perfectly with navy chinos, creating a balanced contrast. Brown leather accessories add warmth and sophistication.',
                            ),
                            const SizedBox(height: 16),
                            _buildOutfitSection(
                              context,
                              icon: Icons.lightbulb,
                              title: 'Style Tips',
                              content:
                                  '''1. Roll sleeves up to elbow for a casual yet put-together look
2. Ensure the shirt is well-fitted but not tight
3. Chinos should break slightly at the shoes
4. Keep accessories minimal for a clean look''',
                            ),
                            const SizedBox(height: 16),
                            _buildOutfitSection(
                              context,
                              icon: Icons.wb_sunny,
                              title: 'Weather & Occasion',
                              content: '''• Perfect for $season days
• Ideal for $occasion occasions
• Versatile enough for various settings''',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh),
                      SizedBox(width: 8),
                      Text(
                        'New Outfit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildOutfitSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}
