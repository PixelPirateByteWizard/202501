import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/eco_friend.dart';
import '../data/sample_eco_friends.dart';
import 'friend_chat_page.dart';
import 'friend_profile_page.dart';

class SharePage extends StatefulWidget {
  const SharePage({super.key});

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  final TextEditingController _searchController = TextEditingController();
  List<EcoFriend> _filteredFriends = [];

  @override
  void initState() {
    super.initState();
    _filteredFriends = sampleEcoFriends;
    _searchController.addListener(_filterFriends);
  }

  void _filterFriends() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFriends = sampleEcoFriends.where((friend) {
        return friend.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFF2A2D5F),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Help Guide',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '• Tap on friend\'s avatar to view their detailed profile\n'
                  '• Tap on the card to start chatting with an eco friend\n'
                  '• Use the search bar to find specific eco friends\n'
                  '• View friend\'s title and bio in each card',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF8B6BF3),
                          Color(0xFF6B4DE3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Got it',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0B2E),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 160),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  itemCount: _filteredFriends.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final friend = _filteredFriends[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildFriendCard(context, friend),
                    );
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0B2E),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Eco Friends',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Connect with environmental pioneers',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.7),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () => _showHelpDialog(context),
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF8B6BF3),
                                    Color(0xFF6B4DE3),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF8B6BF3)
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.help_outline_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF2A2D5F).withOpacity(0.8),
                              const Color(0xFF1A1B3F).withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(color: Colors.white),
                          maxLength: 20,
                          buildCounter: (context,
                                  {required currentLength,
                                  required isFocused,
                                  maxLength}) =>
                              null,
                          decoration: InputDecoration(
                            hintText: 'Search eco friends...',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      _filterFriends();
                                    },
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
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFriendCard(BuildContext context, EcoFriend friend) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FriendChatPage(friend: friend),
            ),
          );
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2A2D5F),
                Color(0xFF1A1B3F),
              ],
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FriendProfilePage(friend: friend),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'friend_avatar_${friend.id}',
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35 -
                          20, // 增加到35%的屏幕宽度
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF8B6BF3),
                              Color(0xFF6B4DE3),
                            ],
                          ),
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(24),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B6BF3).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(24),
                          ),
                          child: Image.asset(
                            friend.avatar,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          friend.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF8B6BF3),
                                Color(0xFF6B4DE3),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            friend.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          friend.bio,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                            height: 1.5,
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
    );
  }
}
