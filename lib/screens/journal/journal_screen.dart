import 'package:astrelexis/models/journal_entry.dart';
import 'package:astrelexis/models/todo_item.dart';
import 'package:astrelexis/services/storage_service.dart';
import 'package:astrelexis/utils/app_colors.dart';
import 'package:astrelexis/widgets/glass_card.dart';
import 'package:astrelexis/screens/journal/add_journal_screen.dart';
import 'package:astrelexis/screens/todo/add_todo_screen.dart';
import 'package:astrelexis/screens/memory/add_memory_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final StorageService _storageService = StorageService();
  List<JournalEntry> _entries = [];
  List<TodoItem> _completedTodos = [];
  Map<String, List<dynamic>> _groupedItems = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    setState(() {
      _isLoading = true;
    });

    // Initialize sample data if needed
    await _storageService.initializeSampleData();

    // Load both journal entries and todo items
    final loadedEntries = await _storageService.loadJournalEntries();
    final loadedTodos = await _storageService.loadTodoItems();

    // Get all todos (completed and pending)
    _completedTodos = loadedTodos;

    // If storage is empty, use sample data
    if (loadedEntries.isEmpty) {
      final sampleEntries = _getSampleEntries(context);
      await _storageService.saveJournalEntries(sampleEntries);
      _entries = sampleEntries;
    } else {
      _entries = loadedEntries;
    }

    // Sort entries by creation date (newest first)
    _entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    _groupItems();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> refreshEntries() async {
    await _loadEntries();
  }

  Future<void> _toggleTodoCompletion(TodoItem todo) async {
    // Create updated todo with toggled completion status
    final updatedTodo = TodoItem(
      id: todo.id,
      task: todo.task,
      notes: todo.notes,
      dueDate: todo.dueDate,
      isCompleted: !todo.isCompleted,
    );

    // Update in storage
    await _storageService.updateTodoItem(updatedTodo);

    // Refresh the UI
    await refreshEntries();
  }

  Future<void> _deleteJournalEntry(JournalEntry entry) async {
    final confirmed =
        await _showDeleteConfirmation(context, 'Delete this journal entry?');
    if (confirmed) {
      await _storageService.deleteJournalEntry(entry.id);
      await refreshEntries();
    }
  }

  Future<void> _deleteTodoItem(TodoItem todo) async {
    final confirmed =
        await _showDeleteConfirmation(context, 'Delete this task?');
    if (confirmed) {
      await _storageService.deleteTodoItem(todo.id);
      await refreshEntries();
    }
  }

  Future<bool> _showDeleteConfirmation(
      BuildContext context, String message) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.primaryBg,
            title: const Text('Confirm Delete',
                style: TextStyle(color: AppColors.textPrimary)),
            content: Text(message,
                style: const TextStyle(color: AppColors.textSecondary)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel',
                    style: TextStyle(color: AppColors.textSecondary)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _groupItems() {
    _groupedItems = {};

    // Group journal entries
    for (var entry in _entries) {
      final dayKey = DateFormat('yyyy-MM-dd').format(entry.createdAt);
      if (_groupedItems[dayKey] == null) {
        _groupedItems[dayKey] = [];
      }
      _groupedItems[dayKey]!.add(entry);
    }

    // Group all todos
    for (var todo in _completedTodos) {
      final dayKey = DateFormat('yyyy-MM-dd').format(todo.dueDate);
      if (_groupedItems[dayKey] == null) {
        _groupedItems[dayKey] = [];
      }
      _groupedItems[dayKey]!.add(todo);
    }

    // Sort items within each day by time (newest first)
    _groupedItems.forEach((key, items) {
      items.sort((a, b) {
        DateTime timeA =
            a is JournalEntry ? a.createdAt : (a as TodoItem).dueDate;
        DateTime timeB =
            b is JournalEntry ? b.createdAt : (b as TodoItem).dueDate;
        return timeB.compareTo(timeA);
      });
    });
  }

  String _getGroupTitle(String dateKey) {
    final date = DateTime.parse(dateKey);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final entryDate = DateTime(date.year, date.month, date.day);

    if (entryDate == today) {
      return 'TODAY, ${DateFormat('MMMM dd').format(date).toUpperCase()}';
    } else if (entryDate == yesterday) {
      return 'YESTERDAY, ${DateFormat('MMMM dd').format(date).toUpperCase()}';
    } else {
      return DateFormat('EEEE, MMMM dd').format(date).toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.accentTeal),
                ),
              )
            : RefreshIndicator(
                onRefresh: refreshEntries,
                color: AppColors.accentTeal,
                backgroundColor: AppColors.primaryBg,
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: AppColors.primaryBg.withOpacity(0.8),
                      expandedHeight: 110.0,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        title: const Text(
                          'Journal',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: _buildAddButton(),
                        ),
                      ],
                    ),
                    _groupedItems.isEmpty
                        ? SliverFillRemaining(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.bookOpen,
                                    size: 64,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'No entries yet',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Tap the + button to create your first entry',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final dateKey =
                                    _groupedItems.keys.elementAt(index);
                                final itemsForDay = _groupedItems[dateKey]!;
                                return _buildJournalGroup(dateKey, itemsForDay);
                              },
                              childCount: _groupedItems.length,
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
      height: 40, // Constrain the height of the search field
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search entries, tasks, memories...',
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          prefixIcon: const Icon(
            FontAwesomeIcons.magnifyingGlass,
            size: 16,
            color: AppColors.textSecondary,
          ),
          filled: true,
          fillColor: AppColors.glassBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0), // Reduced padding
        ),
      ),
    );
  }

  Widget _buildJournalGroup(String dateKey, List<dynamic> items) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          _getGroupTitle(dateKey),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
            letterSpacing: 1.1,
          ),
        ),
        initiallyExpanded: dateKey == today,
        iconColor: AppColors.textSecondary,
        collapsedIconColor: AppColors.textSecondary,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: items
                  .map((item) => item is JournalEntry
                      ? _buildJournalEntryCard(item)
                      : _buildCompletedTodoCard(item as TodoItem))
                  .toList(),
            ),
          ),
          if (items.any((item) => item is TodoItem))
            _buildCompletedTodosSection(items.whereType<TodoItem>().toList()),
        ],
      ),
    );
  }

  Widget _buildJournalEntryCard(JournalEntry entry) {
    return GestureDetector(
      onLongPress: () => _showJournalEntryOptions(entry),
      child: GlassCard(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (entry.title.isNotEmpty)
                Text(
                  entry.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              if (entry.title.isNotEmpty) const SizedBox(height: 8),
              Text(
                entry.content,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              if (entry.imageUrl != null && entry.imageUrl!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: _buildEntryImage(entry.imageUrl!),
                  ),
                ),
              if (entry.tags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: entry.tags
                        .map((tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.accentTeal.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color:
                                        AppColors.accentTeal.withOpacity(0.3)),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  color: AppColors.accentTeal,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                DateFormat('h:mm a').format(entry.createdAt),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEntryImage(String imageUrl) {
    // Check if it's a local file path or a network URL
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      // Network image
      return Image.network(
        imageUrl,
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: AppColors.glassBg,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.image,
                color: AppColors.textSecondary,
                size: 32,
              ),
            ),
          );
        },
      );
    } else {
      // Local file
      return Image.file(
        File(imageUrl),
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: AppColors.glassBg,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.image,
                color: AppColors.textSecondary,
                size: 32,
              ),
            ),
          );
        },
      );
    }
  }

  void _showJournalEntryOptions(JournalEntry entry) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primaryBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: AppColors.accentTeal),
              title: const Text('Edit Entry',
                  style: TextStyle(color: AppColors.textPrimary)),
              onTap: () {
                Navigator.pop(context);
                _editJournalEntry(entry);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Entry',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteJournalEntry(entry);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editJournalEntry(JournalEntry entry) {
    // TODO: Implement edit functionality - for now just show a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Edit functionality will be implemented in the next update'),
        backgroundColor: AppColors.accentTeal,
      ),
    );
  }

  Widget _buildCompletedTodoCard(TodoItem todo) {
    return GestureDetector(
      onTap: () => _toggleTodoCompletion(todo),
      onLongPress: () => _showTodoOptions(todo),
      child: GlassCard(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: todo.isCompleted
                    ? AppColors.accentTeal
                    : AppColors.glassBorder,
              ),
              child: todo.isCompleted
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : Container(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.task,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  if (todo.notes != null && todo.notes!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        todo.notes!,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: todo.isCompleted
                    ? AppColors.accentTeal.withOpacity(0.2)
                    : Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                todo.isCompleted ? 'Completed' : 'Pending',
                style: TextStyle(
                  color:
                      todo.isCompleted ? AppColors.accentTeal : Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTodoOptions(TodoItem todo) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primaryBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                todo.isCompleted ? Icons.undo : Icons.check,
                color: AppColors.accentTeal,
              ),
              title: Text(
                todo.isCompleted ? 'Mark as Pending' : 'Mark as Completed',
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              onTap: () {
                Navigator.pop(context);
                _toggleTodoCompletion(todo);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: AppColors.accentTeal),
              title: const Text('Edit Task',
                  style: TextStyle(color: AppColors.textPrimary)),
              onTap: () {
                Navigator.pop(context);
                _editTodoItem(todo);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Task',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteTodoItem(todo);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editTodoItem(TodoItem todo) {
    // TODO: Implement edit functionality - for now just show a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Edit functionality will be implemented in the next update'),
        backgroundColor: AppColors.accentTeal,
      ),
    );
  }

  Widget _buildCompletedTodosSection(List<TodoItem> completedTodos) {
    if (completedTodos.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Completed Today',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...completedTodos.map((todo) => GestureDetector(
              onTap: () => _toggleTodoCompletion(todo),
              child: GlassCard(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        todo.task,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accentTeal.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Reflect',
                        style: TextStyle(
                          color: AppColors.accentTeal,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  List<JournalEntry> _getSampleEntries(BuildContext context) {
    final now = DateTime.now();
    return [
      JournalEntry(
        title: 'Project Nova Meeting',
        content:
            'The meeting about Project Nova went better than expected. Felt a real sense of accomplishment.',
        createdAt: DateTime(now.year, now.month, now.day, 10, 15),
      ),
      JournalEntry(
        title: 'Afternoon Walk',
        content:
            'A moment of peace during my afternoon walk. The sky was incredible.',
        imageUrl:
            'https://images.unsplash.com/photo-1534790566855-4cb788d389ec?q=80&w=2070&auto=format&fit=crop',
        createdAt: DateTime(now.year, now.month, now.day, 15, 30),
      ),
      JournalEntry(
        title: 'Reading Dune Messiah',
        content:
            'Started reading "Dune Messiah". The world-building is just as immersive as the first book.',
        createdAt: now.subtract(const Duration(days: 1, hours: 12)),
      ),
    ];
  }

  Widget _buildAddButton() {
    return PopupMenuButton<String>(
      icon: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [AppColors.fabGradientStart, AppColors.fabGradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 24,
        ),
      ),
      color: AppColors.primaryBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.glassBorder),
      ),
      onSelected: (String value) {
        switch (value) {
          case 'entry':
            _openAddJournalScreen();
            break;
          case 'todo':
            _openAddTodoScreen();
            break;
          case 'memory':
            _openAddMemoryScreen();
            break;
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'entry',
          child: Container(
            width: 160,
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accentTeal.withOpacity(0.2),
                  ),
                  child: const Icon(
                    FontAwesomeIcons.bookOpen,
                    color: AppColors.accentTeal,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'New Entry',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'todo',
          child: Container(
            width: 160,
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(0.2),
                  ),
                  child: const Icon(
                    FontAwesomeIcons.squareCheck,
                    color: Colors.blue,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'New To-Do',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'memory',
          child: Container(
            width: 160,
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple.withOpacity(0.2),
                  ),
                  child: const Icon(
                    FontAwesomeIcons.image,
                    color: Colors.purple,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'New Memory',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openAddJournalScreen() {
    Navigator.of(context)
        .push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddJournalScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    )
        .then((result) {
      if (result is JournalEntry) {
        refreshEntries();
      }
    });
  }

  void _openAddTodoScreen() {
    Navigator.of(context)
        .push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddTodoScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    )
        .then((result) {
      if (result != null) {
        refreshEntries();
      }
    });
  }

  void _openAddMemoryScreen() {
    Navigator.of(context)
        .push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddMemoryScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    )
        .then((result) {
      if (result != null) {
        refreshEntries();
      }
    });
  }
}
