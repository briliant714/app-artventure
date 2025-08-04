import 'package:flutter/material.dart';
import 'widget/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final bool isLoading;
  
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.isLoading = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      height: 55, // Sedikit lebih tinggi untuk match dengan desain
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE8844E), // Warna oranye seperti di Image 2
          foregroundColor: Colors.white,
          elevation: 0, // Tanpa shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Border radius lebih besar
            side: isOutlined
                ? BorderSide(
                    color: AppTheme.accentColor.withOpacity(0.3),
                    width: 2,
                  )
                : BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          disabledBackgroundColor: const Color(0xFFE8844E).withOpacity(0.6),
          disabledForegroundColor: Colors.white.withOpacity(0.7),
        ),
        child: isLoading 
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2, // Lebih tipis agar lebih elegan
              ),
            )
          : Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
    );
  }
}