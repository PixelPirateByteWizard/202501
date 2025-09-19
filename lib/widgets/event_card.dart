import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';
import '../screens/add_event_screen.dart';
import '../theme/app_theme.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
    this.onComplete,
  });

  void _showEventOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.dark800,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            
            Text(
              event.title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            _buildOptionTile(
              context,
              icon: Icons.edit,
              title: 'Edit Event',
              onTap: () {
                Navigator.pop(context);
                _editEvent(context);
              },
            ),
            
            _buildOptionTile(
              context,
              icon: event.isCompleted ? Icons.undo : Icons.check_circle,
              title: event.isCompleted ? 'Mark as Incomplete' : 'Mark as Complete',
              onTap: () {
                Navigator.pop(context);
                _toggleComplete(context);
              },
            ),
            
            _buildOptionTile(
              context,
              icon: Icons.delete,
              title: 'Delete Event',
              color: Colors.red,
              onTap: () {
                Navigator.pop(context);
                _deleteEvent(context);
              },
            ),
            
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? AppTheme.textPrimary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? AppTheme.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  void _editEvent(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEventScreen(eventToEdit: event),
      ),
    );
  }

  void _toggleComplete(BuildContext context) {
    context.read<EventProvider>().updateEvent(
      event.copyWith(isCompleted: !event.isCompleted),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          event.isCompleted 
            ? 'Event marked as incomplete' 
            : 'Event completed!',
        ),
        backgroundColor: AppTheme.primaryEnd,
      ),
    );
  }

  void _deleteEvent(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.dark800,
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<EventProvider>().deleteEvent(event.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Event deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _showEventOptions(context),
      child: Container(
        margin: const EdgeInsets.only(left: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline dot and line
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: event.category.color,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 2,
                  height: 60,
                  color: AppTheme.dark700,
                ),
              ],
            ),
            
            const SizedBox(width: 16),
            
            // Event content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.dark800,
                  borderRadius: BorderRadius.circular(12),
                  border: event.hasConflict
                      ? Border.all(color: Colors.red.shade400, width: 1)
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${DateFormat('HH:mm').format(event.startTime)} - ${DateFormat('HH:mm').format(event.endTime)}',
                                style: TextStyle(
                                  color: event.category.color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                event.title,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  decoration: event.isCompleted 
                                      ? TextDecoration.lineThrough 
                                      : null,
                                ),
                              ),
                              if (event.description.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  event.description,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                              if (event.location != null) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 12,
                                      color: AppTheme.textSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      event.location!,
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        
                        // Action icons
                        Row(
                          children: [
                            if (event.hasConflict)
                              Icon(
                                Icons.warning,
                                color: Colors.red.shade400,
                                size: 20,
                              ),
                            if (event.hasVideoCall) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppTheme.dark700,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  Icons.videocam,
                                  color: event.category.color,
                                  size: 16,
                                ),
                              ),
                            ],
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppTheme.dark700,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                event.category.icon,
                                color: event.category.color,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
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