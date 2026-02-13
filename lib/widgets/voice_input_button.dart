import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceInputButton extends StatefulWidget {
  final Function(String result) onTextReceived;

  const VoiceInputButton({super.key, required this.onTextReceived});

  @override
  State<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends State<VoiceInputButton> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isTranslating = false;

  final _onDeviceTranslator = OnDeviceTranslator(
    sourceLanguage: TranslateLanguage.hindi,
    targetLanguage: TranslateLanguage.english,
  );

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _toggleListening() async {
    await _simulateVoiceInput("नमस्ते"); 
    return;

    // if (_isListening) {
    //   await _speech.stop();
    //   setState(() => _isListening = false);
    //   return;
    // }

    // var status = await Permission.microphone.request();
    // if (!status.isGranted) {
    //   print("Permission denied");
    //   return;
    // }

    // bool available = await _speech.initialize(
    //   onError: (val) {
    //     print('Speech Error: ${val.errorMsg}');
    //     setState(() => _isListening = false);
    //   },
    //   onStatus: (val) => print('Speech Status: $val'),
    // );

    // if (available) {
    //   var locales = await _speech.locales();
    //   var hasHindi = locales.any((l) => l.localeId == 'hi_IN');
    //   print("Device supports Hindi: $hasHindi");
    //   if (!hasHindi) {
    //     print("Available Locales: ${locales.map((l) => l.localeId).join(', ')}");
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Hindi language pack missing on this device')),
    //     );
    //   }

    //   setState(() => _isListening = true);
      
    //   _speech.listen(
    //     localeId: 'hi_IN',
    //     listenFor: const Duration(seconds: 30),
    //     pauseFor: const Duration(seconds: 5),
    //     partialResults: true, // IMPORTANT: Get results as you speak
    //     onResult: (val) async {
    //       print("Heard: ${val.recognizedWords}"); // You should see this log now

    //       if (val.finalResult) {
    //         setState(() {
    //           _isListening = false;
    //           _isTranslating = true;
    //         });

    //         try {
    //           if (val.recognizedWords.isNotEmpty) {
    //             final String translation = 
    //                 await _onDeviceTranslator.translateText(val.recognizedWords);
    //             print("Translated: $translation");
    //             widget.onTextReceived(translation);
    //           }
    //         } catch (e) {
    //           print("Translation Error: $e");
    //         }
            
    //         if(mounted) setState(() => _isTranslating = false);
    //       }
    //     },
    //   );
    // } else {
    //   print("Speech initialization failed.");
    // }
  }

  Future<void> _simulateVoiceInput(String mockHindiText) async {
    setState(() => _isListening = true);
    await Future.delayed(const Duration(milliseconds: 500)); 
    setState(() {
      _isListening = false;
      _isTranslating = true;
    });

    try {
      final String translation = await _onDeviceTranslator.translateText(mockHindiText);
      print("DEBUG TRANSLATION: $mockHindiText -> $translation");
      widget.onTextReceived(translation);
    } catch (e) {
      print("Translation Error: $e");
    }

    if (mounted) setState(() => _isTranslating = false);
  }

  @override
  void dispose() {
    _onDeviceTranslator.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _isTranslating
          ? const SizedBox(
              width: 24, 
              height: 24, 
              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFE8997F))
            )
          : Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: _isListening ? Colors.red : const Color(0xFFE8997F),
            ),
      onPressed: _toggleListening,
    );
  }
}