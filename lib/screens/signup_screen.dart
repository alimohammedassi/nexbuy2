import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import '../widgets/app_logo.dart';
import '../localization/app_localizations.dart';
import '../utils/snackbar_utils.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LiquidGlassSignupPage extends StatefulWidget {
  const LiquidGlassSignupPage({super.key});

  @override
  State<LiquidGlassSignupPage> createState() => _LiquidGlassSignupPageState();
}

class _LiquidGlassSignupPageState extends State<LiquidGlassSignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;
  StreamSubscription<AuthState>? _authStateSubscription;

  @override
  void initState() {
    super.initState();
    _listenToAuthState();
  }

  void _listenToAuthState() {
    final authService = AuthService();
    _authStateSubscription = authService.authStateChanges.listen((AuthState state) async {
      if (mounted) {
        if (state.session != null) {
          // User successfully signed in, initialize UserService
          final userService = UserService();
          final supabaseUser = authService.currentUser;
          if (supabaseUser != null) {
            await userService.setCurrentUserFromSupabase(supabaseUser);
          }
          
          // Navigate to home screen
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFF8F9FA),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Section
                  AppLogoXLarge(useAnimatedLogo: true),
                  const SizedBox(height: 30),

                  // Welcome Text
                  Text(
                    AppLocalizations.of(context).createAccount,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context).getStarted,
                    style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 40),

                  // Name Input
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color(0xFFE5E7EB),
                            width: 1.5,
                          ),
                        ),
                        child: TextField(
                          controller: _nameController,
                          style: TextStyle(color: Color(0xFF1F2937)),
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context).fullName,
                            hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Color(0xFF6B7280),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

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
                            color: Color(0xFFE5E7EB),
                            width: 1.5,
                          ),
                        ),
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Color(0xFF1F2937)),
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context).email,
                            hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Color(0xFF6B7280),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password Input
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color(0xFFE5E7EB),
                            width: 1.5,
                          ),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: TextStyle(color: Color(0xFF1F2937)),
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context).password,
                            hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Color(0xFF6B7280),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Color(0xFF6B7280),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password Input
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color(0xFFE5E7EB),
                            width: 1.5,
                          ),
                        ),
                        child: TextField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          style: TextStyle(color: Color(0xFF1F2937)),
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(
                              context,
                            ).confirmPassword,
                            hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Color(0xFF6B7280),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Color(0xFF6B7280),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Terms and Conditions Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreeToTerms = value ?? false;
                          });
                        },
                        activeColor: Color(0xFF2563EB),
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text:
                                '${AppLocalizations.of(context).agreeToTerms} ',
                            style: TextStyle(color: Color(0xFF6B7280)),
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(
                                  context,
                                ).termsAndConditions,
                                style: TextStyle(
                                  color: Color(0xFF2563EB),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: ' ${AppLocalizations.of(context).and} ',
                                style: TextStyle(color: Color(0xFF6B7280)),
                              ),
                              TextSpan(
                                text: AppLocalizations.of(
                                  context,
                                ).privacyPolicy,
                                style: TextStyle(
                                  color: Color(0xFF2563EB),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Sign Up Button
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color(0xFF2563EB).withOpacity(0.4),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF2563EB).withOpacity(0.5),
                              blurRadius: 30,
                              offset: Offset(0, 15),
                              spreadRadius: 2,
                            ),
                            BoxShadow(
                              color: Color(0xFF2563EB).withOpacity(0.2),
                              blurRadius: 15,
                              offset: Offset(0, 8),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: _handleSignUp,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              child: Center(
                                child: _isLoading
                                    ? SizedBox(
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
                                        ).createAccount,
                                        style: TextStyle(
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

                  // Divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: Color(0xFFE5E7EB), thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          AppLocalizations.of(context).or,
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: Color(0xFFE5E7EB), thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Google Sign Up Button
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color(0xFFE5E7EB),
                            width: 1.5,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: _handleGoogleSignIn,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Icon(
                                      Icons.g_mobiledata,
                                      size: 24,
                                      color: Color(0xFF2563EB),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    ).continueWithGoogle,
                                    style: TextStyle(
                                      color: Color(0xFF1F2937),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Apple Sign Up Button
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color(0xFFE5E7EB),
                            width: 1.5,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              // Handle Apple sign up
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.apple,
                                    size: 24,
                                    color: Color(0xFF1F2937),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    ).continueWithApple,
                                    style: TextStyle(
                                      color: Color(0xFF1F2937),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Sign In Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context).alreadyHaveAccount,
                        style: TextStyle(color: Color(0xFF6B7280)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          AppLocalizations.of(context).signIn,
                          style: TextStyle(
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

  void _handleSignUp() async {
    // Validate form
    if (_nameController.text.trim().isEmpty) {
      SnackbarUtils.showError(
        context,
        title: 'Validation Error',
        message: AppLocalizations.of(context).enterFullName,
      );
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      SnackbarUtils.showError(
        context,
        title: 'Validation Error',
        message: AppLocalizations.of(context).enterEmail,
      );
      return;
    }

    if (!_isValidEmail(_emailController.text.trim())) {
      SnackbarUtils.showError(
        context,
        title: 'Validation Error',
        message: AppLocalizations.of(context).enterValidEmail,
      );
      return;
    }

    if (_passwordController.text.isEmpty) {
      SnackbarUtils.showError(
        context,
        title: 'Validation Error',
        message: AppLocalizations.of(context).enterPassword,
      );
      return;
    }

    if (_passwordController.text.length < 6) {
      SnackbarUtils.showError(
        context,
        title: 'Validation Error',
        message: AppLocalizations.of(context).passwordTooShort,
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      SnackbarUtils.showError(
        context,
        title: 'Validation Error',
        message: AppLocalizations.of(context).passwordsDontMatch,
      );
      return;
    }

    if (!_agreeToTerms) {
      SnackbarUtils.showError(
        context,
        title: 'Validation Error',
        message: AppLocalizations.of(context).agreeTerms,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = AuthService();
      
      // Sign up with Supabase
      await authService.signUpWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
      );

      // Initialize user service with Supabase user data
      final userService = UserService();
      final supabaseUser = authService.currentUser;
      
      if (supabaseUser != null) {
        // Set user from Supabase - wait for it to complete
        await userService.setCurrentUserFromSupabase(supabaseUser);
      } else {
        // If no session yet, initialize with empty data
        await userService.initialize();
      }

      if (mounted) {
    // Show success message
    SnackbarUtils.showSignupSuccess(context);

    // Navigate to home screen
    Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(
          context,
          title: 'Sign Up Failed',
          message: e.toString().replaceAll('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) {
    setState(() {
      _isLoading = false;
    });
      }
    }
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

  void _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = AuthService();
      await authService.signInWithGoogle();
      
      // Note: The OAuth flow will redirect to browser, then back to app
      // The auth state will be updated automatically via authStateChanges stream
      // We don't need to navigate here as the app will handle the redirect
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      SnackbarUtils.showError(
      context,
        title: 'Google Sign In Failed',
        message: e.toString().replaceAll('Exception: ', ''),
    );
    }
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
