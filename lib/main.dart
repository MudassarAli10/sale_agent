import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterTts flutterTts = FlutterTts();
  String? _selectedLanguage;
  String _text = '';
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  List<dynamic> _languages = [];

  @override
  void initState() {
    super.initState();
    _loadLanguages();
  }

  Future<void> _loadLanguages() async {
    // Fetch available languages
    var languages = await flutterTts.getLanguages;
    setState(() {
      _languages = languages;
      // Ensure the first language is selected if available
      _selectedLanguage = _languages.isNotEmpty ? _languages.first as String : null;
    });
  }

  Future<void> _speak() async {
    if (_text.isNotEmpty) {
      // Set language, volume, pitch, and rate for the TTS
      await flutterTts.setLanguage(_selectedLanguage ?? 'en-US');
      await flutterTts.setVolume(volume);
      await flutterTts.setPitch(pitch);
      await flutterTts.setSpeechRate(rate);
      await flutterTts.speak(_text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Text-to-Speech Multi-Language'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                onChanged: (value) => _text = value,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Enter text to speak',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Language selection dropdown
              DropdownButton<String>(
                value: _selectedLanguage,
                items: _languages
                    .map((lang) => DropdownMenuItem<String>(
                  value: lang as String, // Cast dynamic type to String
                  child: Text(lang as String),
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
              ElevatedButton(
                onPressed: _speak,
                child: const Text('Speak'),
              ),
              _buildSliders(),
            ],
          ),
        ),
      ),
    );
  }

  // Function to create sliders for volume, pitch, and rate
  Widget _buildSliders() {
    return Column(
      children: [
        _slider('Volume', volume, (value) {
          setState(() {
            volume = value;
          });
        }, 0.0, 1.0),
        _slider('Pitch', pitch, (value) {
          setState(() {
            pitch = value;
          });
        }, 0.5, 2.0),
        _slider('Rate', rate, (value) {
          setState(() {
            rate = value;
          });
        }, 0.0, 1.0),
      ],
    );
  }

  // Slider UI builder
  Widget _slider(String label, double value, ValueChanged<double> onChanged, double min, double max) {
    return Column(
      children: [
        Text('$label: ${value.toStringAsFixed(2)}'),
        Slider(
          value: value,
          onChanged: onChanged,
          min: min,
          max: max,
        ),
      ],
    );
  }
}
