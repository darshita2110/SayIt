import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class SpeechProvider with ChangeNotifier {
  late stt.SpeechToText _speechToText;
  late FlutterTts _flutterTts;
  
  bool _isListening = false;
  bool _isInitialized = false;
  String _recognizedText = '';
  double _soundLevel = 0.0;
  String? _lastError;
  String _currentLanguage = 'en';

  bool get isListening => _isListening;
  bool get isInitialized => _isInitialized;
  String get recognizedText => _recognizedText;
  double get soundLevel => _soundLevel;
  String? get lastError => _lastError;

  final Map<String, String> _languageMap = {
    'en': 'en_US',
    'hi': 'hi_IN',
    'te': 'te_IN',
  };

  SpeechProvider() {
    _speechToText = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _initializeTts();
  }

  void _initializeTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
  }

  /// Initializes speech recognition. The speech_to_text package
  /// handles microphone permission requests internally during initialize().
  Future<void> initializeSpeech() async {
    if (_isInitialized) return;

    try {
      bool available = await _speechToText.initialize(
        onError: (error) {
          _lastError = error.errorMsg;
          notifyListeners();
        },
        onStatus: (status) {
          print('Speech status: $status');
        },
      );

      if (available) {
        _isInitialized = true;
        _lastError = null;
      } else {
        _lastError = 'Speech recognition not available. Please grant microphone permission in Settings.';
      }
    } catch (e) {
      _lastError = e.toString();
    }
    notifyListeners();
  }

  /// Checks if microphone permission is available by attempting to initialize.
  Future<bool> requestMicrophonePermission() async {
    try {
      bool available = await _speechToText.initialize();
      return available;
    } catch (e) {
      return false;
    }
  }

  Future<void> startListening(String languageCode) async {
    if (!_isInitialized) {
      await initializeSpeech();
    }

    // If still not initialized after attempting (permission denied, etc.)
    if (!_isInitialized) {
      _lastError = 'Microphone permission denied. Please grant permission in Settings.';
      notifyListeners();
      return;
    }

    if (!_isListening) {
      _isListening = true;
      _recognizedText = '';
      _lastError = null;
      _currentLanguage = languageCode;

      _speechToText.listen(
        onResult: (result) {
          _recognizedText = result.recognizedWords;
          _soundLevel = result.confidence;
          notifyListeners();
        },
        localeId: _languageMap[languageCode] ?? 'en_US',
      );
    }
    notifyListeners();
  }

  Future<void> stopListening() async {
    if (_isListening) {
      _isListening = false;
      await _speechToText.stop();
      notifyListeners();
    }
  }

  Future<void> speak(String text, String languageCode) async {
    try {
      String locale = _getLocaleForLanguage(languageCode);
      await _flutterTts.setLanguage(locale);
      await _flutterTts.speak(text);
    } catch (e) {
      _lastError = 'Error speaking: $e';
      notifyListeners();
    }
  }

  String _getLocaleForLanguage(String languageCode) {
    switch (languageCode) {
      case 'hi':
        return 'hi-IN';
      case 'te':
        return 'te-IN';
      default:
        return 'en-US';
    }
  }

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }

  void clearError() {
    _lastError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _speechToText.stop();
    _flutterTts.stop();
    super.dispose();
  }
}