import 'package:flutter/material.dart';
import 'package:luggo/utils/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? togglePasswordVisibility;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.togglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: TextField(
          controller: controller,
          obscureText: isPassword ? !isPasswordVisible : false,
          style: const TextStyle(fontFamily: 'Helvetica'),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.primaryColor.withOpacity(0.6),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                padding: const EdgeInsets.all(6),
                child: Icon(icon, color: Colors.black, size: 20),
              ),
            ),
            suffixIcon:
                isPassword
                    ? IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.primaryColor.withOpacity(0.7),
                      ),
                      onPressed: togglePasswordVisibility,
                    )
                    : null,
          ),
        ),
      ),
    );
  }
}
