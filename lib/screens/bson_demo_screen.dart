import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/sms_service.dart';

class BsonDemoScreen extends StatefulWidget {
  const BsonDemoScreen({super.key});

  @override
  State<BsonDemoScreen> createState() => _BsonDemoScreenState();
}

class _BsonDemoScreenState extends State<BsonDemoScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();
  SmsSendResult? _lastResult;
  bool _isLoading = false;
  
  Map<String, dynamic> _getSampleData() {
    List<String> symptoms = ['fever', 'cough', 'fatigue'];
    
    if (_symptomsController.text.trim().isNotEmpty) {
      symptoms.add(_symptomsController.text.trim());
    }
    
    return {
      'patient_id': 'P12345',
      'symptoms': symptoms,
      'temperature': 38.5,
      'blood_pressure': '120/80',
      'heart_rate': 78,
      'timestamp': DateTime.now().toIso8601String(),
      'location': {'lat': 28.6139, 'lng': 77.2090},
      'medicines': [
        {'name': 'Paracetamol', 'dosage': '500mg', 'frequency': '3x daily'},
        {'name': 'Azithromycin', 'dosage': '250mg', 'frequency': '1x daily'},
      ],
    };
  }

  Future<void> _sendData() async {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a phone number')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final sampleData = _getSampleData();
    
    final result = await SmsService.sendWithBestCompression(
      phoneNumber: _phoneController.text,
      data: sampleData,
    );

    setState(() {
      _lastResult = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Smart 2G Transmission'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ultra-Low Bandwidth Data Transfer',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Auto-selects best compression for 2G networks',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: .6),
                ),
              ),
              
              const SizedBox(height: 32),
              
              TextField(
                controller: _phoneController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: Colors.white.withValues(alpha: .6)),
                  hintText: '+91 9876543210',
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: .3)),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: .05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: .2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: .2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE8997F)),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              TextField(
                controller: _symptomsController,
                style: const TextStyle(color: Colors.white),
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Additional Symptoms (Optional)',
                  labelStyle: TextStyle(color: Colors.white.withValues(alpha: .6)),
                  hintText: 'Describe any additional symptoms...\ne.g., headache, body ache, difficulty breathing',
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha:.3)),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: .05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha:0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: .2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE8997F)),
                  ),
                  alignLabelWithHint: true,
                ),
              ),
              
              const SizedBox(height: 24),
              
              _buildDataPreview(),
              
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE8997F),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                          'Compress & Prepare for Transmission',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              if (_lastResult != null) _buildResults(_lastResult!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataPreview() {
    final previewData = _getSampleData();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: .1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.medical_information, color: Color(0xFFE8997F), size: 20),
              SizedBox(width: 8),
              Text(
                'Medical Data Preview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '• Patient ID: ${previewData['patient_id']}\n'
            '• Symptoms: ${(previewData['symptoms'] as List).join(', ')}\n'
            '• Temperature: ${previewData['temperature']}°C\n'
            '• BP: ${previewData['blood_pressure']}\n'
            '• Heart Rate: ${previewData['heart_rate']} bpm\n'
            '• Medicines: ${(previewData['medicines'] as List).length} prescribed',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha:0.7),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(SmsSendResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transmission Results',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE8997F).withValues(alpha: .2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE8997F)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFFE8997F), size: 16),
              const SizedBox(width: 6),
              Text(
                'Using ${result.compressionMethod}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE8997F),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'JSON Size',
                '${result.originalJsonSize} bytes',
                Colors.red.withValues(alpha:0.2),
                Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Compressed',
                '${result.dataSentBytes} bytes',
                Colors.green.withValues(alpha:0.2),
                Colors.green,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Saved',
                '${result.bytesSaved} bytes',
                const Color(0xFFE8997F).withValues(alpha:0.2),
                const Color(0xFFE8997F),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Compression',
                '${result.compressionRatio}%',
                Colors.blue.withValues(alpha:0.2),
                Colors.blue,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha:0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha:0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Encoded Payload (Base64)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    color: const Color(0xFFE8997F),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: result.base64Payload));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                result.base64Payload,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha:0.6),
                  fontFamily: 'monospace',
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                '${result.base64Length} characters for SMS transmission',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha:0.5),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withValues(alpha:0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha:0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
