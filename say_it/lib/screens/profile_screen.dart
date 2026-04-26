import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../config/app_strings.dart';
import '../providers/onboarding_provider.dart';
import 'language_selection_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String language;

  const ProfileScreen({required this.language});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OnboardingProvider>().loadSavedData();
  }

  void _restart() {
    context.read<OnboardingProvider>().reset();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => LanguageSelectionScreen()),
    );
  }

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
                AppColors.primary.withOpacity(0.05),
                AppColors.secondary.withOpacity(0.03),
              ],
            ),
          ),
          child: Consumer<OnboardingProvider>(
            builder: (context, provider, _) {
              final data = provider.currentData;

              if (data == null) {
                return Center(
                  child: Text(
                    'No data found',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: AppColors.grey600,
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: AppColors.gradientSuccess,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.success.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppStrings.getString(
                                'yourProfile', widget.language),
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppColors.grey900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your responses have been saved',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.grey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildProfileCard(
                      label: AppStrings.getString('name', widget.language),
                      value: data.name,
                    ),
                    const SizedBox(height: 16),
                    _buildProfileCard(
                      label: AppStrings.getString('skills', widget.language),
                      value: data.skills,
                    ),
                    const SizedBox(height: 16),
                    _buildProfileCard(
                      label: AppStrings.getString(
                          'experience', widget.language),
                      value: data.experience,
                    ),
                    const SizedBox(height: 16),
                    _buildProfileCard(
                      label: AppStrings.getString(
                          'motivation', widget.language),
                      value: data.motivation,
                    ),
                    const SizedBox(height: 16),
                    _buildProfileCard(
                      label: AppStrings.getString(
                          'comments', widget.language),
                      value: data.comments,
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.info.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.info,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Language: ${data.language.toUpperCase()}',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppColors.info,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _restart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          AppStrings.getString(
                              'restartButton', widget.language),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey200),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.grey600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value.isNotEmpty ? value : 'Not provided',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: value.isNotEmpty
                  ? AppColors.grey900
                  : AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }
}