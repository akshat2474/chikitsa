import 'package:chikitsa/screens/image_upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/text_service.dart';
import '../widgets/voice_input_button.dart';

class BsonDemoScreen extends StatefulWidget {
  const BsonDemoScreen({super.key});

  @override
  State<BsonDemoScreen> createState() => _BsonDemoScreenState();
}

class _BsonDemoScreenState extends State<BsonDemoScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _patientIdController = TextEditingController();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _patientAgeController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _bpController = TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();
  
  SmsSendResult? _lastResult;
  bool _isLoading = false;
  String _selectedGender = 'Male';
  
  Map<String, dynamic> _getPatientData() {
    List<String> symptoms = [];
    
    if (_symptomsController.text.trim().isNotEmpty) {
      symptoms = _symptomsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    
    return {
      'patient_id': _patientIdController.text.trim().isNotEmpty 
          ? _patientIdController.text.trim() 
          : 'P${DateTime.now().millisecondsSinceEpoch}',
      'patient_name': _patientNameController.text.trim(),
      'age': _patientAgeController.text.trim().isNotEmpty 
          ? int.tryParse(_patientAgeController.text.trim()) ?? 0 
          : 0,
      'gender': _selectedGender,
      'phone': _phoneController.text.trim(),
      'symptoms': symptoms,
      'temperature': _temperatureController.text.trim().isNotEmpty 
          ? double.tryParse(_temperatureController.text.trim()) ?? 0.0 
          : 0.0,
      'blood_pressure': _bpController.text.trim(),
      'heart_rate': _heartRateController.text.trim().isNotEmpty 
          ? int.tryParse(_heartRateController.text.trim()) ?? 0 
          : 0,
      'timestamp': DateTime.now().toIso8601String(),
      'location': {'lat': 28.6139, 'lng': 77.2090}, 
    };
  }

  Future<void> _sendData() async {
    if (_phoneController.text.isEmpty) {
      _showError('Please enter phone number');
      return;
    }
    if (_patientNameController.text.isEmpty) {
      _showError('Please enter patient name');
      return;
    }
    if (_symptomsController.text.isEmpty) {
      _showError('Please enter at least one symptom');
      return;
    }

    setState(() => _isLoading = true);

    final patientData = _getPatientData();
    
    final result = await SmsService.sendWithBestCompression(
      phoneNumber: _phoneController.text,
      data: patientData,
    );

    setState(() {
      _lastResult = result;
      _isLoading = false;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: result.success ? Colors.green : Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
  
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Patient Data Transmission'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ImageUploadScreen()),
        );
      },
      backgroundColor: const Color(0xFFE8997F),
      foregroundColor: Colors.black,
      icon: const Icon(Icons.add_a_photo),
      label: const Text("Upload Image"),
    ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Patient Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Fill patient details for 2G transmission',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: .6),
                ),
              ),
              
              const SizedBox(height: 32),
              
              _buildTextField(
                controller: _patientIdController,
                label: 'Patient ID (Optional)',
                hint: 'Auto-generated if empty',
                icon: Icons.badge,
              ),
              
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _patientNameController,
                label: 'Patient Name *',
                hint: 'Enter full name',
                icon: Icons.person,
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _patientAgeController,
                      label: 'Age',
                      hint: 'Years',
                      icon: Icons.calendar_today,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildGenderDropdown(),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number *',
                hint: '+91 9876543210',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              
              const SizedBox(height: 24),
              
              const Text(
                'Medical Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _symptomsController,
                label: 'Symptoms *',
                hint: 'fever, cough, headache (comma-separated)',
                icon: Icons.medical_services,
                maxLines: 3,
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _temperatureController,
                      label: 'Temperature (°C)',
                      hint: '37.5',
                      icon: Icons.thermostat,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _heartRateController,
                      label: 'Heart Rate',
                      hint: '78 bpm',
                      icon: Icons.favorite,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _bpController,
                label: 'Blood Pressure',
                hint: '120/80',
                icon: Icons.monitor_heart,
              ),
              
              const SizedBox(height: 32),
              
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
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Send Patient Data',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withValues(alpha:0.6)),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withValues(alpha:0.3)),
        prefixIcon: Icon(icon, color: const Color(0xFFE8997F)),
        suffixIcon: VoiceInputButton(
          onTextReceived: (englishText) {
            if (label.contains('Symptoms') && controller.text.isNotEmpty) {
              controller.text = "${controller.text}, $englishText";
            } else {
              controller.text = englishText;
            }
          },
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha:0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha:0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha:0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8997F)),
        ),
        alignLabelWithHint: maxLines > 1,
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha:0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          isExpanded: true,
          dropdownColor: Colors.grey[900],
          style: const TextStyle(color: Colors.white),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFE8997F)),
          items: ['Male', 'Female', 'Other'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(
                    value == 'Male' ? Icons.male : 
                    value == 'Female' ? Icons.female : Icons.transgender,
                    color: const Color(0xFFE8997F),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(value),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedGender = newValue!;
            });
          },
        ),
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
        
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: result.success 
                    ? Colors.green.withValues(alpha:0.2)
                    : Colors.red.withValues(alpha:0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: result.success ? Colors.green : Colors.red,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    result.success ? Icons.check_circle : Icons.error,
                    color: result.success ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    result.success ? 'Sent Successfully' : 'Failed',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: result.success ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (result.success)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8997F).withValues(alpha:0.2),
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
          ],
        ),
        
        const SizedBox(height: 16),
        
        if (result.success) ...[
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Original',
                  '${result.originalJsonSize} bytes',
                  Colors.red.withValues(alpha:0.2),
                  Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Sent',
                  '${result.bytesSentOverNetwork} bytes',
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
          
          const SizedBox(height: 12),
          
          _buildStatCard(
            'HTTP Status',
            '${result.httpStatusCode} - ${_getStatusText(result.httpStatusCode)}',
            Colors.purple.withValues(alpha:0.2),
            Colors.purple,
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
                      'Compressed Payload',
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
                    fontSize: 11,
                    color: Colors.white.withValues(alpha:0.6),
                    fontFamily: 'monospace',
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '${result.base64Length} characters transmitted',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha:0.5),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withValues(alpha:0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    result.message,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
  
  String _getStatusText(int statusCode) {
    if (statusCode == 200) return 'OK';
    if (statusCode == 201) return 'Created';
    if (statusCode >= 400 && statusCode < 500) return 'Client Error';
    if (statusCode >= 500) return 'Server Error';
    return 'Unknown';
  }
}
