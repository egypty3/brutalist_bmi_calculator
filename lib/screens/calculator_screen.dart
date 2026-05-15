// ============================================================================
// File: lib/screens/calculator_screen.dart
// Description: The core interface and state manager of the BMI Calculator.
//
// ── What is "State"? ─────────────────────────────────────────────────────────
// "State" is information that can change while the app is running. For example,
// the user's current weight, the chosen language, or the calculated BMI are all
// pieces of state. Flutter splits widgets into:
//   • StatelessWidget — its appearance never changes after it's built.
//   • StatefulWidget  — it has mutable data; calling setState() asks Flutter
//                       to re-run build() so the UI shows the new values.
//
// ── Architecture ─────────────────────────────────────────────────────────────
// • _CalculatorScreenState holds ALL user inputs (age, weight, height, gender)
//   plus every derived result (bmi, classificationKey, etc.).
// • Any time an input changes, _calculate() is called, which re-runs the math
//   and then calls setState() so Flutter redraws only the affected widgets.
//
// ── Adaptive Layout ──────────────────────────────────────────────────────────
// • LayoutBuilder measures the available width at runtime.
// • Width ≥ 600 px (tablet) → _buildTabletLayout()  (two-column, no scroll)
// • Width  < 600 px (phone) → _buildPhoneLayout()   (single-column, scrollable)
//
// ── New in this version ───────────────────────────────────────────────────────
// • First-launch tutorial (shown once via SharedPreferences).
// • "Show Tutorial" option added to the ⋮ menu.
// • Ideal weight now targets BMI = 25 (the top of the healthy range).
// • Classification rows are tappable — opens the DiseasesScreen.
// ============================================================================

// ── Dart / Flutter core imports ───────────────────────────────────────────────
import 'dart:ui';
// flutter/foundation provides `defaultTargetPlatform` used to check whether
// the app is running on Android or iOS (needed to pick the right AdMob unit).
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ── Third-party packages ──────────────────────────────────────────────────────
// google_mobile_ads: shows AdMob banner advertisements.
import 'package:google_mobile_ads/google_mobile_ads.dart';
// shared_preferences: persists simple key/value pairs across app restarts.
// We use it to remember whether the user has already seen the tutorial.
import 'package:shared_preferences/shared_preferences.dart';

// ── Local imports — our own files ─────────────────────────────────────────────
import '../widgets/brutalist_widgets.dart';  // BrutalistContainer, BrutalistButton
import '../utils/bmi_logic.dart';            // BMICalculator math helper
import '../utils/localization.dart';         // AppLocalization translation helper
import 'tutorial_screen.dart';               // First-launch tutorial pages
import 'diseases_screen.dart';               // BMI health-risks reference screen

// ┌─────────────────────────────────────────────────────────────────────────────┐
// │  CalculatorScreen — the StatefulWidget declaration                          │
// └─────────────────────────────────────────────────────────────────────────────┘
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

// ┌─────────────────────────────────────────────────────────────────────────────┐
// │  _CalculatorScreenState — where all the logic and data live                 │
// └─────────────────────────────────────────────────────────────────────────────┘
class _CalculatorScreenState extends State<CalculatorScreen> {

  // ── USER INPUT STATE ─────────────────────────────────────────────────────────
  // These variables store what the user enters into the calculator.
  // Whenever ANY of these change, we call setState() to rebuild the widgets
  // and show the new results. Think of them as the "model" or "data" of the app.
  int    age    = 25;           // Age in years
  double height = 170.0;        // Always stored in centimetres internally (100-220cm)
  double weight = 70.0;         // Always stored in kilograms internally
  bool   isMale = true;         // Gender (affects fat% calculation and display)
  bool   isCm   = true;         // Display unit: true = cm, false = feet+inches
  bool   isKg   = true;         // Display unit: true = kg, false = pounds

  // ── LOCALIZATION ─────────────────────────────────────────────────────────────
  // These help translate the UI text to the user's chosen language.
  late String _currentLang;     // Current language code ('en', 'ar', 'fr', 'de')
  late AppLocalization _loc;    // Helper object to translate string keys into text

  // ── DERIVED RESULTS ───────────────────────────────────────────────────────────
  // These are NOT user inputs — they're calculated from the data above.
  // Every time weight/height/age changes, we recalculate these and rebuild the UI.
  double bmi                 = 0;       // The computed BMI value (weight / height²)
  String classificationKey   = 'cat_n'; // Which category: 'cat_n' (normal), 'cat_o' (overweight), etc.
  Color  classificationColor = Colors.black; // Color associated with the classification

  // ── UNIT CONVERSION CONSTANTS ─────────────────────────────────────────────────
  static const double cmPerInch = 2.54;
  static const double kgPerLb   = 0.45359237;

  // ── HEIGHT SLIDER BOUNDS ──────────────────────────────────────────────────────
  static const double _minHeightCm = 100.0;
  static const double _maxHeightCm = 220.0;

  // ── AD STATE ──────────────────────────────────────────────────────────────────
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  static const String _androidBannerAdUnitId =
      'ca-app-pub-5785609346141040/9590890493';
  static const String _iosTestBannerAdUnitId  =
      'ca-app-pub-3940256099942544/2934735716';

  // ── LAYOUT BREAKPOINT ────────────────────────────────────────────────────────
  static const double _tabletBreakpoint = 600.0;

  // ── SHARED PREFERENCES KEY ───────────────────────────────────────────────────
  static const String _prefKeyTutorial = 'has_seen_tutorial';
  static const String _prefKeyLanguage = 'selected_language_code';

  // ══════════════════════════════════════════════════════════════════════════════
  //  LIFECYCLE
  // ══════════════════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();

    // Detect system language and fall back to English if unsupported.
    String systemLang = PlatformDispatcher.instance.locale.languageCode;
    _currentLang = AppLocalization.languages.containsKey(systemLang)
        ? systemLang
        : 'en';
    _loc = AppLocalization(_currentLang);

    // Restore the last selected UI language if the user previously chose one.
    _restoreSavedLanguage();

    // Compute BMI for the defaults so the screen opens with valid results.
    _calculate();

    // Post-frame tasks that need the screen to be visible first.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBannerAd();
      _checkAndShowTutorial();
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════════════════════════
  //  TUTORIAL
  // ══════════════════════════════════════════════════════════════════════════════

  /// Reads SharedPreferences and pushes TutorialScreen on first launch.
  Future<void> _checkAndShowTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenTutorial = prefs.getBool(_prefKeyTutorial) ?? false;
    if (!hasSeenTutorial && mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => TutorialScreen(localization: _loc),
        ),
      );
      await prefs.setBool(_prefKeyTutorial, true);
    }
  }

  /// Opens the tutorial unconditionally (from the ⋮ menu).
  Future<void> _navigateToTutorial() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TutorialScreen(localization: _loc),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════════
  //  AD LOADING
  // ══════════════════════════════════════════════════════════════════════════════

  /// Returns the correct ad unit ID for the current platform, or null.
  String? get _bannerAdUnitId {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android: return _androidBannerAdUnitId;
      case TargetPlatform.iOS:     return _iosTestBannerAdUnitId;
      default:                     return null;
    }
  }

  /// Loads an adaptive banner sized to the screen width.
  Future<void> _loadBannerAd() async {
    final adUnitId = _bannerAdUnitId;
    if (adUnitId == null) return;

    final mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery == null) return;
    final adWidth = mediaQuery.size.width.truncate();
    if (adWidth <= 0) return;

    final adaptiveSize =
        await AdSize.getLargeAnchoredAdaptiveBannerAdSize(adWidth);
    if (adaptiveSize == null || !mounted) return;

    _bannerAd?.dispose();
    setState(() { _bannerAd = null; _isBannerAdReady = false; });

    final banner = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: adaptiveSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) { ad.dispose(); return; }
          setState(() { _bannerAd = ad as BannerAd; _isBannerAdReady = true; });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (!mounted) return;
          setState(() => _isBannerAdReady = false);
          debugPrint('Banner ad failed: $error');
        },
      ),
    );
    banner.load();
  }

  // ══════════════════════════════════════════════════════════════════════════════
  //  CALCULATION
  // ══════════════════════════════════════════════════════════════════════════════

  void _calculate() {
    // setState() tells Flutter: "The data changed. Rebuild the UI."
    // Inside setState(), we update the derived values based on current user inputs.
    setState(() {
      // Call the static BMI math function with current height and weight (in metric).
      bmi = BMICalculator.calculateBMI(height, weight);

      // Get the classification (category + color) that matches this BMI value.
      // Example: if BMI is 22, getClassification returns 'cat_n' (Normal) + green color.
      final result       = BMICalculator.getClassification(bmi);
      classificationKey  = result.key;   // e.g., 'cat_n', 'cat_o', 'cat_o3'
      classificationColor = result.color; // e.g., green, orange, red
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

  Future<void> _changeLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKeyLanguage, langCode);

    setState(() {
      _currentLang = langCode;
      _loc         = AppLocalization(langCode);
    });
  }

  /// 1 cm per tap in metric mode; 1 inch (= 2.54 cm) per tap in imperial mode.
  double get _heightStep => isCm ? 1.0 : cmPerInch;

  void _changeHeightByStep(int direction) {
    final updated =
        (height + (direction * _heightStep)).clamp(_minHeightCm, _maxHeightCm);
    setState(() { height = updated.toDouble(); _calculate(); });
  }

  // ══════════════════════════════════════════════════════════════════════════════
  //  BUILD
  // ══════════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _loc.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            _loc.translate('title'),
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
          ),
          actions: [
            // ⋮ button → language picker + "Show Tutorial" option.
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () => _showLanguageDialog(),
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= _tabletBreakpoint) {
              return _buildTabletLayout();
            }
            return _buildPhoneLayout();
          },
        ),
        bottomNavigationBar: _buildBannerArea(),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════════
  //  BANNER AD AREA
  // ══════════════════════════════════════════════════════════════════════════════

  Widget _buildBannerArea() {
    if (!_isBannerAdReady || _bannerAd == null) {
      return const SizedBox.shrink();
    }
    final ad = _bannerAd!;
    return SafeArea(
      top: false,
      child: Container(
        alignment: Alignment.center,
        color: Colors.white,
        width: double.infinity,
        height: ad.size.height.toDouble(),
        child: AdWidget(ad: ad),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════════
  //  PHONE LAYOUT  (single scrollable column)
  // ══════════════════════════════════════════════════════════════════════════════

  Widget _buildPhoneLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _genderRow(),
          const SizedBox(height: 24),
          _ageWeightRow(),
          const SizedBox(height: 24),
          _heightCard(),
          const SizedBox(height: 32),
          _resultsCard(),
          const SizedBox(height: 32),
          _classificationSection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════════
  //  TABLET LAYOUT  (two fixed columns, no scroll)
  // ══════════════════════════════════════════════════════════════════════════════

  Widget _buildTabletLayout() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // LEFT COLUMN — inputs
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _genderRow(iconSize: 52, fontSize: 16),
                const SizedBox(height: 16),
                _ageWeightRow(),
                const SizedBox(height: 16),
                Expanded(child: _heightCard(expandSlider: true)),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // RIGHT COLUMN — results + reference table
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _resultsCard(tabletMode: true),
                const SizedBox(height: 16),
                Expanded(child: _classificationSection(scrollable: false)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════════
  //  SECTION BUILDERS
  // ══════════════════════════════════════════════════════════════════════════════

  // ── Gender Row ────────────────────────────────────────────────────────────────

  Widget _genderRow({double iconSize = 40, double fontSize = 14}) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildGenderCard(
              _loc.translate('male'), Icons.man, isMale,
              () => setState(() { isMale = true;  _calculate(); }),
              iconSize: iconSize, fontSize: fontSize,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildGenderCard(
              _loc.translate('female'), Icons.woman, !isMale,
              () => setState(() { isMale = false; _calculate(); }),
              iconSize: iconSize, fontSize: fontSize,
            ),
          ),
        ),
      ],
    );
  }

  // ── Age + Weight Row ──────────────────────────────────────────────────────────

  Widget _ageWeightRow() {
    return Row(
      children: [
        Expanded(
          child: _buildCounterCard(
            _loc.translate('age'), age,
            (val) => setState(() { age = val; _calculate(); }),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildCounterCard(
            _loc.translate('weight'),
            isKg ? weight.toInt() : (weight / kgPerLb).round(),
            (val) => setState(() {
              weight = isKg ? val.toDouble() : val * kgPerLb;
              _calculate();
            }),
            unit: isKg ? 'KG' : 'LB',
            onUnitTap: () => _showUnitDialog(
              _loc.translate('weight_unit'), ['KG', 'LB'], isKg ? 'KG' : 'LB',
              (val) => setState(() { isKg = (val == 'KG'); _calculate(); }),
            ),
          ),
        ),
      ],
    );
  }

  // ── Height Card ───────────────────────────────────────────────────────────────

  /// [expandSlider] = true on tablet: spacers spread the content vertically.
  /// compact mode reduces text/spacing only — button sizes stay identical to
  /// the age/weight cards so the UI feels consistent.
  Widget _heightCard({bool expandSlider = false}) {
    return BrutalistContainer(
      backgroundColor: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // compact is true when the tablet card height is too tight (< 170 px).
          final compact = expandSlider && constraints.maxHeight < 170;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (expandSlider && !compact) const Spacer(),

              // "HEIGHT" label — slightly smaller in compact mode.
              Text(
                _loc.translate('height'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: compact ? 13 : 16,
                ),
              ),
              SizedBox(height: compact ? 4 : 8),

              // [−]  170 CM  [+]
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Decrease button — uses default size to match age/weight buttons.
                  _buildRoundButton(Icons.remove, () => _changeHeightByStep(-1)),

                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        if (isCm)
                          Text(
                            height.toStringAsFixed(0),
                            style: TextStyle(
                              fontSize: compact ? 38 : 48,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                        else
                          Text(
                            _formatHeightInFeet(height),
                            style: TextStyle(
                              fontSize: compact ? 26 : 32,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        SizedBox(width: compact ? 6 : 8),
                        // Tappable unit badge (CM / FT+IN).
                        GestureDetector(
                          onTap: () => _showUnitDialog(
                            _loc.translate('height_unit'),
                            ['CM', 'FT + IN'],
                            isCm ? 'CM' : 'FT + IN',
                            (val) => setState(() {
                              isCm = (val == 'CM');
                              _calculate();
                            }),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: compact ? 8 : 10,
                              vertical:   compact ? 2 : 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isCm ? 'CM' : 'FT+IN',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: compact ? 11 : 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Increase button — same default size as age/weight buttons.
                  _buildRoundButton(Icons.add, () => _changeHeightByStep(1)),
                ],
              ),
              SizedBox(height: compact ? 2 : 8),

              Slider(
                value: height,
                min: _minHeightCm,
                max: _maxHeightCm,
                activeColor: Colors.black,
                inactiveColor: Colors.black12,
                onChanged: (val) => setState(() {
                  height = val.clamp(_minHeightCm, _maxHeightCm);
                  _calculate();
                }),
              ),
              if (expandSlider && !compact) const Spacer(),
            ],
          );
        },
      ),
    );
  }

  // ── Results Card ──────────────────────────────────────────────────────────────

  /// Three-panel card: ideal weight (BMI=25) | BMI score | body fat %.
  Widget _resultsCard({bool tabletMode = false}) {
    return BrutalistContainer(
      padding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // LEFT — Ideal weight at BMI = 25.
            // Using BMI 25 as the "ideal" target (upper bound of healthy range)
            // because it is the most natural single goal weight to aim for.
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _loc.translate('ideal'),
                      style: TextStyle(
                        fontSize: tabletMode ? 14 : 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        isKg
                            ? '${BMICalculator.getIdealWeight(height).toStringAsFixed(1)}kg'
                            : '${(BMICalculator.getIdealWeight(height) / kgPerLb).toStringAsFixed(1)}lb',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: tabletMode ? 22 : 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(width: 2, color: Colors.black),

            // CENTER — BMI value + category badge.
            Expanded(
              flex: 2,
              child: Container(
                color: const Color(0xFF5CE1E6),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'BMI',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      bmi.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: tabletMode ? 64 : 48,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _loc.translate(classificationKey).toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: classificationColor,
                          fontWeight: FontWeight.w900,
                          fontSize: tabletMode ? 13 : 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(width: 2, color: Colors.black),

            // RIGHT — Estimated body fat %.
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _loc.translate('fat'),
                      style: TextStyle(
                        fontSize: tabletMode ? 14 : 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${BMICalculator.estimateFatPercentage(bmi, age, isMale).toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: tabletMode ? 22 : 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Classification Section ────────────────────────────────────────────────────

  Widget _classificationSection({bool scrollable = true}) {
    final expandRows = !scrollable;

    final table = BrutalistContainer(
      backgroundColor: Colors.white,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _buildClassificationRow(_loc.translate('cat_vsu'), '< 16',      const Color(0xFFFF5252), categoryKey: 'cat_vsu', expand: expandRows),
          _buildClassificationRow(_loc.translate('cat_su'),  '16 - 17',   const Color(0xFFFF7043), categoryKey: 'cat_su',  expand: expandRows),
          _buildClassificationRow(_loc.translate('cat_u'),   '17 - 18.5', const Color(0xFFE65100), categoryKey: 'cat_u',   expand: expandRows),
          _buildClassificationRow(_loc.translate('cat_n'),   '18.5 - 25', const Color(0xFF4CAF50), categoryKey: 'cat_n',   expand: expandRows),
          _buildClassificationRow(_loc.translate('cat_o'),   '25 - 30',   const Color(0xFFF57F17), categoryKey: 'cat_o',   expand: expandRows),
          _buildClassificationRow(_loc.translate('cat_o1'),  '30 - 35',   const Color(0xFFFF8A65), categoryKey: 'cat_o1',  expand: expandRows),
          _buildClassificationRow(_loc.translate('cat_o2'),  '35 - 40',   const Color(0xFFF4511E), categoryKey: 'cat_o2',  expand: expandRows),
          _buildClassificationRow(_loc.translate('cat_o3'),  '> 40',      const Color(0xFFD32F2F), categoryKey: 'cat_o3',  isLast: true, expand: expandRows),
        ],
      ),
    );

    final header = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _loc.translate('reference'),
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          _loc.translate('diseases_tap_hint'),
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black45,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );

    if (!scrollable) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [header, Expanded(child: table)],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [header, table],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════════
  //  HELPER WIDGETS
  // ══════════════════════════════════════════════════════════════════════════════

  // ── Classification Row ────────────────────────────────────────────────────────

  /// A tappable row in the BMI reference table.
  /// Tapping navigates to [DiseasesScreen] highlighting [categoryKey].
  Widget _buildClassificationRow(
    String label,
    String range,
    Color color, {
    required String categoryKey,
    bool isLast  = false,
    bool expand  = false,
  }) {
    final row = GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DiseasesScreen(
            highlightCategoryKey: categoryKey,
            localization: _loc,
          ),
        ),
      ),
      child: Container(
        height: expand ? null : 52,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(color: Colors.black, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
            ),
            Text(
              range,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
            ),
            const SizedBox(width: 4),
            // Chevron signals the row is tappable.
            const Icon(Icons.chevron_right, size: 16, color: Colors.black38),
          ],
        ),
      ),
    );

    if (expand) return Expanded(child: row);
    return row;
  }

  // ── Gender Card ───────────────────────────────────────────────────────────────

  Widget _buildGenderCard(
    String label,
    IconData icon,
    bool selected,
    VoidCallback onTap, {
    double iconSize = 40,
    double fontSize = 14,
  }) {
    return BrutalistContainer(
      onTap: onTap,
      backgroundColor: selected ? const Color(0xFFFFDE59) : Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: Colors.black),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontWeight: FontWeight.w900, fontSize: fontSize)),
        ],
      ),
    );
  }

  // ── Counter Card ──────────────────────────────────────────────────────────────

  Widget _buildCounterCard(
    String label,
    int value,
    Function(int) onChanged, {
    String unit          = '',
    VoidCallback? onUnitTap,
  }) {
    return BrutalistContainer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('$value',
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.w900)),
                const SizedBox(width: 4),
                if (onUnitTap != null)
                  GestureDetector(
                    onTap: onUnitTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(unit,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                else
                  Text(unit,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRoundButton(Icons.remove, () => onChanged(value - 1)),
              const SizedBox(width: 32),
              _buildRoundButton(Icons.add,    () => onChanged(value + 1)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Feet formatter ────────────────────────────────────────────────────────────

  String _formatHeightInFeet(double cm) {
    double totalInches = cm / cmPerInch;
    int feet   = (totalInches / 12).floor();
    int inches = (totalInches % 12).round();
    return "$feet' $inches\"";
  }

  // ── Adaptive dialog shell ──────────────────────────────────────────────────────

  Widget _buildAdaptiveDialog(BuildContext dialogContext, Widget child) {
    final screenWidth = MediaQuery.sizeOf(dialogContext).width;
    final isTablet    = screenWidth >= _tabletBreakpoint;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: isTablet ? 480 : double.infinity),
          child: child,
        ),
      ),
    );
  }

  // ── Unit dialog ───────────────────────────────────────────────────────────────

  void _showUnitDialog(
    String title,
    List<String> options,
    String currentOption,
    Function(String) onSelected,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => _buildAdaptiveDialog(
        dialogContext,
        BrutalistContainer(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ...options.map((option) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BrutalistContainer(
                  onTap: () { onSelected(option); Navigator.pop(dialogContext); },
                  backgroundColor: option == currentOption
                      ? const Color(0xFFFFDE59) : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      Icon(option == currentOption
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off, color: Colors.black),
                      const SizedBox(width: 12),
                      Text(option, style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              )),
              const SizedBox(height: 8),
              BrutalistButton(
                label: _loc.translate('close'),
                color: const Color(0xFFD32F2F),
                onTap: () => Navigator.pop(dialogContext),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Language / settings dialog ────────────────────────────────────────────────

  /// Language picker with a "SHOW TUTORIAL" shortcut button.
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => _buildAdaptiveDialog(
        dialogContext,
        BrutalistContainer(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _loc.translate('select_language'),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Language options
              ...AppLocalization.languages.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BrutalistContainer(
                  onTap: () async {
                    await _changeLanguage(entry.key);
                    if (!dialogContext.mounted) return;
                    Navigator.pop(dialogContext);
                  },
                  backgroundColor: entry.key == _currentLang
                      ? const Color(0xFFFFDE59) : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      Icon(entry.key == _currentLang
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off, color: Colors.black),
                      const SizedBox(width: 12),
                      Text(entry.value,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              )),
              const SizedBox(height: 8),
              // "SHOW TUTORIAL" button — cyan to stand out from the language rows.
              BrutalistContainer(
                onTap: () async {
                  Navigator.pop(dialogContext); // Close dialog first
                  await _navigateToTutorial();
                },
                backgroundColor: const Color(0xFF5CE1E6),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_circle_outline,
                        color: Colors.black, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      _loc.translate('show_tutorial'),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              BrutalistButton(
                label: _loc.translate('close'),
                color: const Color(0xFFD32F2F),
                onTap: () => Navigator.pop(dialogContext),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Round +/- button ──────────────────────────────────────────────────────────

  /// A circular button used for all +/- controls in the app.
  /// Default sizes match across age, weight, and height cards.
  /// 
  /// This "custom widget factory" method demonstrates how to build reusable
  /// button patterns in Dart. Instead of repeating the same code 6+ times,
  /// we define it once and pass different icons and callbacks.
  Widget _buildRoundButton(
    IconData icon,                            // The icon to show (Icons.add or Icons.remove)
    VoidCallback onTap, {                     // Function called when tapped
    double iconSize = 24,                     // Icon size in logical pixels
    EdgeInsets padding = const EdgeInsets.all(12), // Space between border and icon
  }) {
    return GestureDetector(
      onTap: onTap,  // When user taps, call the callback function
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.black,                      // Solid black fill
          shape: BoxShape.circle,                   // Perfectly round, not rectangle
          border: Border.all(color: Colors.black, width: 2), // Dark border
        ),
        child: Icon(icon, color: Colors.white, size: iconSize), // White icon on black
      ),
    );
  }
}