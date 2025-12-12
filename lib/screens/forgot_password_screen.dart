import 'package:flutter/material.dart';
import 'dart:ui';
import '../widgets/app_logo.dart';
import '../localization/app_localizations.dart';
import '../utils/snackbar_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF8F9FA),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Section
                  const AppLogoXLarge(useAnimatedLogo: true),
                  const SizedBox(height: 30),

                  // Title
                  Text(
                    AppLocalizations.of(context).forgotPassword,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context).forgotPasswordDescription,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Email Input
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                            width: 1.5,
                          ),
                        ),
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Color(0xFF1F2937)),
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context).email,
                            hintStyle: const TextStyle(
                              color: Color(0xFF9CA3AF),
                            ),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Color(0xFF6B7280),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Reset Password Button
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.fromBorderSide(
                            BorderSide(color: Color(0xFF2563EB), width: 1.5),
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: _handleResetPassword,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              child: Center(
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        AppLocalizations.of(
                                          context,
                                        ).resetPassword,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Back to Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context).rememberPassword,
                        style: const TextStyle(color: Color(0xFF6B7280)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          AppLocalizations.of(context).backToLogin,
                          style: const TextStyle(
                            color: Color(0xFF2563EB),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleResetPassword() async {
    // Validate email
    if (_emailController.text.trim().isEmpty) {
      _showErrorSnackBar(AppLocalizations.of(context).enterEmail);
      return;
    }

    if (!_isValidEmail(_emailController.text.trim())) {
      _showErrorSnackBar(AppLocalizations.of(context).enterValidEmail);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate password reset process
    await Future.delayed(const Duration(seconds: 2));

    // Show success message
    SnackbarUtils.showSuccess(
      context,
      title: 'Reset Link Sent',
      message: AppLocalizations.of(context).resetPasswordSent,
    );

    // Navigate back to login
    Navigator.pop(context);

    setState(() {
      _isLoading = false;
    });
  }

  bool _isValidEmail(String email) {
    // More robust email validation pattern
    // Allows: letters, numbers, dots, hyphens, underscores, plus signs
    // Domain: at least one dot, valid TLD (2-6 characters)
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    );
    return emailRegex.hasMatch(email.trim());
  }

  void _showErrorSnackBar(String message) {
    SnackbarUtils.showError(context, title: 'Error', message: message);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
