import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _focusNode = FocusNode();
  String _selectedType = 'Feature Request';
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<Map<String, dynamic>> _feedbackTypes = [
    {
      'type': 'Bug Report',
      'icon': Icons.bug_report_rounded,
      'color': Colors.red,
      'description': 'Report any issues or bugs you\'ve encountered',
    },
    {
      'type': 'Feature Request',
      'icon': Icons.lightbulb_rounded,
      'color': Colors.amber,
      'description': 'Suggest new features or improvements',
    },
    {
      'type': 'Performance Issue',
      'icon': Icons.speed_rounded,
      'color': Colors.orange,
      'description': 'Report game performance problems',
    },
    {
      'type': 'General Feedback',
      'icon': Icons.feedback_rounded,
      'color': Colors.green,
      'description': 'Share your thoughts and experiences',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Set landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    // 移除恢复屏幕方向的代码，保持横屏状态
    _titleController.dispose();
    _contentController.dispose();
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _unfocus() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocus,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF4EABE9).withOpacity(0.1),
                const Color(0xFFF5FAFD),
              ],
            ),
          ),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 120.0,
                floating: false,
                pinned: true,
                stretch: true,
                backgroundColor: const Color(0xFF4EABE9),
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    'Share Your Feedback',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF4EABE9),
                          const Color(0xFF4EABE9).withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    FadeTransition(
                      opacity: _animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.1),
                          end: Offset.zero,
                        ).animate(_animation),
                        child: _buildWelcomeCard(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeTransition(
                      opacity: _animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.1),
                          end: Offset.zero,
                        ).animate(_animation),
                        child: _buildFeedbackForm(),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, const Color(0xFFF5FAFD)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4EABE9).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4EABE9).withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.rate_review_rounded,
                      color: Color(0xFF4EABE9),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Help Us Improve Your Experience',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Your feedback is invaluable in making our game better for everyone. Whether you\'ve found a bug, have a suggestion, or just want to share your thoughts, we\'re here to listen.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF7F8C8D),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackForm() {
    return Form(
      key: _formKey,
      child: Card(
        elevation: 8,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, const Color(0xFFF5FAFD)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'What would you like to share with us?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 20),
                _buildFeedbackTypeSelector(),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _titleController,
                  focusNode: _focusNode,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2C3E50),
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4EABE9),
                      fontWeight: FontWeight.w500,
                    ),
                    hintText:
                        'Brief summary of your feedback (5-50 characters)',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.normal,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF4EABE9),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.title_rounded,
                      color: Color(0xFF4EABE9),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    counterText: '${_titleController.text.length}/50',
                    counterStyle: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4EABE9),
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  maxLength: 50,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    if (value.length < 5) {
                      return 'Title must be at least 5 characters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {}); // Update counter
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contentController,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2C3E50),
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Details',
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4EABE9),
                      fontWeight: FontWeight.w500,
                    ),
                    hintText:
                        'Please provide as much detail as possible (20-500 characters)',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.normal,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF4EABE9),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.description_rounded,
                      color: Color(0xFF4EABE9),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    counterText: '${_contentController.text.length}/500',
                    counterStyle: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4EABE9),
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    alignLabelWithHint: true,
                  ),
                  maxLength: 500,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  maxLines: 5,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide detailed feedback';
                    }
                    if (value.length < 20) {
                      return 'Please provide at least 20 characters of feedback';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {}); // Update counter
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      _unfocus(); // Dismiss keyboard before showing dialog
                      _submitFeedback();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4EABE9),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.send_rounded),
                        const SizedBox(width: 8),
                        Text(
                          'Submit ${_selectedType}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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

  Widget _buildFeedbackTypeSelector() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _feedbackTypes.length,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemBuilder: (context, index) {
          final type = _feedbackTypes[index];
          final isSelected = _selectedType == type['type'];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () => setState(() => _selectedType = type['type']),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 180,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? type['color'].withOpacity(0.1)
                          : Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isSelected
                            ? type['color']
                            : Colors.grey.withOpacity(0.2),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      type['icon'],
                      color: isSelected ? type['color'] : Colors.grey,
                      size: 28,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      type['type'],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color:
                            isSelected
                                ? type['color']
                                : const Color(0xFF2C3E50),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      type['description'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement feedback submission logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Thank you for your feedback! We\'ll review it shortly.',
          ),
          backgroundColor: const Color(0xFF4EABE9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
      Navigator.pop(context);
    }
  }
}
