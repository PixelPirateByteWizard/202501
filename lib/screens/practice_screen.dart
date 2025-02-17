import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/practice_record.dart';
import '../services/database_service.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final Map<String, String> _instruments = {
    'Bass': 'assets/bs.png',
    'Cello': 'assets/dtq.png',
    'Electronic Keyboard': 'assets/dzq.png',
    'Piano': 'assets/gq.png',
    'Guitar': 'assets/jt.png',
    'Drums': 'assets/jzg.png',
    'Saxophone': 'assets/sks.png',
    'Violin': 'assets/xtq.png',
  };

  // 修改初始值为 CalendarFormat.week
  CalendarFormat _calendarFormat = CalendarFormat.week;

  final DatabaseService _databaseService = DatabaseService();
  List<PracticeRecord> _records = [];

  // 添加一个集合来存储有练习记录的日期
  Set<DateTime> _datesWithRecords = {};

  @override
  void initState() {
    super.initState();
    _loadRecords();
    _loadDatesWithRecords();
  }

  Future<void> _loadDatesWithRecords() async {
    final dates = await _databaseService.getDatesWithRecords();
    setState(() {
      _datesWithRecords = dates
          .map((date) => DateTime(date.year, date.month, date.day))
          .toSet();
    });
  }

  Future<void> _loadRecords() async {
    final records = await _databaseService.getRecordsForDate(_selectedDay);
    await _loadDatesWithRecords(); // 同时更新日期标记
    setState(() {
      _records = records;
    });
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
                  icon: Icons.calendar_today,
                  title: 'Calendar',
                  description:
                      'Tap a date to view practice records, use bottom button to expand/collapse calendar',
                ),
                const SizedBox(height: 12),
                _buildHelpItem(
                  icon: Icons.add_circle_outline,
                  title: 'Add Record',
                  description:
                      'Tap the bottom right button to add a new practice record',
                ),
                const SizedBox(height: 12),
                _buildHelpItem(
                  icon: Icons.swipe,
                  title: 'Delete Record',
                  description: 'Swipe left on a record to delete it',
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

  void _showAddPracticeDialog() {
    String? selectedInstrument;
    final TextEditingController durationController = TextEditingController();
    final TextEditingController notesController = TextEditingController();
    String? durationError;

    showDialog(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setState) => GestureDetector(
          onTap: () {
            // Dismiss keyboard when tapping outside of text fields
            FocusScope.of(context).unfocus();
          },
          child: Dialog(
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
                      const Icon(Icons.music_note, color: Color(0xFF6A4C93)),
                      const SizedBox(width: 12),
                      Text(
                        'Add Practice Record\n${_selectedDay.year}-${_selectedDay.month}-${_selectedDay.day}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Theme(
                    data: Theme.of(context).copyWith(
                      inputDecorationTheme: InputDecorationTheme(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFF6A4C93)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF6A4C93), width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              labelText: 'Select Instrument'),
                          items: _instruments.keys.map((String instrument) {
                            return DropdownMenuItem<String>(
                              value: instrument,
                              child: Row(
                                children: [
                                  Image.asset(_instruments[instrument]!,
                                      width: 24, height: 24),
                                  const SizedBox(width: 8),
                                  Text(instrument),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            selectedInstrument = value;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: durationController,
                          decoration: InputDecoration(
                            labelText: 'Practice Duration (minutes)',
                            hintText: 'e.g., 30',
                            errorText: durationError,
                            counterText: '${durationController.text.length}/4',
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          onChanged: (value) {
                            setState(() {
                              if (value.isEmpty) {
                                durationError = 'Duration is required';
                              } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                durationError = 'Please enter numbers only';
                              } else if (int.parse(value) <= 0) {
                                durationError =
                                    'Duration must be greater than 0';
                              } else if (int.parse(value) > 1440) {
                                durationError =
                                    'Duration cannot exceed 24 hours';
                              } else {
                                durationError = null;
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: notesController,
                          decoration: const InputDecoration(
                            labelText: 'Notes/Issues',
                            hintText:
                                'Enter practice notes or issues encountered...',
                            counterText: '',
                          ),
                          maxLines: 3,
                          maxLength: 200,
                          buildCounter: (
                            BuildContext context, {
                            required int currentLength,
                            required int? maxLength,
                            required bool isFocused,
                          }) {
                            return Text(
                              '$currentLength/$maxLength',
                              style: TextStyle(
                                color: currentLength == maxLength
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Color(0xFF666666)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () async {
                          if (selectedInstrument != null &&
                              durationController.text.isNotEmpty &&
                              durationError == null) {
                            final record = PracticeRecord(
                              date: _selectedDay,
                              instrument: selectedInstrument!,
                              duration: int.parse(durationController.text),
                              notes: notesController.text,
                            );
                            await _databaseService.insertRecord(record);
                            if (mounted) {
                              Navigator.pop(context);
                              await _loadRecords();
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A4C93),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside of text fields
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FF),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
                              const Text(
                                'Practice Records',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Track your daily practice progress',
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
                    const SizedBox(height: 20),
                    Container(
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
                      child: Column(
                        children: [
                          TableCalendar(
                            firstDay: DateTime.now()
                                .subtract(const Duration(days: 365)),
                            lastDay:
                                DateTime.now().add(const Duration(days: 365)),
                            focusedDay: _focusedDay,
                            selectedDayPredicate: (day) =>
                                isSameDay(_selectedDay, day),
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                              _loadRecords();
                            },
                            calendarFormat: _calendarFormat,
                            calendarStyle: const CalendarStyle(
                              selectedDecoration: BoxDecoration(
                                color: Color(0xFF6A4C93),
                                shape: BoxShape.circle,
                              ),
                              todayDecoration: BoxDecoration(
                                color: Color(0xFF9B6DFF),
                                shape: BoxShape.circle,
                              ),
                              markersMaxCount: 1,
                              markerDecoration: BoxDecoration(
                                color: Color(0xFF6A4C93),
                                shape: BoxShape.circle,
                              ),
                            ),
                            availableCalendarFormats: const {
                              CalendarFormat.month: 'Month',
                              CalendarFormat.week: 'Week',
                            },
                            calendarBuilders: CalendarBuilders(
                              markerBuilder: (context, date, events) {
                                if (_datesWithRecords.contains(DateTime(
                                    date.year, date.month, date.day))) {
                                  return Positioned(
                                    bottom: 1,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue,
                                      ),
                                      width: 6.0,
                                      height: 6.0,
                                    ),
                                  );
                                }
                                return null;
                              },
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _calendarFormat =
                                    _calendarFormat == CalendarFormat.month
                                        ? CalendarFormat.week
                                        : CalendarFormat.month;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.grey.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _calendarFormat == CalendarFormat.month
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: const Color(0xFF6A4C93),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _calendarFormat == CalendarFormat.month
                                        ? 'Collapse Calendar'
                                        : 'Expand Calendar',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6A4C93),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Practice Records for ${_selectedDay.year}-${_selectedDay.month}-${_selectedDay.day}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ),
              if (_records.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.music_note_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No records today. Tap + to add',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _records.length,
                    itemBuilder: (context, index) {
                      final record = _records[index];
                      return Dismissible(
                        key: Key(record.id.toString()),
                        background: Container(
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) async {
                          await _databaseService.deleteRecord(record.id!);
                          setState(() {
                            _records.removeAt(index);
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: const Color(0xFFF5F6FA),
                                  ),
                                  child: Image.asset(
                                    _instruments[record.instrument]!,
                                    width: 40,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${record.instrument} Practice',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF2C3E50),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${record.duration} minutes',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF666666),
                                        ),
                                      ),
                                      if (record.notes.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          record.notes,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF666666),
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddPracticeDialog,
          backgroundColor: const Color(0xFF9B6DFF),
          foregroundColor: Colors.white,
          elevation: 4,
          icon: const Icon(Icons.add),
          label: const Text(
            'Add ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
