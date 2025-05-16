import 'package:flutter/material.dart';
import '../models/pomodoro_model.dart';
import '../utils/storage_utils.dart';
import '../utils/time_utils.dart';
import '../widgets/history_item.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<PomodoroSession> _sessions = [];
  bool _isLoading = true;
  String? _editingSessionId;
  final TextEditingController _titleController = TextEditingController();

  // Stats
  int _totalSessions = 0;
  int _todaySessions = 0;
  int _thisWeekSessions = 0;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload sessions when tab becomes visible
    _loadSessions();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _loadSessions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final sessions = await StorageUtils.getPomodoroSessions();
      sessions.sort((a, b) => b.completedAt.compareTo(a.completedAt));

      // Calculate stats
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final thisWeek = today.subtract(Duration(days: today.weekday - 1));

      final todaySessions =
          sessions.where((s) => s.completedAt.isAfter(today)).toList();

      final thisWeekSessions =
          sessions.where((s) => s.completedAt.isAfter(thisWeek)).toList();

      setState(() {
        _sessions = sessions;
        _isLoading = false;
        _totalSessions = sessions.length;
        _todaySessions = todaySessions.length;
        _thisWeekSessions = thisWeekSessions.length;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load sessions: $e')),
      );
    }
  }

  void _startEditing(String sessionId) {
    final session = _sessions.firstWhere((s) => s.id == sessionId);
    _titleController.text = session.title;
    setState(() {
      _editingSessionId = sessionId;
    });
  }

  Future<void> _saveEdit(String sessionId) async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }

    final sessionIndex = _sessions.indexWhere((s) => s.id == sessionId);
    if (sessionIndex >= 0) {
      final oldSession = _sessions[sessionIndex];
      final updatedSession = PomodoroSession(
        id: oldSession.id,
        title: _titleController.text.trim(),
        duration: oldSession.duration,
        completedAt: oldSession.completedAt,
      );

      try {
        await StorageUtils.updatePomodoroSession(updatedSession);
        setState(() {
          _sessions[sessionIndex] = updatedSession;
          _editingSessionId = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save failed: $e')),
        );
      }
    }
  }

  Future<void> _deleteSession(String sessionId) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF24263A),
        title: const Text(
          'Delete Session',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this session?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _sessions.removeWhere((s) => s.id == sessionId);
      });
      await _clearAllAndSaveRemaining();
    }
  }

  Future<void> _clearAllSessions() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF24263A),
        title: const Text(
          'Clear All Sessions',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to clear all sessions? This cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await StorageUtils.clearPomodoroSessions();
        setState(() {
          _sessions = [];
          _totalSessions = 0;
          _todaySessions = 0;
          _thisWeekSessions = 0;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Clear failed: $e')),
        );
      }
    }
  }

  Future<void> _clearAllAndSaveRemaining() async {
    try {
      await StorageUtils.clearPomodoroSessions();
      for (final session in _sessions) {
        await StorageUtils.savePomodoroSession(session);
      }

      // Recalculate stats
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final thisWeek = today.subtract(Duration(days: today.weekday - 1));

      final todaySessions =
          _sessions.where((s) => s.completedAt.isAfter(today)).toList();

      final thisWeekSessions =
          _sessions.where((s) => s.completedAt.isAfter(thisWeek)).toList();

      setState(() {
        _totalSessions = _sessions.length;
        _todaySessions = todaySessions.length;
        _thisWeekSessions = thisWeekSessions.length;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Operation failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16161A),
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF16161A),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadSessions,
            tooltip: 'Refresh sessions',
          ),
          if (_sessions.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.white),
              onPressed: _clearAllSessions,
              tooltip: 'Clear all sessions',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7F5AF0)),
              ),
            )
          : _sessions.isEmpty
              ? _buildEmptyState()
              : _buildSessionsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Colors.white.withOpacity(0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'No sessions yet',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete a Pomodoro to start recording',
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to Pomodoro tab (index 1)
              final tabController = DefaultTabController.of(context);
              if (tabController != null) {
                tabController.animateTo(1);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7F5AF0),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Start a Pomodoro',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsList() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildStatsCard(),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.history_toggle_off,
                    color: Color(0xFF7F5AF0),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Session History (${_sessions.length})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final session = _sessions[index];
              final isEditing = session.id == _editingSessionId;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: HistoryItem(
                  session: session,
                  isEditing: isEditing,
                  controller: _titleController,
                  onEdit: isEditing ? _saveEdit : _startEditing,
                  onDelete: _deleteSession,
                ),
              );
            },
            childCount: _sessions.length,
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 20),
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7F5AF0), Color(0xFF6B46C1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7F5AF0).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Focus Summary',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard('Today', _todaySessions, Icons.today),
              _buildStatCard('This Week', _thisWeekSessions, Icons.date_range),
              _buildStatCard('Total', _totalSessions, Icons.history),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
