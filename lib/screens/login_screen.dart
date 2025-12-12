import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import '../widgets/app_logo.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import '../localization/app_localizations.dart';
import '../utils/snackbar_utils.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LiquidGlassLoginPage extends StatefulWidget {
  const LiquidGlassLoginPage({super.key});

  @override
  State<LiquidGlassLoginPage> createState() => _LiquidGlassLoginPageState();
}

class _LiquidGlassLoginPageState extends State<LiquidGlassLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  StreamSubscription<AuthState>? _authStateSubscription;

  @override
  void initState() {
    super.initState();
    _listenToAuthState();
  }

  void _listenToAuthState() {
    final authService = AuthService();
    _authStateSubscription = authService.authStateChanges.listen((
      AuthState state,
    ) async {
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
      body: Stack(
        children: [
          // Animated gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFEBF4FF),
                  Color(0xFFF0F9FF),
                  Color(0xFFE0F2FE),
                  Color(0xFFFDF4FF),
                ],
              ),
            ),
          ),

          // Floating orbs for depth
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0xFF60A5FA).withOpacity(0.3),
                    Color(0xFF60A5FA).withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0xFFC084FC).withOpacity(0.25),
                    Color(0xFFC084FC).withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Section with glass container
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                        child: Container(
                          padding: EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.7),
                                Colors.white.withOpacity(0.3),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF2563EB).withOpacity(0.1),
                                blurRadius: 30,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: AppLogoXLarge(useAnimatedLogo: true),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Welcome Text
                    Text(
                      '${AppLocalizations.of(context).welcome} ${AppLocalizations.of(context).appName}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${AppLocalizations.of(context).signIn} ${AppLocalizations.of(context).toContinue}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 50),

                    // Email Input with enhanced glass effect
                    _buildGlassInput(
                      controller: _emailController,
                      hintText: AppLocalizations.of(context).email,
                      icon: Icons.email_outlined,
                      isPassword: false,
                    ),
                    const SizedBox(height: 20),

                    // Password Input with enhanced glass effect
                    _buildGlassInput(
                      controller: _passwordController,
                      hintText: AppLocalizations.of(context).password,
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),
                    const SizedBox(height: 16),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context).forgotPassword,
                          style: TextStyle(
                            color: Color(0xFF2563EB),
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Login Button with premium glass effect
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF3B82F6),
                                Color(0xFF2563EB),
                                Color(0xFF1D4ED8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
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
                              borderRadius: BorderRadius.circular(24),
                              onTap: _handleLogin,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
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
                                          AppLocalizations.of(context).signIn,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Divider with glass effect
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Color(0xFFE5E7EB).withOpacity(0.5),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            AppLocalizations.of(context).or,
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFE5E7EB).withOpacity(0.5),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Google Login Button
                    _buildSocialButton(
                      icon: Icons.g_mobiledata,
                      text: AppLocalizations.of(context).continueWithGoogle,
                      iconColor: Color(0xFF2563EB),
                      onTap: _handleGoogleSignIn,
                    ),
                    const SizedBox(height: 16),

                    // Apple Login Button
                    _buildSocialButton(
                      icon: Icons.apple,
                      text: AppLocalizations.of(context).continueWithApple,
                      iconColor: Color(0xFF1F2937),
                      onTap: () {},
                    ),
                    const SizedBox(height: 40),

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context).dontHaveAccount,
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 15,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LiquidGlassSignupPage(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            AppLocalizations.of(context).signup,
                            style: TextStyle(
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
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
        ],
      ),
    );
  }

  Widget _buildGlassInput({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool isPassword,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.7),
                Colors.white.withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF2563EB).withOpacity(0.08),
                blurRadius: 20,
                offset: Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword && _obscurePassword,
            style: TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Container(
                margin: EdgeInsets.all(12),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF2563EB).withOpacity(0.1),
                      Color(0xFF3B82F6).withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Color(0xFF2563EB), size: 22),
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Container(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Color(0xFF6B7280),
                          size: 22,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String text,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.7),
                Colors.white.withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF2563EB).withOpacity(0.05),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: iconColor.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(icon, size: 24, color: iconColor),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      text,
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
    );
  }

  void _handleLogin() async {
    // Validate form
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

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = AuthService();
      final session = await authService.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Initialize user service with Supabase user data
      final userService = UserService();
      await userService.setCurrentUserFromSupabase(session.user);

      if (mounted) {
        // Show success message
        SnackbarUtils.showLoginSuccess(context);

        // Navigate to home screen
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(
          context,
          title: 'Login Failed',
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
