// ============================================================================
// File: lib/screens/splash_screen.dart
// Description: The animated loading screen displayed on app startup.
// 
// Functionality & UI:
// - Uses the `flutter_animate` package to choreograph a dynamic, Neo-Brutalist 
//   animation sequence featuring a sliding and fading logo.
// - Delays execution for 2.5 seconds to ensure the animation completes smoothly
//   before securely navigating the user to the `CalculatorScreen`.
// - The screen is fully localized and honors the brutalist aesthetic with thick
//   borders and solid background colors.
// ============================================================================

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/localization.dart';
import '../widgets/brutalist_widgets.dart';
import 'calculator_screen.dart';

/// An animated introductory screen that launches when the app starts.
/// 
/// It utilizes [flutter_animate] to create high-impact, Neo-Brutalist entry effects.
/// The screen automatically transitions to the main [CalculatorScreen] after a brief delay.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Key used to store the user's language choice in persistent storage (phone's app data).
  // It's marked as `static const` because it's the same for all splash screens.
  static const String _prefKeyLanguage = 'selected_language_code';

  // The currently active language code (e.g., 'en', 'ar', 'fr', 'de').
  // The `late` keyword means "trust me, this will be set before it's used".
  late String _currentLang;

  // The localization helper object that translates strings from English to _currentLang.
  // It reads strings from AppLocalization._localizedValues dictionary.
  late AppLocalization _loc;

  @override
  void initState() {
    super.initState();

    // Detect what language the phone's OS is using (e.g., 'ar' for Arabic).
    // If the phone's language isn't supported by us, default to English.
    final systemLang = PlatformDispatcher.instance.locale.languageCode;
    _currentLang = AppLocalization.languages.containsKey(systemLang)
        ? systemLang
        : 'en';

    // Create a localization helper with the chosen language so we can translate strings.
    _loc = AppLocalization(_currentLang);

    // Check if the user previously saved a language preference and restore it.
    // (E.g., if they tapped "Français" last time, use French again).
    _restoreSavedLanguage();
    
    // Timer to automatically navigate away from the splash screen.
    // 3 seconds is enough to let the animations complete and create brand awareness.
    Future.delayed(const Duration(seconds: 3), () {
      // `mounted` checks: "Is this widget still in the tree?"
      // If the user navigated away mid-animation, don't try to update a dead widget.
      if (mounted) {
        // pushReplacement: Go to CalculatorScreen and REMOVE the splash from the back stack.
        // This means tapping the back button won't bring the splash screen back.
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const CalculatorScreen()),
        );
      }
    });
  }

  Future<void> _restoreSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString(_prefKeyLanguage);

    if (!mounted || savedLang == null) return;
    if (!AppLocalization.languages.containsKey(savedLang)) return;
    if (savedLang == _currentLang) return;

    setState(() {
      _currentLang = savedLang;
      _loc = AppLocalization(savedLang);
    });
  }

  String _formatSplashTitle(String title) {
    final firstSpace = title.indexOf(' ');
    if (firstSpace <= 0 || firstSpace >= title.length - 1) return title;
    return '${title.substring(0, firstSpace)}\n${title.substring(firstSpace + 1)}';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _loc.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFDE59), // Theme primary: Bold Yellow
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- LOGO ICON ---
              // Centered weight icon inside a Brutalist box with entry animations.
              const BrutalistContainer(
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(24),
                child: Icon(
                  Icons.monitor_weight_outlined,
                  size: 80,
                  color: Colors.black,
                ),
              )
              .animate()
              .scale(duration: 600.ms, curve: Curves.elasticOut) // Pops out on entry
              .shimmer(delay: 800.ms, duration: 1200.ms),      // Subtle light sweep effect

              const SizedBox(height: 40),

              // --- APP TITLE ---
              // Localized title with line breaks when there are spaces.
              Text(
                _formatSplashTitle(_loc.translate('title')),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w900,
                  height: 0.9,
                  letterSpacing: -2,
                  color: Colors.black,
                ),
              )
              .animate()
              .fadeIn(delay: 400.ms)
              .slideY(begin: 0.2, end: 0), // Slides up into position

              const SizedBox(height: 20),

              // --- TAGLINE ---
              // Localized motivational line in a high-contrast chip.
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                color: Colors.black,
                child: Text(
                  _loc.translate('splash_tagline'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 800.ms)
              .scaleX(begin: 0), // Expands horizontally
            ],
          ),
        ),
      ),
    );
  }
}
