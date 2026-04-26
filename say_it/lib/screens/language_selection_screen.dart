import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../config/app_strings.dart';
import '../providers/language_provider.dart';
import 'onboarding_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? _selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary.withOpacity(0.1),
                AppColors.secondary.withOpacity(0.05),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.language,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Select Language',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.grey900,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Choose your preferred language to continue',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.grey600,
                  ),
                ),
                const SizedBox(height: 48),
                ..._buildLanguageOptions(),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _selectedLanguage != null
                        ? () => _continueWithLanguage(context)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.grey300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Continue',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _selectedLanguage != null
                            ? Colors.white
                            : AppColors.grey500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLanguageOptions() {
    final languages = ['en', 'hi', 'te'];
    final languageNames = ['English', 'हिंदी', 'తెలుగు'];

    return languages.asMap().entries.map((entry) {
      int idx = entry.key;
      String code = entry.value;
      String name = languageNames[idx];

      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedLanguage = code;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: _selectedLanguage == code
                    ? AppColors.primary
                    : AppColors.grey300,
                width: _selectedLanguage == code ? 2.5 : 1.5,
              ),
              borderRadius: BorderRadius.circular(14),
              color: _selectedLanguage == code
                  ? AppColors.primary.withOpacity(0.05)
                  : Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: _selectedLanguage == code
                        ? AppColors.gradientPrimary
                        : LinearGradient(
                            colors: [
                              AppColors.grey200,
                              AppColors.grey300,
                            ],
                          ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: _selectedLanguage == code
                        ? Colors.white
                        : Colors.transparent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.grey900,
                        ),
                      ),
                      Text(
                        'Select to continue',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  void _continueWithLanguage(BuildContext context) {
    if (_selectedLanguage != null) {
      context.read<LanguageProvider>().setLanguage(_selectedLanguage!);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => OnboardingScreen(language: _selectedLanguage!),
        ),
      );
    }
  }
}