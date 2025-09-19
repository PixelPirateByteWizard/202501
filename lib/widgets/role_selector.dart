import 'package:flutter/material.dart';
import '../models/ai_role.dart';
import '../theme/app_theme.dart';
import 'role_detail_dialog.dart';
import '../screens/role_selector_screen.dart';

class RoleSelector extends StatelessWidget {
  final AIRole? selectedRole;
  final Function(AIRole) onRoleSelected;

  const RoleSelector({
    super.key,
    this.selectedRole,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select AI Role',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => _showFullScreenSelector(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryEnd.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryEnd.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.primaryEnd,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.fullscreen,
                          size: 14,
                          color: AppTheme.primaryEnd,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: AIRole.getAllRoles().length + 1, // +1 for "View All" button
              itemBuilder: (context, index) {
                // Show "View All" button as the last item
                if (index == AIRole.getAllRoles().length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => _showFullScreenSelector(context),
                      child: SizedBox(
                        width: 60,
                        child: Column(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: AppTheme.primaryEnd.withValues(alpha: 0.3),
                                  width: 2,
                                ),
                                color: AppTheme.primaryEnd.withValues(alpha: 0.1),
                              ),
                              child: Icon(
                                Icons.apps,
                                color: AppTheme.primaryEnd,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'View All',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.primaryEnd,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                
                final role = AIRole.getAllRoles()[index];
                final isSelected = selectedRole?.id == role.id;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () => onRoleSelected(role),
                    onLongPress: () => _showRoleDetail(context, role),
                    child: SizedBox(
                      width: 60,
                      child: Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: isSelected 
                                  ? AppTheme.primaryEnd 
                                  : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(23),
                              child: Image.asset(
                                role.imagePath,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      gradient: AppTheme.primaryGradient,
                                      borderRadius: BorderRadius.circular(23),
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            role.name,
                            style: TextStyle(
                              fontSize: 10,
                              color: isSelected 
                                ? AppTheme.primaryEnd 
                                : AppTheme.textSecondary,
                              fontWeight: isSelected 
                                ? FontWeight.w600 
                                : FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
    );
  }

  void _showRoleDetail(BuildContext context, AIRole role) {
    showDialog(
      context: context,
      builder: (context) => RoleDetailDialog(
        role: role,
        onRoleSelected: onRoleSelected,
      ),
    );
  }

  void _showFullScreenSelector(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenRoleSelector(
          selectedRole: selectedRole,
          onRoleSelected: (role) {
            onRoleSelected(role);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}