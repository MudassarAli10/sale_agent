import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech extends StatefulWidget {
  const TextToSpeech({super.key});

  @override
  State<TextToSpeech> createState() => _TextToSpeechState();
}

class _TextToSpeechState extends State<TextToSpeech> {
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
    var languages = await flutterTts.getLanguages;
    setState(() {
      _languages = languages;
      _selectedLanguage = _languages.isNotEmpty ? _languages.first as String : null;
    });
  }

  Future<void> _speak() async {
    if (_text.isNotEmpty) {
      await flutterTts.setLanguage(_selectedLanguage ?? 'en-US');
      await flutterTts.setVolume(volume);
      await flutterTts.setPitch(pitch);
      await flutterTts.setSpeechRate(rate);
      await flutterTts.speak(_text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text-to-Speech Multi-Language'),
        backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
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
                child: TextField(
                  onChanged: (value) => _text = value,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Enter text to speak',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
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
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButton<String>(
                    value: _selectedLanguage,
                    items: _languages
                        .map((lang) => DropdownMenuItem<String>(
                      value: lang as String,
                      child: Text(lang as String),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                    },
                    isExpanded: true,
                    elevation: 15
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _speak,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Speak'),
              ),
              const SizedBox(height: 20),
              _buildSliders(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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

  Widget _slider(String label, double value, ValueChanged<double> onChanged, double min, double max) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '$label: ${value.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Slider(
            value: value,
            onChanged: onChanged,
            min: min,
            max: max,
            activeColor: Colors.greenAccent,
            inactiveColor: Colors.greenAccent.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}
