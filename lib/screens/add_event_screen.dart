import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../models/event.dart';
import '../theme/app_theme.dart';

class AddEventScreen extends StatefulWidget {
  final Event? eventToEdit;
  
  const AddEventScreen({super.key, this.eventToEdit});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  Duration _duration = const Duration(minutes: 30);
  EventCategory _selectedCategory = EventCategory.work;
  bool _hasVideoCall = false;
  
  bool get _isEditing => widget.eventToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _initializeWithEvent(widget.eventToEdit!);
    }
  }

  void _initializeWithEvent(Event event) {
    _titleController.text = event.title;
    _descriptionController.text = event.description;
    _locationController.text = event.location ?? '';
    _selectedDate = event.startTime;
    _selectedTime = TimeOfDay.fromDateTime(event.startTime);
    _duration = event.duration;
    _selectedCategory = event.category;
    _hasVideoCall = event.hasVideoCall;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _saveEvent() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an event title')),
      );
      return;
    }

    final startTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    if (_isEditing) {
      // Update existing event
      final updatedEvent = widget.eventToEdit!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        startTime: startTime,
        endTime: startTime.add(_duration),
        category: _selectedCategory,
        location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
        hasVideoCall: _hasVideoCall,
      );
      
      context.read<EventProvider>().updateEvent(updatedEvent);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event updated successfully'),
          backgroundColor: AppTheme.primaryEnd,
        ),
      );
    } else {
      // Create new event
      final event = Event(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        startTime: startTime,
        endTime: startTime.add(_duration),
        category: _selectedCategory,
        location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
        hasVideoCall: _hasVideoCall,
      );

      context.read<EventProvider>().addEvent(event);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event created successfully'),
          backgroundColor: AppTheme.primaryEnd,
        ),
      );
    }
    
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    _isEditing ? 'Edit Event' : 'Add Event',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event Title
                    _buildSectionTitle('Event Title'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _titleController,
                      hintText: "What's the event?",
                    ),
                    const SizedBox(height: 24),
                    
                    // Date & Time
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Date'),
                              const SizedBox(height: 8),
                              _buildDateTimeField(
                                value: '${_selectedDate.day}/${_selectedDate.month}',
                                icon: Icons.calendar_today,
                                onTap: _selectDate,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Time'),
                              const SizedBox(height: 8),
                              _buildDateTimeField(
                                value: _selectedTime.format(context),
                                icon: Icons.access_time,
                                onTap: _selectTime,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Duration
                    _buildSectionTitle('Duration'),
                    const SizedBox(height: 8),
                    _buildDurationSelector(),
                    const SizedBox(height: 24),
                    
                    // Category
                    _buildSectionTitle('Category'),
                    const SizedBox(height: 8),
                    _buildCategorySelector(),
                    const SizedBox(height: 24),
                    
                    // Location
                    _buildSectionTitle('Location'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _locationController,
                      hintText: 'Add location',
                      prefixIcon: Icons.location_on,
                    ),
                    const SizedBox(height: 24),
                    
                    // Video Conference
                    _buildVideoCallToggle(),
                    const SizedBox(height: 24),
                    
                    // Notes
                    _buildSectionTitle('Notes'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _descriptionController,
                      hintText: 'Add details about your event',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),
                    
                    // Add Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveEvent,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryEnd,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          _isEditing ? 'Update Event' : 'Add Event',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppTheme.textSecondary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    IconData? prefixIcon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: AppTheme.textPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppTheme.textSecondary),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: AppTheme.primaryEnd)
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildDateTimeField({
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(color: AppTheme.textPrimary),
              ),
            ),
            Icon(icon, color: AppTheme.primaryEnd),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationSelector() {
    final durations = [
      const Duration(minutes: 15),
      const Duration(minutes: 30),
      const Duration(minutes: 45),
      const Duration(hours: 1),
      const Duration(hours: 2),
    ];

    return Wrap(
      spacing: 8,
      children: durations.map((duration) {
        final isSelected = _duration == duration;
        return GestureDetector(
          onTap: () => setState(() => _duration = duration),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryEnd
                  : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _formatDuration(duration),
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategorySelector() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: EventCategory.values.map((category) {
        final isSelected = _selectedCategory == category;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = category),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppTheme.primaryEnd
                    : Colors.white.withValues(alpha: 0.1),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: category.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    category.icon,
                    color: category.color,
                    size: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category.name,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVideoCallToggle() {
    return Row(
      children: [
        Icon(
          Icons.videocam,
          color: AppTheme.primaryEnd,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Video Conference',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Add video meeting link',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Switch(
          value: _hasVideoCall,
          onChanged: (value) => setState(() => _hasVideoCall = value),
          activeThumbColor: AppTheme.primaryEnd,
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h';
    } else {
      return '${duration.inMinutes}min';
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }
}