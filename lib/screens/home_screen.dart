import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/friend_model.dart';
import 'friend_chat_screen.dart';
import 'friend_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'All';
  final List<InstrumentCategory> categories = [
    InstrumentCategory(
      name: '弦乐器',
      description: '探索优美的弦乐世界，感受音符的流动之美',
      imagePath: 'assets/string_instruments.jpg',
      instruments: ['小提琴', '大提琴', '吉他', '贝斯'],
      color: const Color(0xFFE6B8AF),
    ),
    InstrumentCategory(
      name: '管乐器',
      description: '体验管乐的独特魅力，让音乐在空气中舞动',
      imagePath: 'assets/wind_instruments.jpg',
      instruments: ['萨克斯', '长笛', '单簧管', '小号'],
      color: const Color(0xFFB6D7A8),
    ),
    InstrumentCategory(
      name: '打击乐器',
      description: '感受节奏的力量，创造动感的音乐律动',
      imagePath: 'assets/percussion_instruments.jpg',
      instruments: ['架子鼓', '康加鼓', '邦戈鼓', '木琴'],
      color: const Color(0xFFB4A7D6),
    ),
    InstrumentCategory(
      name: '键盘乐器',
      description: '探索键盘的无限可能，演绎丰富的音乐色彩',
      imagePath: 'assets/keyboard_instruments.jpg',
      instruments: ['钢琴', '电子琴', '手风琴', '合成器'],
      color: const Color(0xFFF9CB9C),
    ),
  ];

  List<InstrumentCategory> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    filteredCategories = categories;
  }

  void _filterCategories(String query) {
    setState(() {
      filteredCategories = categories.where((category) {
        final nameMatch =
            category.name.toLowerCase().contains(query.toLowerCase());
        final instrumentMatch = category.instruments.any(
          (instrument) =>
              instrument.toLowerCase().contains(query.toLowerCase()),
        );
        return nameMatch || instrumentMatch;
      }).toList();
    });
  }

  void _handleLocationTap() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Search Range',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildRangeOption('Within 5 km', true),
                  _buildRangeOption('Within 10 km', false),
                  _buildRangeOption('Within 20 km', false),
                  _buildRangeOption('All locations', false),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRangeOption(String title, bool isSelected) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pop(context);
        // TODO: Implement range selection logic
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: const Color(0xFF6A4C93),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? const Color(0xFF2C3E50) : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.lightbulb_outline,
                        color: Color(0xFFFFB74D)),
                    const SizedBox(width: 12),
                    const Text(
                      'User Guide',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildHelpItem(
                  icon: Icons.search,
                  title: 'Search Function',
                  description:
                      'Search for musicians by name or instruments to quickly find your music partners',
                ),
                const SizedBox(height: 12),
                _buildHelpItem(
                  icon: Icons.filter_list,
                  title: 'Status Filter',
                  description:
                      'Filter musicians by their online status to find active users',
                ),
                const SizedBox(height: 12),
                _buildHelpItem(
                  icon: Icons.person,
                  title: 'Musician Profile',
                  description:
                      'Click on a musician card to view their detailed profile and start a conversation',
                ),
                const SizedBox(height: 12),
                _buildHelpItem(
                  icon: Icons.delete_forever,
                  title: 'Remove Connection',
                  description:
                      'Long press on a musician card to permanently remove them from your connections. This action cannot be undone',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFECB3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFFFF9800)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Friend> _getFilteredFriends() {
    return sampleFriends.where((friend) {
      final matchesSearch = friend.name
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());

      bool matchesStatus;
      switch (_selectedStatus) {
        case 'Online':
          matchesStatus = friend.isOnline;
          break;
        case 'Offline':
          matchesStatus = !friend.isOnline;
          break;
        default: // 'All'
          matchesStatus = true;
      }

      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FF),
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF6A4C93),
                        Color(0xFF9B6DFF),
                      ],
                      stops: [0.2, 0.9],
                    ),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6A4C93).withOpacity(0.3),
                        blurRadius: 25,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                    colors: [Colors.white, Color(0xFFF0F0F0)],
                                  ).createShader(bounds),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Text(
                                        'Music Community',
                                        style: TextStyle(
                                          fontSize: constraints.maxWidth /
                                              6.clamp(12.0, 20.0),
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.5,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              color: Colors.black26,
                                              offset: Offset(0, 2),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Connect with musicians and explore instruments',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFF0F0F0),
                                    letterSpacing: 0.5,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: _showHelpDialog,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.help_outline,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      // Search Bar with animation
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 300),
                        tween: Tween(begin: 0, end: 1),
                        builder: (context, value, child) => Transform.scale(
                          scale: value,
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: _filterCategories,
                              maxLength: 20,
                              buildCounter: (context,
                                      {required currentLength,
                                      required isFocused,
                                      maxLength}) =>
                                  null,
                              style: const TextStyle(
                                color: Color(0xFF2C3E50),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search musicians...',
                                hintStyle: TextStyle(
                                  color:
                                      const Color(0xFF95A5A6).withOpacity(0.8),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                prefixIcon: const Icon(
                                  Icons.search_rounded,
                                  color: Color(0xFF6A4C93),
                                  size: 24,
                                ),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        onPressed: () {
                                          _searchController.clear();
                                          _filterCategories('');
                                        },
                                        icon: const Icon(
                                          Icons.close_rounded,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF6A4C93),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Musicians Section Header with Status Filter
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Musicians Near You',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                          letterSpacing: -0.5,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF6A4C93).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedStatus,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFF6A4C93),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            borderRadius: BorderRadius.circular(12),
                            items: ['All', 'Online', 'Offline']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF6A4C93),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedStatus = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Musicians List with filtered results
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final filteredFriends = _getFilteredFriends();
                      if (index >= filteredFriends.length) return null;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: _buildMusicianCard(filteredFriends[index]),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMusicianCard(Friend friend) {
    return MusicianCard(
      friend: friend,
      onDelete: () => _showDeleteConfirmation(friend),
    );
  }

  void _showDeleteConfirmation(Friend friend) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Remove Connection',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          content: Text(
            'Are you sure you want to remove ${friend.name} from your connections? This action cannot be undone.',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF6A4C93),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement friend removal logic
                setState(() {
                  sampleFriends.remove(friend);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${friend.name} has been removed'),
                    backgroundColor: const Color(0xFF6A4C93),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(20),
                  ),
                );
              },
              child: const Text(
                'Remove',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class InstrumentCategoryCard extends StatelessWidget {
  final InstrumentCategory category;

  const InstrumentCategoryCard({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to category detail page
        },
        child: Stack(
          children: [
            // Background image
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(category.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Gradient overlay
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    category.color.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            // Content
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: category.instruments.map((instrument) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            instrument,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MusicianCard extends StatelessWidget {
  final Friend friend;
  final VoidCallback? onDelete;

  const MusicianCard({
    super.key,
    required this.friend,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FriendChatScreen(friend: friend),
                ),
              );
            },
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FriendProfileScreen(friend: friend),
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'profile_${friend.id}',
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: friend.themeColor,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: friend.themeColor.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image(
                                image: AssetImage(friend.avatarAsset),
                                fit: BoxFit.cover,
                                alignment: const Alignment(0, -0.9),
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: friend.themeColor.withOpacity(0.2),
                                    child: Icon(
                                      Icons.person,
                                      size: 30,
                                      color: friend.themeColor,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  friend.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C3E50),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (friend.isOnline)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.green.withOpacity(0.3),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${friend.musicExperience} years experience',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    friend.bio,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                      height: 1.5,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final itemWidth = (constraints.maxWidth - 24) / 3;
                      return Row(
                        children: [
                          ...List.generate(
                            friend.instrumentAssets.length,
                            (index) => Padding(
                              padding: EdgeInsets.only(
                                right:
                                    index < friend.instrumentAssets.length - 1
                                        ? 12.0
                                        : 0,
                              ),
                              child: Container(
                                width: itemWidth,
                                height: itemWidth,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: friend.themeColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: friend.themeColor.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Image.asset(
                                  friend.instrumentAssets[index],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          if (friend.instrumentAssets.length == 2)
                            SizedBox(width: itemWidth + 12),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onDelete,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InstrumentCategory {
  final String name;
  final String description;
  final String imagePath;
  final List<String> instruments;
  final Color color;

  const InstrumentCategory({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.instruments,
    required this.color,
  });
}
