import 'dart:convert';
import 'package:chikitsa/screens/image_upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/language_service.dart';
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
  bool _isImageUploaded = false;
  String _selectedGender = 'Male';

  @override
  void initState() {
    super.initState();
    _loadPatientProfile();
  }

  /// Load saved patient details from SharedPreferences
  Future<void> _loadPatientProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _patientIdController.text = prefs.getString('patient_id') ?? '';
      _patientNameController.text = prefs.getString('patient_name') ?? '';
      _patientAgeController.text = prefs.getString('patient_age') ?? '';
      _selectedGender = prefs.getString('patient_gender') ?? 'Male';
      _phoneController.text = prefs.getString('patient_phone') ?? '';
    });
  }

  /// Save patient details to SharedPreferences for auto-fill
  Future<void> _savePatientProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('patient_id', _patientIdController.text.trim());
    await prefs.setString('patient_name', _patientNameController.text.trim());
    await prefs.setString('patient_age', _patientAgeController.text.trim());
    await prefs.setString('patient_gender', _selectedGender);
    await prefs.setString('patient_phone', _phoneController.text.trim());
  }

  /// Save an assessment to history for the Activity History screen
  Future<void> _saveAssessmentToHistory(
      Map<String, dynamic> patientData, bool sendSuccess) async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString('assessment_history');

    List<dynamic> history = [];
    if (historyJson != null) {
      history = jsonDecode(historyJson);
    }

    // Add send status to the data
    final assessmentRecord = Map<String, dynamic>.from(patientData);
    assessmentRecord['send_success'] = sendSuccess;

    history.add(assessmentRecord);

    // Keep only the last 50 assessments
    if (history.length > 50) {
      history = history.sublist(history.length - 50);
    }

    await prefs.setString('assessment_history', jsonEncode(history));
  }

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

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    if (!RegExp(r'^\+?[0-9]{10,13}$').hasMatch(value)) {
      return 'Enter a valid phone number (10-13 digits)';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'Name is required';
    if (value.length < 3) return 'Name is too short';
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name must contain only alphabets';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) return null; // Age is optional
    final age = int.tryParse(value);
    if (age == null || age < 0 || age > 120) {
      return 'Enter a valid age (0-120)';
    }
    return null;
  }

  Future<void> _sendData() async {
    // strict validation
    if (!_isImageUploaded) {
      _showError(LanguageService.current.get('ERR_PHOTO_REQ'));
      return;
    }

    final phoneError = _validatePhone(_phoneController.text);
    if (phoneError != null) {
      _showError(phoneError);
      return;
    }

    final nameError = _validateName(_patientNameController.text);
    if (nameError != null) {
      _showError(nameError);
      return;
    }

    final ageError = _validateAge(_patientAgeController.text);
    if (ageError != null) {
      _showError(ageError);
      return;
    }

    if (_symptomsController.text.isEmpty) {
      _showError('Please enter at least one symptom');
      return;
    }

    // Vitals validation (Simple range checks)
    if (_temperatureController.text.isNotEmpty) {
      final temp = double.tryParse(_temperatureController.text);
      if (temp == null || temp < 30 || temp > 45) {
        _showError('Temperature must be between 30°C and 45°C');
        return;
      }
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

    // Save patient profile for auto-fill on next visit
    if (result.success) {
      await _savePatientProfile();
    }

    // Save assessment to history (regardless of success/failure)
    await _saveAssessmentToHistory(patientData, result.success);

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
    final lang = LanguageService.current;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(lang.get('TITLE_ASSESSMENT')),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _sendData,
        backgroundColor: theme.colorScheme.onSurface,
        foregroundColor: theme.colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        label: _isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child:
                    CircularProgressIndicator(color: theme.colorScheme.surface),
              )
            : Text(lang.get('BTN_SUBMIT').toUpperCase(),
                style: const TextStyle(
                    fontWeight: FontWeight.w900, letterSpacing: 1.0)),
        icon: _isLoading ? null : const Icon(Icons.arrow_forward),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient Details Section
              Text(
                lang.get('SECTION_PATIENT'),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),

              _buildTextField(
                controller: _patientNameController,
                label: lang.get('LABEL_NAME'),
                hint: lang.get('HINT_NAME'),
                simulationText: "अमन",
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
                ],
              ),
              const SizedBox(height: 24),

              _buildTextField(
                controller: _phoneController,
                label: lang.get('LABEL_PHONE'),
                hint: lang.get('HINT_PHONE'),
                keyboardType: TextInputType.phone,
                simulationText: "९८७६५४३२१०",
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                  LengthLimitingTextInputFormatter(15)
                ],
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _patientAgeController,
                      label: lang.get('LABEL_AGE'),
                      hint: lang.get('HINT_AGE'),
                      simulationText: "२५",
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildGenderDropdown(),
                  ),
                ],
              ),

              const SizedBox(height: 48),

              // Vitals Section
              Text(
                lang.get('SECTION_VITALS'),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),

              _buildTextField(
                controller: _symptomsController,
                label: lang.get('LABEL_SYMPTOMS'),
                hint: lang.get('HINT_SYMPTOMS'),
                maxLines: 3,
                simulationText: lang.get('SIM_SYMPTOMS'),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _bpController,
                      label: lang.get('LABEL_BP'),
                      hint: lang.get('HINT_BP'),
                      simulationText: lang.get('SIM_BP'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _temperatureController,
                      label: lang.get('LABEL_TEMP'),
                      hint: lang.get('HINT_TEMP'),
                      keyboardType: TextInputType.number,
                      simulationText: lang.get('SIM_TEMP'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildTextField(
                controller: _heartRateController,
                label: 'Heart Rate', // TODO: Add key
                hint: 'BPM',
                keyboardType: TextInputType.number,
                simulationText: "७२",
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3)
                ],
              ),

              const SizedBox(height: 32),

              // Mandatory Image Upload Section
              Text(
                lang.get('HEADER_PHOTO'),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: () async {
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ImageUploadScreen()),
                  );

                  if (result == true) {
                    setState(() {
                      _isImageUploaded = true;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _isImageUploaded
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.surface,
                    border: Border.all(
                        color: theme.colorScheme.onSurface, width: 2),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _isImageUploaded
                            ? Icons.check_circle
                            : Icons.upload_file,
                        size: 40,
                        color: _isImageUploaded
                            ? theme.colorScheme.surface
                            : theme.colorScheme.onSurface,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _isImageUploaded
                            ? lang.get('STATUS_ATTACHED')
                            : lang.get('BTN_UPLOAD'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: _isImageUploaded
                              ? theme.colorScheme.surface
                              : theme.colorScheme.onSurface,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isImageUploaded
                            ? lang.get('STATUS_READY')
                            : lang.get('STATUS_MANDATORY'),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _isImageUploaded
                              ? theme.colorScheme.surface.withValues(alpha: 0.7)
                              : theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 80), // Space for FAB

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
    required String simulationText,
    TextInputType? keyboardType,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: Theme.of(context).textTheme.bodyLarge,
          keyboardType: keyboardType,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: VoiceInputButton(
              simulationText: simulationText,
              onTextReceived: (englishText) {
                if (label.contains('Symptoms') && controller.text.isNotEmpty) {
                  controller.text = "${controller.text}, $englishText";
                } else {
                  controller.text = englishText;
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    final lang = LanguageService.current;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lang.get('LABEL_GENDER'),
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _selectedGender,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: theme.textTheme.bodyLarge,
          icon: Icon(Icons.arrow_drop_down, color: theme.iconTheme.color),
          dropdownColor: theme.cardColor,
          items: [
            DropdownMenuItem(value: 'Male', child: Text(lang.get('OPT_MALE'))),
            DropdownMenuItem(
                value: 'Female', child: Text(lang.get('OPT_FEMALE'))),
            DropdownMenuItem(
                value: 'Other', child: Text(lang.get('OPT_OTHER'))),
          ],
          onChanged: (String? newValue) {
            setState(() {
              _selectedGender = newValue!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildResults(SmsSendResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transmission Results',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: result.success
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                border: Border.all(
                  color: result.success ? Colors.green : Colors.red,
                  width: 2,
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
                  const SizedBox(width: 8),
                  Text(
                    result.success ? 'SENT SUCCESSFULLY' : 'FAILED',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: result.success ? Colors.green : Colors.red,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (result.success)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  border: Border.all(color: Colors.orange, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.flash_on,
                        color: Colors.deepOrange, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'VIA ${result.compressionMethod.toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                        letterSpacing: 0.5,
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
                  'ORIGINAL',
                  '${result.originalJsonSize} B',
                  Colors.black,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'SENT',
                  '${result.bytesSentOverNetwork} B',
                  Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'SAVED',
                  '${result.bytesSaved} B',
                  Colors.black,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'RATIO',
                  '${result.compressionRatio}%',
                  Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            'HTTP STATUS',
            '${result.httpStatusCode} - ${_getStatusText(result.httpStatusCode).toUpperCase()}',
            Colors.black,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'COMPRESSED PAYLOAD',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 20),
                      color: Colors.black,
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: result.base64Payload));
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
                    color: Colors.black87,
                    fontFamily: 'monospace',
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '${result.base64Length} chars',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              border: Border.all(color: Colors.red, width: 2),
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
                      fontWeight: FontWeight.bold,
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

  Widget _buildStatCard(String label, String value, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
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
