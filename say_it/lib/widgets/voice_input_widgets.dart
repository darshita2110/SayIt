import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_colors.dart';

class AnimatedVoiceButton extends StatefulWidget {
  final bool isListening;
  final VoidCallback onPressed;
  final double soundLevel;

  const AnimatedVoiceButton({
    required this.isListening,
    required this.onPressed,
    required this.soundLevel,
  });

  @override
  State<AnimatedVoiceButton> createState() => _AnimatedVoiceButtonState();
}

class _AnimatedVoiceButtonState extends State<AnimatedVoiceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.15).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: widget.isListening ? _scaleAnimation : AlwaysStoppedAnimation(1.0),
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.gradientPrimary,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: widget.isListening ? 10 : 0,
              ),
            ],
          ),
          child: Icon(
            widget.isListening ? Icons.mic : Icons.mic_none,
            color: Colors.white,
            size: 50,
          ),
        ),
      ),
    );
  }
}

class VoiceIndicator extends StatelessWidget {
  final bool isListening;
  final double soundLevel;

  const VoiceIndicator({
    required this.isListening,
    required this.soundLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isListening)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: 4,
                  height: 30 + (soundLevel * 20 * (index + 1)),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(height: 16),
        Text(
          isListening ? 'Listening...' : 'Ready to listen',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: isListening ? AppColors.primary : AppColors.grey500,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool readOnly;
  final VoidCallback? onEdit;

  const CustomTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.readOnly = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.grey800,
              ),
            ),
            if (readOnly && onEdit != null)
              GestureDetector(
                onTap: onEdit,
                child: Text(
                  'Edit',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          maxLines: 3,
          minLines: 1,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.grey300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: readOnly ? AppColors.grey100 : Colors.white,
            contentPadding: const EdgeInsets.all(16),
          ),
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.grey800,
          ),
        ),
      ],
    );
  }
}