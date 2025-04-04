import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glassmorphic_container.dart';
import '../../../services/storage_service.dart';
import 'package:qr_flutter/qr_flutter.dart';

enum QrCodeType { text, url, contact, wifi }

// Custom enum for QR error correction levels
enum ErrorCorrectionLevel { low, medium, quarter, high }

// Extension to convert our enum to the integer values required by qr_flutter
extension ErrorCorrectionLevelExtension on ErrorCorrectionLevel {
  int get value {
    switch (this) {
      case ErrorCorrectionLevel.low:
        return QrErrorCorrectLevel.L;
      case ErrorCorrectionLevel.medium:
        return QrErrorCorrectLevel.M;
      case ErrorCorrectionLevel.quarter:
        return QrErrorCorrectLevel.Q;
      case ErrorCorrectionLevel.high:
        return QrErrorCorrectLevel.H;
    }
  }

  String get displayName {
    switch (this) {
      case ErrorCorrectionLevel.low:
        return 'Low (7%)';
      case ErrorCorrectionLevel.medium:
        return 'Medium (15%)';
      case ErrorCorrectionLevel.quarter:
        return 'Quarter (25%)';
      case ErrorCorrectionLevel.high:
        return 'High (30%)';
    }
  }
}

class QrGeneratorScreen extends StatefulWidget {
  const QrGeneratorScreen({super.key});

  @override
  State<QrGeneratorScreen> createState() => _QrGeneratorScreenState();
}

class _QrGeneratorScreenState extends State<QrGeneratorScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _wifiNameController = TextEditingController();
  final TextEditingController _wifiPasswordController = TextEditingController();

  String _qrData = '';
  bool _hasGeneratedQR = false;
  QrCodeType _qrCodeType = QrCodeType.text;
  ErrorCorrectionLevel _errorCorrectLevel = ErrorCorrectionLevel.medium;
  Color _qrColor = Colors.black;
  bool _wifiIsHidden = false;
  String _wifiEncryption = 'WPA';

  @override
  void dispose() {
    _textController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _wifiNameController.dispose();
    _wifiPasswordController.dispose();
    super.dispose();
  }

  String _getFormattedQRData() {
    switch (_qrCodeType) {
      case QrCodeType.text:
        return _textController.text;
      case QrCodeType.url:
        String url = _textController.text;
        if (url.isNotEmpty &&
            !url.startsWith('http://') &&
            !url.startsWith('https://')) {
          url = 'https://$url';
        }
        return url;
      case QrCodeType.contact:
        // vCard format
        return 'BEGIN:VCARD\n'
            'VERSION:3.0\n'
            'N:${_nameController.text}\n'
            'TEL:${_phoneController.text}\n'
            'EMAIL:${_emailController.text}\n'
            'END:VCARD';
      case QrCodeType.wifi:
        // WiFi format
        return 'WIFI:S:${_wifiNameController.text};'
            'T:${_wifiEncryption};'
            'P:${_wifiPasswordController.text};'
            'H:${_wifiIsHidden ? 'true' : 'false'};;';
    }
  }

  void _generateQrCode() {
    final formattedData = _getFormattedQRData();

    if (formattedData.isNotEmpty) {
      setState(() {
        _qrData = formattedData;
        _hasGeneratedQR = true;
      });

      // Hide keyboard
      FocusScope.of(context).unfocus();

      // Save to history
      _saveToHistory(formattedData);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter data to generate QR code'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _saveToHistory(String data) {
    // In a real app, this would save to SharedPreferences via StorageService
    // For example:
    // StorageService.addToHistory(StorageService.qrHistoryKey, {
    //   'data': data,
    //   'timestamp': DateTime.now().millisecondsSinceEpoch,
    // });
  }

  void _clearText() {
    switch (_qrCodeType) {
      case QrCodeType.text:
      case QrCodeType.url:
        _textController.clear();
        break;
      case QrCodeType.contact:
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        break;
      case QrCodeType.wifi:
        _wifiNameController.clear();
        _wifiPasswordController.clear();
        break;
    }

    setState(() {
      _qrData = '';
      _hasGeneratedQR = false;
    });
  }

  Widget _buildInputFields() {
    switch (_qrCodeType) {
      case QrCodeType.text:
      case QrCodeType.url:
        return GlassmorphicContainer(
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
              controller: _textController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: _qrCodeType == QrCodeType.url
                    ? 'Enter URL (e.g., example.com)...'
                    : 'Type or paste content here...',
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
        );

      case QrCodeType.contact:
        return Column(
          children: [
            _buildTextField(
              controller: _nameController,
              hint: 'Full Name',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _emailController,
              hint: 'Email Address',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _phoneController,
              hint: 'Phone Number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
          ],
        );

      case QrCodeType.wifi:
        return Column(
          children: [
            _buildTextField(
              controller: _wifiNameController,
              hint: 'WiFi Network Name (SSID)',
              icon: Icons.wifi,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _wifiPasswordController,
              hint: 'Password',
              icon: Icons.lock_outline,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _wifiEncryption,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    items: ['WPA', 'WEP', 'None'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _wifiEncryption = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _wifiIsHidden,
                        onChanged: (value) {
                          setState(() {
                            _wifiIsHidden = value!;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const Text('Hidden Network'),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return GlassmorphicContainer(
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
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textLight),
            border: InputBorder.none,
            prefixIcon: Icon(icon, color: AppColors.primary),
          ),
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 16,
          ),
        ),
      ),
    );
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
            // Type selection
            Text(
              'QR Code Type',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _TypeSelector(
                    title: 'Text',
                    icon: Icons.text_fields_rounded,
                    isSelected: _qrCodeType == QrCodeType.text,
                    onTap: () => setState(() {
                      _qrCodeType = QrCodeType.text;
                      _hasGeneratedQR = false;
                    }),
                  ),
                  const SizedBox(width: 12),
                  _TypeSelector(
                    title: 'URL',
                    icon: Icons.link_rounded,
                    isSelected: _qrCodeType == QrCodeType.url,
                    onTap: () => setState(() {
                      _qrCodeType = QrCodeType.url;
                      _hasGeneratedQR = false;
                    }),
                  ),
                  const SizedBox(width: 12),
                  _TypeSelector(
                    title: 'Contact',
                    icon: Icons.contact_page_rounded,
                    isSelected: _qrCodeType == QrCodeType.contact,
                    onTap: () => setState(() {
                      _qrCodeType = QrCodeType.contact;
                      _hasGeneratedQR = false;
                    }),
                  ),
                  const SizedBox(width: 12),
                  _TypeSelector(
                    title: 'WiFi',
                    icon: Icons.wifi_rounded,
                    isSelected: _qrCodeType == QrCodeType.wifi,
                    onTap: () => setState(() {
                      _qrCodeType = QrCodeType.wifi;
                      _hasGeneratedQR = false;
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Input fields based on selected type
            _buildInputFields(),

            const SizedBox(height: 24),

            // Options
            if (_hasGeneratedQR) ...[
              Text(
                'Options',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'QR Color',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMedium,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _ColorSelector(
                              color: Colors.black,
                              isSelected: _qrColor == Colors.black,
                              onTap: () =>
                                  setState(() => _qrColor = Colors.black),
                            ),
                            const SizedBox(width: 8),
                            _ColorSelector(
                              color: AppColors.primary,
                              isSelected: _qrColor == AppColors.primary,
                              onTap: () =>
                                  setState(() => _qrColor = AppColors.primary),
                            ),
                            const SizedBox(width: 8),
                            _ColorSelector(
                              color: AppColors.secondary,
                              isSelected: _qrColor == AppColors.secondary,
                              onTap: () => setState(
                                  () => _qrColor = AppColors.secondary),
                            ),
                            const SizedBox(width: 8),
                            _ColorSelector(
                              color: Colors.redAccent,
                              isSelected: _qrColor == Colors.redAccent,
                              onTap: () =>
                                  setState(() => _qrColor = Colors.redAccent),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Error Correction',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMedium,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<ErrorCorrectionLevel>(
                          value: _errorCorrectLevel,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          items: ErrorCorrectionLevel.values.map((level) {
                            return DropdownMenuItem<ErrorCorrectionLevel>(
                              value: level,
                              child: Text(level.displayName),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _errorCorrectLevel = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // Generate button
            Center(
              child: ElevatedButton(
                onPressed: _generateQrCode,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  backgroundColor: AppColors.primary,
                ),
                child: const Text(
                  'Generate QR Code',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // QR code display with animation
            if (_hasGeneratedQR)
              Center(
                child: AnimatedOpacity(
                  opacity: _hasGeneratedQR ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: GlassmorphicContainer(
                    width: 240,
                    height: 240,
                    borderRadius: 20,
                    blur: 5,
                    alignment: Alignment.center,
                    border: 1,
                    linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.8),
                        Colors.white.withOpacity(0.6),
                      ],
                    ),
                    borderGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withOpacity(0.3),
                        AppColors.secondary.withOpacity(0.3),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: QrImageView(
                        data: _qrData,
                        version: QrVersions.auto,
                        size: 200,
                        backgroundColor: Colors.white,
                        foregroundColor: _qrColor,
                        errorCorrectionLevel: _errorCorrectLevel.value,
                        errorStateBuilder: (context, error) {
                          return const Center(
                            child: Text(
                              'Something went wrong!',
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// QR Type selector widget
class _TypeSelector extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeSelector({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textDark,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Color selector for QR code
class _ColorSelector extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorSelector({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isSelected
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              )
            : null,
      ),
    );
  }
}
