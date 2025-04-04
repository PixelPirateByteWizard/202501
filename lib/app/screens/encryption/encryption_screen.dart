import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glassmorphic_container.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class EncryptionScreen extends StatefulWidget {
  const EncryptionScreen({super.key});

  @override
  State<EncryptionScreen> createState() => _EncryptionScreenState();
}

class _EncryptionScreenState extends State<EncryptionScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();

  late TabController _tabController;
  bool _isEncrypting = true;
  bool _showPassword = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _isEncrypting = _tabController.index == 0;
        _outputController.clear();
      });
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _passwordController.dispose();
    _outputController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Simple encryption/decryption for demo purposes
  String _encryptData(String text, String password) {
    if (text.isEmpty) return '';

    // Create a key from the password
    final key = utf8.encode(password);
    final bytes = utf8.encode(text);

    // Use HMAC-SHA256 for the encryption (in a real app, use a more robust encryption method)
    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);

    // XOR the text with the digest for a simple encryption
    final encrypted = List<int>.filled(bytes.length, 0);
    for (var i = 0; i < bytes.length; i++) {
      encrypted[i] = bytes[i] ^ digest.bytes[i % digest.bytes.length];
    }

    // Convert to Base64 for readability
    return base64.encode(encrypted);
  }

  String _decryptData(String encryptedText, String password) {
    try {
      // Decode from Base64
      final encrypted = base64.decode(encryptedText);

      // Create a key from the password
      final key = utf8.encode(password);

      // Use HMAC-SHA256 for the decryption
      final hmacSha256 = Hmac(sha256, key);
      final digest = hmacSha256.convert(utf8.encode(password));

      // XOR the encrypted data with the digest for decryption
      final decrypted = List<int>.filled(encrypted.length, 0);
      for (var i = 0; i < encrypted.length; i++) {
        decrypted[i] = encrypted[i] ^ digest.bytes[i % digest.bytes.length];
      }

      // Convert back to string
      return utf8.decode(decrypted);
    } catch (e) {
      return 'Error: Failed to decrypt. Make sure the input is valid encrypted text and the password is correct.';
    }
  }

  void _processData() {
    setState(() {
      _isProcessing = true;
    });

    // Simulate processing delay
    Future.delayed(const Duration(milliseconds: 300), () {
      final inputText = _inputController.text;
      final password = _passwordController.text;

      String result = '';
      if (_isEncrypting) {
        result = _encryptData(inputText, password);
      } else {
        result = _decryptData(inputText, password);
      }

      setState(() {
        _outputController.text = result;
        _isProcessing = false;
      });
    });
  }

  void _clearText() {
    setState(() {
      _inputController.clear();
      _outputController.clear();
    });
  }

  void _copyToClipboard() {
    final textToCopy = _outputController.text;
    if (textToCopy.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: textToCopy));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab bar for encrypting/decrypting
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.surfaceVariant.withOpacity(0.5),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.primary,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textMedium,
                tabs: const [
                  Tab(text: 'Encrypt'),
                  Tab(text: 'Decrypt'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Input label
            Text(
              _isEncrypting ? 'Text to Encrypt' : 'Text to Decrypt',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),

            const SizedBox(height: 16),

            // Input field with glassmorphism
            GlassmorphicContainer(
              width: double.infinity,
              height: 150,
              borderRadius: 20,
              blur: 10,
              alignment: Alignment.center,
              border: 0.5,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.6),
                  Colors.white.withOpacity(0.3),
                ],
              ),
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _inputController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: _isEncrypting
                        ? 'Enter text to encrypt...'
                        : 'Enter encrypted text to decrypt...',
                    hintStyle: TextStyle(color: AppColors.textLight),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      onPressed: _clearText,
                      icon: Icon(
                        Icons.clear_rounded,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Password field
            Text(
              'Password',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),

            const SizedBox(height: 16),

            // Password input field
            GlassmorphicContainer(
              width: double.infinity,
              height: 60,
              borderRadius: 20,
              blur: 10,
              alignment: Alignment.center,
              border: 0.5,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.6),
                  Colors.white.withOpacity(0.3),
                ],
              ),
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    hintText: 'Enter password...',
                    hintStyle: TextStyle(color: AppColors.textLight),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                      icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Process button
            Center(
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processData,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        _isEncrypting ? 'Encrypt' : 'Decrypt',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 32),

            // Output label
            if (_outputController.text.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Result',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                      ),
                      IconButton(
                        onPressed: _copyToClipboard,
                        icon: Icon(
                          Icons.copy_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Output field
                  GlassmorphicContainer(
                    width: double.infinity,
                    height: 150,
                    borderRadius: 20,
                    blur: 10,
                    alignment: Alignment.center,
                    border: 0.5,
                    linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.6),
                        Colors.white.withOpacity(0.3),
                      ],
                    ),
                    borderGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _outputController.text.startsWith('Error')
                            ? AppColors.error.withOpacity(0.2)
                            : AppColors.success.withOpacity(0.2),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: _outputController,
                        readOnly: true,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: _outputController.text.startsWith('Error')
                              ? AppColors.error
                              : AppColors.textDark,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
