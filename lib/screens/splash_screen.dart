import 'package:flutter/material.dart';

import '../widgets/language_switcher.dart';

import '../localization/app_localizations.dart';

import '../utils/font_utils.dart';

import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ═══════════════════════════════════════════════════════════

// THEME COLORS

// ═══════════════════════════════════════════════════════════

abstract class _AppColors {
  static const Color primary = Color(0xFF2563EB);
  static const Color accent = Color(0xFF2563EB); // Blue accent
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color textPrimary = Colors.white;
  static const Color textMuted = Color(0xFF9CA3AF);
}

class AppSplashScreen extends StatefulWidget {
  const AppSplashScreen({super.key});

  @override
  State<AppSplashScreen> createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;

  late final AnimationController _imageController;

  late final Animation<double> _fadeIn;

  late final Animation<Offset> _slideUp;

  late final Animation<double> _imageScale;

  late final Animation<double> _imageFade;

  @override
  void initState() {
    super.initState();

    _initAnimations();

    _startAnimations();

    // Check authentication state
    _checkAuthState();
  }

  void _checkAuthState() {
    // Listen to auth state changes
    final authService = AuthService();
    authService.authStateChanges.listen((AuthState state) {
      if (mounted) {
        if (state.session != null) {
          // User is logged in, navigate to home
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          });
        }
      }
    });

    // Check current session immediately
    if (authService.isLoggedIn) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      });
    }
  }

  void _initAnimations() {
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1200),

      vsync: this,
    );

    _imageController = AnimationController(
      duration: const Duration(milliseconds: 1500),

      vsync: this,
    );

    _imageFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _imageController,

        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _imageScale = Tween<double>(begin: 1.1, end: 1.0).animate(
      CurvedAnimation(
        parent: _imageController,

        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,

        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    _slideUp = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entranceController,

            curve: const Interval(0.2, 0.9, curve: Curves.easeOutCubic),
          ),
        );
  }

  void _startAnimations() {
    _imageController.forward();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();

    _imageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);

    final isRTL = langProvider.currentLocale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: _AppColors.background,

      body: Stack(
        children: [
          // Background Image with animation
          _buildBackgroundImage(),

          // Gradient overlay
          _buildGradientOverlay(),

          // Bottom content section
          _buildBottomContent(context, isRTL),

          // Language button
          _buildLanguageButton(context),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return AnimatedBuilder(
      animation: _imageController,

      builder: (context, child) {
        return Opacity(
          opacity: _imageFade.value,

          child: Transform.scale(
            scale: _imageScale.value,

            child: SizedBox.expand(
              child: Image.asset(
                'images/freepik__adjust__60158.png',

                fit: BoxFit.cover,

                alignment: Alignment.topCenter,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,

            end: Alignment.bottomCenter,

            colors: [
              Colors.transparent,

              Colors.transparent,

              _AppColors.background.withOpacity(0.3),

              _AppColors.background.withOpacity(0.85),

              _AppColors.background,
            ],

            stops: const [0.0, 0.35, 0.5, 0.65, 0.75],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomContent(BuildContext context, bool isRTL) {
    final size = MediaQuery.sizeOf(context);

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Positioned(
      bottom: 0,

      left: 0,

      right: 0,

      child: FadeTransition(
        opacity: _fadeIn,

        child: SlideTransition(
          position: _slideUp,

          child: Container(
            padding: EdgeInsets.fromLTRB(24, 0, 24, bottomPadding + 24),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisSize: MainAxisSize.min,

              children: [
                // Main Title
                _buildTitle(context),

                const SizedBox(height: 16),

                // Subtitle
                _buildSubtitle(context),

                SizedBox(height: size.height * 0.04),

                // Swiper to get started
                _buildSwiper(context, isRTL),

                const SizedBox(height: 16),

                // Swipe hint
                _buildSwipeHint(context, isRTL),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.upgradeYour,
          style: FontUtils.getTextStyle(
            context,
            fontSize: 38,
            fontWeight: FontWeight.w700,
            color: _AppColors.textPrimary,
            height: 1.1,
          ),
        ),
        Row(
          children: [
            Text(
              localizations.tech,
              style: FontUtils.getTextStyle(
                context,
                fontSize: 38,
                fontWeight: FontWeight.w700,
                color: _AppColors.accent,
                height: 1.1,
              ),
            ),
            Text(
              ' ${localizations.life}',
              style: FontUtils.getTextStyle(
                context,
                fontSize: 38,
                fontWeight: FontWeight.w700,
                color: _AppColors.textPrimary,
                height: 1.1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      AppLocalizations.of(context).splashSubtitle,
      style: FontUtils.getTextStyle(
        context,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: _AppColors.textMuted,
        height: 1.5,
      ),
    );
  }

  Widget _buildSwiper(BuildContext context, bool isRTL) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: _AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_AppColors.primaryLight, _AppColors.primary],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).getStarted,
                  style: FontUtils.getTextStyle(
                    context,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isRTL
                      ? Icons.arrow_back_rounded
                      : Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeHint(BuildContext context, bool isRTL) {
    // Hidden as we moved to a button
    return const SizedBox.shrink();
  }

  Widget _buildLanguageButton(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,

      right: 16,

      child: FadeTransition(
        opacity: _fadeIn,

        child: Material(
          color: Colors.transparent,

          child: InkWell(
            onTap: () => _showLanguageDialog(context),

            borderRadius: BorderRadius.circular(50),

            child: Container(
              padding: const EdgeInsets.all(10),

              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),

                shape: BoxShape.circle,

                border: Border.all(
                  color: Colors.white.withOpacity(0.2),

                  width: 1,
                ),
              ),

              child: const Icon(
                Icons.language_rounded,

                color: _AppColors.textPrimary,

                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,

      barrierDismissible: true,

      barrierColor: Colors.black.withOpacity(0.7),

      builder: (_) => const Dialog(
        backgroundColor: Colors.transparent,

        child: LanguageSwitcher(),
      ),
    );
  }
}
