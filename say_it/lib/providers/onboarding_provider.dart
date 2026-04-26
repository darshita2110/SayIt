import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/onboarding_data.dart';

class OnboardingProvider with ChangeNotifier {
  int _currentStep = 0;
  final Map<int, String> _answers = {};
  OnboardingData? _currentData;
  bool _isSubmitting = false;

  int get currentStep => _currentStep;
  Map<int, String> get answers => _answers;
  OnboardingData? get currentData => _currentData;
  bool get isSubmitting => _isSubmitting;
  int get totalSteps => 5;

  final List<String> _questionKeys = [
    'question1',
    'question2',
    'question3',
    'question4',
    'question5',
  ];

  String getQuestionKey(int step) {
    return _questionKeys[step];
  }

  void setAnswer(int step, String answer) {
    _answers[step] = answer;
    notifyListeners();
  }

  String getAnswer(int step) {
    return _answers[step] ?? '';
  }

  Future<void> nextStep() async {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  Future<void> previousStep() async {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  Future<void> submitAnswers(String language) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      const uuid = Uuid();
      final data = OnboardingData(
        id: uuid.v4(),
        name: _answers[0] ?? '',
        skills: _answers[1] ?? '',
        experience: _answers[2] ?? '',
        motivation: _answers[3] ?? '',
        comments: _answers[4] ?? '',
        createdAt: DateTime.now(),
        language: language,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('onboarding_data', _encodeData(data.toMap()));

      _currentData = data;
      _isSubmitting = false;
      notifyListeners();
    } catch (e) {
      _isSubmitting = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataStr = prefs.getString('onboarding_data');
      if (dataStr != null) {
        _currentData = OnboardingData.fromMap(_decodeData(dataStr));
        notifyListeners();
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  void reset() {
    _currentStep = 0;
    _answers.clear();
    notifyListeners();
  }

  String _encodeData(Map<String, dynamic> data) {
    return data.toString();
  }

  Map<String, dynamic> _decodeData(String encoded) {
    return {};
  }
}