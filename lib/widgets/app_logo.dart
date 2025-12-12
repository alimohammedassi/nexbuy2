import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double? size;
  final Color? color;
  final BoxFit fit;
  final EdgeInsetsGeometry? padding;
  final bool useAnimatedLogo;

  const AppLogo({
    super.key,
    this.size,
    this.color,
    this.fit = BoxFit.contain,
    this.padding,
    this.useAnimatedLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: useAnimatedLogo
          ? Image.asset(
              'images/logo with logo.gif',
              height: size,
              width: size,
              fit: fit,
            )
          : Image.asset(
              'images/Black and White Smart Technology Logo.png',
              height: size,
              width: size,
              fit: fit,
              color: color,
            ),
    );
  }
}

// Predefined logo sizes for common use cases
class AppLogoSmall extends StatelessWidget {
  final Color? color;
  final bool useAnimatedLogo;

  const AppLogoSmall({super.key, this.color, this.useAnimatedLogo = false});

  @override
  Widget build(BuildContext context) {
    return AppLogo(size: 24, color: color, useAnimatedLogo: useAnimatedLogo);
  }
}

class AppLogoMedium extends StatelessWidget {
  final Color? color;
  final bool useAnimatedLogo;

  const AppLogoMedium({super.key, this.color, this.useAnimatedLogo = false});

  @override
  Widget build(BuildContext context) {
    return AppLogo(size: 48, color: color, useAnimatedLogo: useAnimatedLogo);
  }
}

class AppLogoLarge extends StatelessWidget {
  final Color? color;
  final bool useAnimatedLogo;

  const AppLogoLarge({super.key, this.color, this.useAnimatedLogo = false});

  @override
  Widget build(BuildContext context) {
    return AppLogo(size: 80, color: color, useAnimatedLogo: useAnimatedLogo);
  }
}

class AppLogoXLarge extends StatelessWidget {
  final Color? color;
  final bool useAnimatedLogo;

  const AppLogoXLarge({super.key, this.color, this.useAnimatedLogo = false});

  @override
  Widget build(BuildContext context) {
    return AppLogo(size: 120, color: color, useAnimatedLogo: useAnimatedLogo);
  }
}
