import 'package:flutter/material.dart';
import '../models/goal.dart';
import 'update_option_button.dart';

void showGoalDetailsBottomSheet({
  required BuildContext context,
  required Goal goal,
  required Function(double progress,
          {double? value, String? note, bool isTotal})
      onProgressUpdate,
  VoidCallback? onClose,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return GoalDetailsBottomSheet(
        goal: goal,
        onProgressUpdate: onProgressUpdate,
        onClose: onClose,
      );
    },
  );
}

class GoalDetailsBottomSheet extends StatelessWidget {
  final Goal goal;
  final Function(double progress, {double? value, String? note, bool isTotal})
      onProgressUpdate;
  final VoidCallback? onClose;

  const GoalDetailsBottomSheet({
    Key? key,
    required this.goal,
    required this.onProgressUpdate,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle indicator
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          // Title and numeric info
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    goal.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (goal.isNumericGoal)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8FB3B0).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.trending_up,
                          size: 16,
                          color: Color(0xFF8FB3B0),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${goal.currentValue.toStringAsFixed(1)} / ${goal.targetValue.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8FB3B0),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              goal.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.7),
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Numeric goal section
          if (goal.isNumericGoal) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Update Progress',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: UpdateOptionButton(
                                icon: Icons.add,
                                label: 'Add Value',
                                onTap: () => _showAddValueDialog(context, goal),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: UpdateOptionButton(
                                icon: Icons.edit,
                                label: 'Set Total',
                                onTap: () => _showSetTotalDialog(context, goal),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: goal.records.length,
                itemBuilder: (context, index) {
                  final record = goal.records[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8FB3B0).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            record.isTotal ? Icons.edit : Icons.add,
                            size: 16,
                            color: const Color(0xFF8FB3B0),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                record.isTotal
                                    ? 'Set total to ${record.value}'
                                    : 'Added ${record.value}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                _formatDate(record.date),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              )
                            ],
                          ),
                        ),
                        if (record.note.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              record.note,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ] else ...[
            // Non-numeric goal progress update
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progress',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: goal.progress,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation(
                              goal.progress > 0.75
                                  ? const Color(0xFF4CAF50)
                                  : const Color(0xFF8FB3B0),
                            ),
                            minHeight: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${(goal.progress * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: goal.progress > 0.75
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFF8FB3B0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Update Progress',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                  // Progress slider with ValueNotifier for better state management
                  Builder(
                    builder: (context) {
                      // Create a ValueNotifier to manage the slider state
                      final progressNotifier =
                          ValueNotifier<double>(goal.progress);

                      return Column(
                        children: [
                          ValueListenableBuilder<double>(
                              valueListenable: progressNotifier,
                              builder: (context, value, _) {
                                return Slider(
                                  value: value,
                                  onChanged: (newValue) {
                                    progressNotifier.value = newValue;
                                  },
                                  activeColor: const Color(0xFF8FB3B0),
                                  inactiveColor: Colors.grey[200],
                                );
                              }),
                          ValueListenableBuilder<double>(
                              valueListenable: progressNotifier,
                              builder: (context, value, _) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${(value * 100).toInt()}%',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // For non-numeric goals, we need to explicitly set isTotal to true
                                        // and pass the progress value directly
                                        onProgressUpdate(value,
                                            value: null,
                                            note: 'Manual update',
                                            isTotal: true);

                                        // Show a confirmation snackbar
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Progress updated to ${(value * 100).toInt()}%'),
                                            backgroundColor:
                                                const Color(0xFF4CAF50),
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            margin: const EdgeInsets.all(16),
                                            duration:
                                                const Duration(seconds: 2),
                                          ),
                                        );

                                        Navigator.pop(context);
                                        if (onClose != null) {
                                          onClose!();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF8FB3B0),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: const Text('Update'),
                                    ),
                                  ],
                                );
                              }),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Creation and update info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Created: ${_formatDate(goal.createdAt)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Last updated: ${_formatDate(goal.updatedAt)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Helper method to format date
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Dialog to add a value to a numeric goal
  Future<void> _showAddValueDialog(BuildContext context, Goal goal) {
    final valueController = TextEditingController();
    final noteController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AlertDialog(
          title: const Text('Add Value'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: valueController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false,
                ),
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Value to add',
                  hintText: 'Enter value',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: noteController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  hintText: 'Enter note',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final value = double.tryParse(valueController.text);
                if (value != null) {
                  onProgressUpdate(
                    goal.progress,
                    value: value,
                    note: noteController.text,
                    isTotal: false,
                  );
                  Navigator.pop(context);
                  if (onClose != null) {
                    onClose!();
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog to set the total value of a numeric goal
  Future<void> _showSetTotalDialog(BuildContext context, Goal goal) {
    final valueController = TextEditingController();
    final noteController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AlertDialog(
          title: const Text('Set Total Value'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: valueController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false,
                ),
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Total value',
                  hintText: 'Enter total value',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: noteController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  hintText: 'Enter note',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final value = double.tryParse(valueController.text);
                if (value != null) {
                  onProgressUpdate(
                    goal.progress,
                    value: value,
                    note: noteController.text,
                    isTotal: true,
                  );
                  Navigator.pop(context);
                  if (onClose != null) {
                    onClose!();
                  }
                }
              },
              child: const Text('Set'),
            ),
          ],
        ),
      ),
    );
  }
}
