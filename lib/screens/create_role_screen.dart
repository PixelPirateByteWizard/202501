import 'package:flutter/material.dart';
import '../models/ai_role.dart';
import '../theme/app_theme.dart';

class CreateRoleScreen extends StatefulWidget {
  final Function(AIRole) onRoleCreated;

  const CreateRoleScreen({super.key, required this.onRoleCreated});

  @override
  State<CreateRoleScreen> createState() => _CreateRoleScreenState();
}

class _CreateRoleScreenState extends State<CreateRoleScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _personalityController = TextEditingController();
  final _specialtyController = TextEditingController();

  final List<String> _specialties = [];
  String _selectedAvatar = 'assets/role/custom_avatar.png';
  bool _isCreating = false;

  // Preset avatar options
  final List<String> _avatarOptions = [
    'assets/role/Role_1.png',
    'assets/role/Role_2.png',
    'assets/role/Role_3.png',
    'assets/role/Role_4.png',
    'assets/role/Role_5.png',
    'assets/role/Role_6.png',
    'assets/role/Role_7.png',
    'assets/role/Role_8.png',
    'assets/role/Role_9.png',
    'assets/role/Role_10.png',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _personalityController.dispose();
    _specialtyController.dispose();
    super.dispose();
  }

  void _addSpecialty() {
    final specialty = _specialtyController.text.trim();
    if (specialty.isNotEmpty && !_specialties.contains(specialty)) {
      setState(() {
        _specialties.add(specialty);
        _specialtyController.clear();
      });
    }
  }

  void _removeSpecialty(String specialty) {
    setState(() {
      _specialties.remove(specialty);
    });
  }

  void _createRole() async {
    if (!_formKey.currentState!.validate()) return;
    if (_specialties.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one specialty area'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isCreating = true;
    });

    // Simulate creation process
    await Future.delayed(const Duration(milliseconds: 800));

    final newRole = AIRole(
      id: DateTime.now().millisecondsSinceEpoch, // Use timestamp as ID
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      imagePath: _selectedAvatar,
      personality: _personalityController.text.trim(),
      specialties: List.from(_specialties),
    );

    widget.onRoleCreated(newRole);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('AI Role "${newRole.name}" created successfully!'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'Use',
            textColor: Colors.white,
            onPressed: () {
              Navigator.pop(context, newRole);
            },
          ),
        ),
      );

      Navigator.pop(context, newRole);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.dark900,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Create AI Role',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                            ),
                            Text(
                              'Design your personalized AI assistant',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Form Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar Selection
                          _buildSectionTitle('Select Avatar'),
                          const SizedBox(height: 12),
                          _buildAvatarSelector(),
                          const SizedBox(height: 24),

                          // Name Input
                          _buildSectionTitle('Role Name'),
                          const SizedBox(height: 12),
                          _buildTextFormField(
                            controller: _nameController,
                            hintText: 'Give your AI assistant a name',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a role name';
                              }
                              if (value.trim().length > 20) {
                                return 'Role name cannot exceed 20 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // Description Input
                          _buildSectionTitle('Role Description'),
                          const SizedBox(height: 12),
                          _buildTextFormField(
                            controller: _descriptionController,
                            hintText: 'Describe the main functions and features of this AI assistant',
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a role description';
                              }
                              if (value.trim().length > 200) {
                                return 'Description cannot exceed 200 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // Personality Input
                          _buildSectionTitle('Personality Traits'),
                          const SizedBox(height: 12),
                          _buildTextFormField(
                            controller: _personalityController,
                            hintText: 'e.g., Friendly, Professional, Efficient',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter personality traits';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // Specialties Input
                          _buildSectionTitle('Specialty Areas'),
                          const SizedBox(height: 12),
                          _buildSpecialtyInput(),
                          const SizedBox(height: 12),
                          _buildSpecialtyTags(),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),

                // Create Button
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isCreating ? null : _createRole,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryEnd,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isCreating
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text('Creating...'),
                              ],
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Create AI Role',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: AppTheme.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppTheme.textSecondary),
        filled: true,
        fillColor: AppTheme.dark800,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryEnd),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildAvatarSelector() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _avatarOptions.length,
        itemBuilder: (context, index) {
          final avatar = _avatarOptions[index];
          final isSelected = _selectedAvatar == avatar;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedAvatar = avatar;
                });
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryEnd
                        : Colors.white.withValues(alpha: 0.2),
                    width: isSelected ? 3 : 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.asset(
                    avatar,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpecialtyInput() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _specialtyController,
            style: const TextStyle(color: AppTheme.textPrimary),
            decoration: InputDecoration(
              hintText: 'Enter specialty area, e.g., "Time Management"',
              hintStyle: const TextStyle(color: AppTheme.textSecondary),
              filled: true,
              fillColor: AppTheme.dark800,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryEnd),
              ),
            ),
            onFieldSubmitted: (_) => _addSpecialty(),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: AppTheme.primaryEnd,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: _addSpecialty,
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialtyTags() {
    if (_specialties.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.dark800,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: const Center(
          child: Text(
            'No specialty areas yet, please add at least one',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _specialties.map((specialty) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primaryEnd.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.primaryEnd.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                specialty,
                style: const TextStyle(
                  color: AppTheme.primaryEnd,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => _removeSpecialty(specialty),
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: AppTheme.primaryEnd.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
