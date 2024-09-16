import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTexts extends StatefulWidget {
  const SpeechToTexts({super.key});

  @override
  State<SpeechToTexts> createState() => _SpeechToTextsState();
}

class _SpeechToTextsState extends State<SpeechToTexts> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnable = false;
  String _wordSpoken = "";
  String? _selectedLanguage;
  final List<String> _languages = ['en-US', 'hi-IN', 'ur-PK']; // List of language codes
  Timer? _timer; // Timer for automatic mic turn-off

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnable = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult, localeId: _selectedLanguage);
    setState(() {});
    _startTimer(); // Start the timer when the mic starts listening
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
    _timer?.cancel(); // Cancel the timer if listening is stopped
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordSpoken = result.recognizedWords;
    });
    if (result.recognizedWords.isNotEmpty) {
      _timer?.cancel(); // Cancel the timer if speech is detected
    }
  }

  // Timer that stops the microphone if no speech is detected
  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timers
    _timer = Timer(const Duration(seconds: 5), () {
      if (_speechToText.isListening) {
        _stopListening(); // Stop listening if no speech is detected
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No speech detected, microphone turned off')),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech to Text Multi-Language'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                _speechToText.isListening
                    ? "Listening..."
                    : _speechEnable
                    ? "Tap the microphone to start listening..."
                    : "Speech not available",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedLanguage,
              hint: const Text('Select Language'),
              items: _languages
                  .map((lang) => DropdownMenuItem(
                value: lang,
                child: Text(lang == 'en-US'
                    ? 'English'
                    : lang == 'hi-IN'
                    ? 'Hindi'
                    : 'Urdu'),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value;
                });
              },
              isExpanded: true,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  _wordSpoken,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechToText.isListening ? _stopListening : _startListening,
        tooltip: 'Listen',
        backgroundColor: Colors.amber,
        child: Icon(
          _speechToText.isListening ? Icons.mic_off : Icons.mic,
          color: Colors.white,
        ),
      ),
    );
  }
}
