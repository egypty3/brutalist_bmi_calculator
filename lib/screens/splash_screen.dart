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

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  @override
  void initState() {
    super.initState();
    
    // Timer to automatically navigate away from the splash screen.
    // 3 seconds is enough to let the animations complete and create brand awareness.
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // pushReplacement ensures the user cannot return to the splash screen via the back button.
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const CalculatorScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            // Large, high-impact title text with staggered entry.
            const Text(
              'BMI\nCALCULATOR',
              textAlign: TextAlign.center,
              style: TextStyle(
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
            // A small, high-contrast black box containing the brand tagline.
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              color: Colors.black,
              child: const Text(
                'STAY FIT OR DIE TRYING',
                style: TextStyle(
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
    );
  }
}
