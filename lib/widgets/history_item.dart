import 'package:flutter/material.dart';
import '../models/pomodoro_model.dart';
import '../utils/time_utils.dart';

class HistoryItem extends StatelessWidget {
  final PomodoroSession session;
  final Function(String) onEdit;
  final Function(String) onDelete;
  final bool isEditing;
  final TextEditingController controller;

  const HistoryItem({
    Key? key,
    required this.session,
    required this.onEdit,
    required this.onDelete,
    this.isEditing = false,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF24263A),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7F5AF0).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.timer_outlined,
                    color: Color(0xFF7F5AF0),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isEditing)
                        TextField(
                          controller: controller,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF7F5AF0), width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                          autofocus: true,
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              onEdit(session.id);
                            }
                          },
                        )
                      else
                        Text(
                          session.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Color(0xFF94A1B2),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formatDateOnly(session.completedAt),
                            style: const TextStyle(
                              color: Color(0xFF94A1B2),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.access_time,
                            color: Color(0xFF94A1B2),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formatTimeOnly(session.completedAt),
                            style: const TextStyle(
                              color: Color(0xFF94A1B2),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!isEditing)
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: Colors.white70, size: 20),
                        onPressed: () => onEdit(session.id),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Edit',
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.white70, size: 20),
                        onPressed: () => onDelete(session.id),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Delete',
                      ),
                    ],
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.check_circle,
                        color: Color(0xFF2CB67D), size: 24),
                    onPressed: () => onEdit(session.id),
                    tooltip: 'Save',
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF16161A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'Duration',
                    session.duration,
                    Icons.timelapse,
                    const Color(0xFF7F5AF0),
                  ),
                  _buildDivider(),
                  _buildStatItem(
                    'Focus',
                    '100%',
                    Icons.trending_up,
                    const Color(0xFF2CB67D),
                  ),
                  _buildDivider(),
                  _buildStatItem(
                    'Status',
                    'Completed',
                    Icons.check_circle_outline,
                    const Color(0xFF2CB67D),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.white.withOpacity(0.1),
    );
  }
}
