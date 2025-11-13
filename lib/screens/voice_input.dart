import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceInputScreen extends StatefulWidget {
  const VoiceInputScreen({super.key});

  @override
  State<VoiceInputScreen> createState() => _VoiceInputScreenState();
}

class _VoiceInputScreenState extends State<VoiceInputScreen> {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;

  bool _isListening = false;
  String _transcribedText = '';
  String _statusMessage = 'Tap the microphone to describe the cattle health';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission is required')),
      );
    }
  }

  Future<void> _startListening() async {
    await _requestMicrophonePermission();
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() {
            _isListening = false;
            _statusMessage = 'Tap the microphone to describe the cattle health';
          });
        }
      },
      onError: (error) {
        setState(() {
          _statusMessage = 'Error: ${error.errorMsg}';
          _isListening = false;
        });
      },
    );

    if (available) {
      setState(() {
        _isListening = true;
        _statusMessage = 'Listening...';
      });
      _speech.listen(
        onResult: (result) {
          setState(() {
            _transcribedText = result.recognizedWords;
          });
        },
        localeId: 'en_IN',
      );
    } else {
      setState(() {
        _statusMessage = 'Speech recognition not available';
        _isListening = false;
      });
    }
  }

  Future<void> _stopListening() async {
    if (!_isListening) return;
    await _speech.stop();
    setState(() {
      _isListening = false;
      _statusMessage = 'Tap the microphone to describe the cattle health';
    });
  }

  Future<void> _saveDescription() async {
    if (_transcribedText.isEmpty) return;

    // TODO: Replace with actual save logic (API / local DB)
    print('Cattle Health Description Saved: $_transcribedText');

    // TTS feedback
    await _flutterTts.speak('Description saved successfully');

    setState(() {
      _transcribedText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Describe Cattle Health'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Status message
            Text(_statusMessage, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            // Live transcription area
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _transcribedText.isEmpty
                        ? 'Your description will appear here...'
                        : _transcribedText,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Stop Recording button (visible only while listening)
            if (_isListening)
              ElevatedButton.icon(
                onPressed: _stopListening,
                icon: const Icon(Icons.stop),
                label: const Text('Stop Recording'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            const SizedBox(height: 10),

            // Microphone & Save buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Mic button
                FloatingActionButton(
                  onPressed: _isListening ? _stopListening : _startListening,
                  backgroundColor: _isListening ? Colors.red : Colors.blue,
                  child: Icon(_isListening ? Icons.mic_off : Icons.mic),
                ),
                const SizedBox(width: 30),
                // Save button
                ElevatedButton(
                  onPressed: _transcribedText.isEmpty ? null : _saveDescription,
                  child: const Text('Save Description'),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
