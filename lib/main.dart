// ============================================================================
// File: lib/main.dart
// Description: The root entry point of the Brutalist BMI Calculator application.
//
// ── How a Flutter app starts ──────────────────────────────────────────────────
// Every Flutter app begins at the `main()` function below.  The Dart runtime
// calls it automatically when the app launches on the device.
//
// `main()` has three jobs:
//   1. Tell Flutter to initialise its engine (WidgetsFlutterBinding).
//   2. Run any one-time setup tasks (orientation lock, AdMob init).
//   3. Call `runApp()` with our root widget, which hands control to Flutter's
//      rendering engine.
//
// ── Widget tree concept ───────────────────────────────────────────────────────
// Flutter builds UIs as a nested tree of widgets — similar to HTML elements.
// At the very top of the tree sits the `BrutalBMICalculator` widget below.
// Every other widget in the app is a descendant of it.
//
//   BrutalBMICalculator (MaterialApp)
//   └── SplashScreen
//       └── (after 3 s) CalculatorScreen
//           ├── TutorialScreen   (first-launch only)
//           └── DiseasesScreen   (on classification row tap)
//
// ── Design tokens ─────────────────────────────────────────────────────────────
// The theme defined here propagates to every widget in the tree.  Setting
// colors and fonts once at the top avoids repeating them in every screen file.
// ============================================================================

// ── Imports ───────────────────────────────────────────────────────────────────
// `package:flutter/material.dart` gives us Material widgets (Scaffold, Text,
// AppBar, etc.) and the core Flutter framework.
import 'package:flutter/material.dart';

// `package:flutter/services.dart` provides SystemChrome, which controls
// low-level device settings like orientation and status-bar color.
import 'package:flutter/services.dart';

// Google Fonts gives access to hundreds of web fonts packaged as Dart code.
// We use Lexend — a geometric, readable typeface designed for digital screens.
import 'package:google_fonts/google_fonts.dart';

// google_mobile_ads is the AdMob SDK Flutter plugin.
// MobileAds.instance.initialize() MUST be called before any ad is requested.
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Our own splash screen widget defined in a separate file.
import 'screens/splash_screen.dart';

// ============================================================================
//  ENTRY POINT
// ============================================================================

/// The first function Dart calls when the app launches.
///
/// It is `async` because some setup steps (orientation lock, AdMob init)
/// are asynchronous operations — they communicate with the OS and we must
/// `await` their completion before proceeding.
void main() async {
  // ── Step 1: Bind Flutter to the platform ──────────────────────────────────
  // Before calling any Flutter service (like SystemChrome), we must ensure
  // the Flutter engine and the native Android/iOS layer are connected.
  // This call is required whenever you `await` something before `runApp()`.
  // Think of it as saying "Hey Flutter, are you ready to talk to the OS?"
  WidgetsFlutterBinding.ensureInitialized();

  // ── Step 2: Detect screen size for orientation policy ─────────────────────
  // We lock phones to portrait mode (to prevent accidental rotation)
  // while tablets can rotate freely since their layout handles both orientations.
  //
  // `platformDispatcher.views.first` gives us the primary display.
  // `physicalSize` is in hardware pixels; dividing by `devicePixelRatio` converts
  // to logical pixels — the unit Flutter uses for all layout calculations.
  final view         = WidgetsBinding.instance.platformDispatcher.views.first;
  final logicalWidth  = view.physicalSize.width  / view.devicePixelRatio;
  final logicalHeight = view.physicalSize.height / view.devicePixelRatio;

  // The "short side" of the screen determines device category:
  // < 600 logical px → phone;  ≥ 600 logical px → tablet.
  final isMobile =
      (logicalWidth < logicalHeight ? logicalWidth : logicalHeight) < 600;

  // setPreferredOrientations tells the OS which rotations to allow.
  // We await it so the lock is active before the first frame is rendered.
  await SystemChrome.setPreferredOrientations(
    isMobile
        ? [
            DeviceOrientation.portraitUp,   // Normal portrait
            DeviceOrientation.portraitDown, // Upside-down portrait (tablet keyboards)
          ]
        : [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,  // Tablet landscape
            DeviceOrientation.landscapeRight,
          ],
  );

  // ── Step 3: Initialise the AdMob SDK ──────────────────────────────────────
  // MobileAds.instance.initialize() establishes the connection to the AdMob
  // servers.  It must complete before any BannerAd is created.
  // The `await` here blocks runApp() until the SDK is ready.
  await MobileAds.instance.initialize();

  // ── Step 4: Launch the Flutter widget tree ────────────────────────────────
  // runApp() takes a widget and mounts it at the root of the widget tree.
  // From this point on, Flutter owns the screen and manages all rendering.
  runApp(const BrutalBMICalculator());
}

// ============================================================================
//  ROOT WIDGET
// ============================================================================

/// The root widget of the application.
///
/// This is a [StatelessWidget] because the top-level app configuration
/// (theme, routes) never changes at runtime.  Only the screens inside it
/// are StatefulWidgets that rebuild when the user interacts with them.
///
/// [MaterialApp] is Flutter's built-in widget for Material Design apps.
/// It provides:
///   - Global `theme` (colors, typography) inherited by all descendants.
///   - Navigator for push/pop screen transitions.
///   - `debugShowCheckedModeBanner: false` hides the red "DEBUG" ribbon.
class BrutalBMICalculator extends StatelessWidget {
  const BrutalBMICalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brutal BMI Calculator', // Shown in task-switchers / app title
      debugShowCheckedModeBanner: false, // Hides the red DEBUG badge

      // ── Global Theme ──────────────────────────────────────────────────────
      // ThemeData is a single object that holds ALL visual configuration.
      // Any widget deep in the tree can read it with Theme.of(context).
      theme: ThemeData(
        // useMaterial3: true enables the newest Material You design system
        // with rounder shapes, tonal color palettes, and improved components.
        useMaterial3: true,

        // The Neo-Brutalist style often uses a slightly off-white or light
        // gray background to contrast against the white content cards.
        // 0xFFF0F0F0 = (Alpha=FF, Red=F0, Green=F0, Blue=F0) = light gray.
        scaffoldBackgroundColor: const Color(0xFFF0F0F0),

        // GoogleFonts.lexendTextTheme() replaces the default Roboto font
        // with Lexend across the entire app — all Text widgets pick it up
        // automatically unless they specify a different fontFamily.
        textTheme: GoogleFonts.lexendTextTheme(),

        // ColorScheme.fromSeed() generates a harmonious set of 30+ colors
        // (surfaces, on-colors, containers, etc.) from a single seed color.
        // We override "primary" and "secondary" with our exact brand colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFDE59),    // Seed for auto-generated tones
          primary:   const Color(0xFFFFDE59),    // Neo-Brutalist yellow
          secondary: const Color(0xFF5CE1E6),    // Neo-Brutalist cyan
        ),
      ),

      // ── Initial Screen ─────────────────────────────────────────────────────
      // `home` is the first route pushed on the Navigator stack.
      // SplashScreen plays a 3-second animation then navigates to CalculatorScreen.
      home: const SplashScreen(),
    );
  }
}
