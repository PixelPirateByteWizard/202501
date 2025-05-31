import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounds/backgrounds_5.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'About Spirit Dream',
            style: TextStyle(
              color: const Color(0xFFFBBF24),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.amber.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppIcon(),
            const SizedBox(height: 24),
            _buildInfoSection('App Information', [
              {'title': 'Version', 'content': '1.0.0'},
              {'title': 'Update Date', 'content': 'May 7, 2024'},
              {'title': 'Developer', 'content': 'Spirit Dream Studio'},
            ]),
            const SizedBox(height: 24),
            _buildInfoSection('App Introduction', [
              {
                'content':
                    'Spirit Dream is a cultivation game filled with Eastern fantasy elements, where players will experience a unique cultivation world and embark on an exciting journey of immortal cultivation.'
              },
              {
                'content':
                    'The game combines traditional cultivation elements with modern gameplay, providing players with an immersive cultivation experience.'
              },
            ]),
            const SizedBox(height: 24),
            _buildInfoSection('Special Features', [
              {'content': '• Unique cultivation worldview and storyline'},
              {'content': '• Rich cultivation system and techniques'},
              {'content': '• Diverse missions and challenges'},
              {'content': '• Exquisite graphics and sound effects'},
              {'content': '• Social interaction and competitive system'},
            ]),
            const SizedBox(height: 24),
            _buildInfoSection('Contact Us', [
              {'title': 'Official Website', 'content': 'www.spiritdream.com'},
              {
                'title': 'Customer Service Email',
                'content': 'support@spiritdream.com'
              },
              {
                'title': 'Business Cooperation',
                'content': 'business@spiritdream.com'
              },
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildAppIcon() {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/images/app_icon.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Map<String, String>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...items.map((item) {
          if (item.containsKey('title')) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Text(
                    '${item['title']}: ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item['content']!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                item['content']!,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            );
          }
        }).toList(),
      ],
    );
  }
}
