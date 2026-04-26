import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
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
    await _flutterTts.setLanguage('en_US');
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
  }

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
        _lastError = 'Speech recognition not available';
      }
    } catch (e) {
      _lastError = e.toString();
    }
    notifyListeners();
  }

  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> startListening(String languageCode) async {
    if (!_isInitialized) {
      await initializeSpeech();
    }

    final permissionStatus = await Permission.microphone.status;
    if (!permissionStatus.isGranted) {
      final granted = await requestMicrophonePermission();
      if (!granted) {
        _lastError = 'Microphone permission denied';
        notifyListeners();
        return;
      }
    }

    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
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
      } else {
        _lastError = 'Could not initialize speech recognition';
      }
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
        return 'hi_IN';
      case 'te':
        return 'te_IN';
      default:
        return 'en_US';
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