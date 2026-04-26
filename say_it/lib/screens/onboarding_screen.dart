import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../config/app_strings.dart';
import '../providers/speech_provider.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/voice_input_widgets.dart';
import '../widgets/dialog_widgets.dart';
import 'profile_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final String language;

  const OnboardingScreen({required this.language});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<TextEditingController> _controllers =
      List.generate(5, (_) => TextEditingController());
  late SpeechProvider _speechProvider;
  late OnboardingProvider _onboardingProvider;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _speechProvider = context.read<SpeechProvider>();
    _onboardingProvider = context.read<OnboardingProvider>();
    _speechProvider.initializeSpeech();
    _speakQuestion();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _speechProvider.stopSpeaking();
    _speechProvider.stopListening();
    super.dispose();
  }

  void _speakQuestion() async {
    final step = _onboardingProvider.currentStep;
    final questionKey = _onboardingProvider.getQuestionKey(step);
    final question = AppStrings.getString(questionKey, widget.language);
    await Future.delayed(const Duration(milliseconds: 500));
    _speechProvider.speak(question, widget.language);
  }

  void _onMicPress() async {
    final speechProvider = context.read<SpeechProvider>();
    final onboardingProvider = context.read<OnboardingProvider>();

    if (speechProvider.isListening) {
      await speechProvider.stopListening();
      final text = speechProvider.recognizedText;
      _controllers[onboardingProvider.currentStep].text = text;
      onboardingProvider.setAnswer(onboardingProvider.currentStep, text);
    } else {
      await speechProvider.startListening(widget.language);
    }
  }

  void _handleNext() async {
    final onboardingProvider = context.read<OnboardingProvider>();
    final currentAnswer =
        _controllers[onboardingProvider.currentStep].text.trim();

    if (currentAnswer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please provide an answer',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    onboardingProvider.setAnswer(onboardingProvider.currentStep, currentAnswer);

    if (onboardingProvider.currentStep < onboardingProvider.totalSteps - 1) {
      await onboardingProvider.nextStep();
      _speakQuestion();
    } else {
      _showSubmitDialog();
    }
  }

  void _showSubmitDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: AppColors.gradientSuccess,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 16),
              Text(
                'Ready to Submit?',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your responses will be saved',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.grey600,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.grey200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitAnswers,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Submit',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitAnswers() async {
    Navigator.pop(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => LoadingDialog(message: 'Saving your responses...'),
    );

    try {
      final onboardingProvider = context.read<OnboardingProvider>();
      await onboardingProvider.submitAnswers(widget.language);

      if (mounted) {
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ProfileScreen(language: widget.language),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _handlePrevious() async {
    final onboardingProvider = context.read<OnboardingProvider>();
    if (onboardingProvider.currentStep > 0) {
      await onboardingProvider.previousStep();
      _speakQuestion();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withOpacity(0.05),
                  AppColors.secondary.withOpacity(0.03),
                ],
              ),
            ),
            child: Consumer2<OnboardingProvider, SpeechProvider>(
              builder: (context, onboardingProvider, speechProvider, _) {
                final currentStep = onboardingProvider.currentStep;
                final questionKey =
                    onboardingProvider.getQuestionKey(currentStep);
                final question =
                    AppStrings.getString(questionKey, widget.language);

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${AppStrings.getString('step', widget.language)} ${currentStep + 1}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                '${AppStrings.getString('of', widget.language)} ${onboardingProvider.totalSteps}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: AppColors.grey600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: (currentStep + 1) /
                                  onboardingProvider.totalSteps,
                              minHeight: 6,
                              backgroundColor: AppColors.grey200,
                              valueColor: AlwaysStoppedAnimation(
                                AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            question,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.grey900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            VoiceIndicator(
                              isListening: speechProvider.isListening,
                              soundLevel: speechProvider.soundLevel,
                            ),
                            const SizedBox(height: 32),
                            AnimatedVoiceButton(
                              isListening: speechProvider.isListening,
                              onPressed: _onMicPress,
                              soundLevel: speechProvider.soundLevel,
                            ),
                            const SizedBox(height: 32),
                            CustomTextField(
                              controller: _controllers[currentStep],
                              label: 'Your Response',
                              hint: 'Tap mic or type here',
                              readOnly: _isEditMode ? false : false,
                            ),
                            if (speechProvider.lastError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.error.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    speechProvider.lastError!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: AppColors.error,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          if (currentStep > 0)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _handlePrevious,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.grey200,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: Text(
                                  AppStrings.getString(
                                      'previousButton', widget.language),
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.grey800,
                                  ),
                                ),
                              ),
                            ),
                          if (currentStep > 0) const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _handleNext,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: Text(
                                currentStep ==
                                        onboardingProvider.totalSteps - 1
                                    ? AppStrings.getString(
                                        'submitButton', widget.language)
                                    : AppStrings.getString(
                                        'nextButton', widget.language),
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}