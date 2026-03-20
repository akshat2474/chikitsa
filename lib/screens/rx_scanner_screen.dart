import 'package:chikitsa/screens/image_upload_screen.dart';
import 'package:chikitsa/services/language_service.dart';
import 'package:flutter/material.dart';

class RxScannerScreen extends StatefulWidget {
  const RxScannerScreen({super.key});

  @override
  State<RxScannerScreen> createState() => _RxScannerScreenState();
}

class _RxScannerScreenState extends State<RxScannerScreen> {
  bool _isVerifying = false;
  bool _isVerified = false;

  Future<void> _handleScan() async {
    // Navigate to Image Upload Screen to simulate scanning
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ImageUploadScreen()),
    );

    // If result is true (simulated success from ImageUploadScreen)
    if (result == true) {
      setState(() {
        _isVerifying = true;
      });

      // Simulate verification delay
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        setState(() {
          _isVerifying = false;
          _isVerified = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = LanguageService.current;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.get('RX_TITLE')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_isVerifying && !_isVerified) ...[
              const Spacer(),
              Icon(
                Icons.qr_code_scanner,
                size: 120,
                color: theme.colorScheme.onSurface,
              ),
              const SizedBox(height: 32),
              Text(
                lang.get('RX_INSTRUCTION'),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              const Spacer(),
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _handleScan,
                  icon: const Icon(Icons.camera_alt),
                  label: Text(lang.get('RX_BTN_SCAN')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.onSurface,
                    foregroundColor: theme.colorScheme.surface,
                    shape: const RoundedRectangleBorder(), // Brutalist square
                  ),
                ),
              ),
            ] else if (_isVerifying) ...[
              const Spacer(),
              const Center(
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(height: 24),
              Text(
                lang.get('RX_VERIFYING'),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              const Spacer(),
            ] else if (_isVerified) ...[
              _buildResultCard(theme),
              const Spacer(),
              SizedBox(
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _isVerified = false;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.onSurface,
                    side: BorderSide(
                        color: theme.colorScheme.onSurface, width: 2),
                    shape: const RoundedRectangleBorder(),
                  ),
                  child: Text(lang.get('RX_BTN_SCAN_AGAIN')),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.green, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.verified, color: Colors.green, size: 64),
          const SizedBox(height: 16),
          Text(
            'AUTHENTIC SOURCE',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const Divider(height: 32, thickness: 1),
          _buildDetailRow('Product', 'Dolo-650 (Paracetamol)'),
          _buildDetailRow('Manufacturer', 'Micro Labs Ltd.'),
          _buildDetailRow('Batch No', 'M-29384'),
          _buildDetailRow('Expiry', 'DEC 2026'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: Colors.green.withValues(alpha: 0.1),
            child: const Text(
              'Verified via GS1 DataMatrix',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.w600)),
          Text(value,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
