// ============================================================================
// File: lib/main.dart
// Description: The root entry point of the Brutalist BMI Calculator application.
// 
// Architecture & Design:
// - Initializes the Flutter framework and launches the main application widget.
// - Sets up the global Material 3 theme, injecting the distinctive Neo-Brutalist
//   design tokens such as the primary yellow color, Lexend geometric typography,
//   and high-contrast scaffold backgrounds.
// - Routes the user initially to the SplashScreen for an animated introduction.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screens/splash_screen.dart';

/// Entry point of the Brutalist BMI Calculator application.
/// 
/// This file initializes the Flutter engine and sets up the root [BrutalBMICalculator] widget.
/// The application uses a Neo-Brutalist design system characterized by bold typography,
/// high-contrast colors, and hard shadows.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock rotation on phones; keep full rotation support on tablets.
  final view = WidgetsBinding.instance.platformDispatcher.views.first;
  final logicalWidth = view.physicalSize.width / view.devicePixelRatio;
  final logicalHeight = view.physicalSize.height / view.devicePixelRatio;
  final isMobile = (logicalWidth < logicalHeight ? logicalWidth : logicalHeight) < 600;

  await SystemChrome.setPreferredOrientations(
    isMobile
        ? [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]
        : [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ],
  );

  // Initialize AdMob before the widget tree starts requesting ads.
  await MobileAds.instance.initialize();

  runApp(const BrutalBMICalculator());
}

/// The root widget of the application.
/// 
/// It configures the [MaterialApp] with a global design theme, including:
/// * **Typography**: Using Google Fonts (Lexend) for a geometric, modern look.
/// * **Color Palette**: High-contrast Yellow and Cyan paired with bold Black accents.
/// * **Scaffold Theme**: A light-gray background to emphasize the Brutalist containers.
class BrutalBMICalculator extends StatelessWidget {
  const BrutalBMICalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brutal BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        
        // Neo-Brutalist style often uses a slightly off-white or light gray background
        scaffoldBackgroundColor: const Color(0xFFF0F0F0),
        
        // Lexend is chosen for its bold, readable, and geometric character
        textTheme: GoogleFonts.lexendTextTheme(),
        
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFDE59),
          primary: const Color(0xFFFFDE59), // Primary Yellow
          secondary: const Color(0xFF5CE1E6), // Secondary Cyan
        ),
      ),
      // The app starts with the animated SplashScreen
      home: const SplashScreen(),
    );
  }
}
