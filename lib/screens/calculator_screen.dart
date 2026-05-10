// ============================================================================
// File: lib/screens/calculator_screen.dart
// Description: The core interface and state manager of the BMI Calculator.
//
// Architecture & State Management:
// - Stateful Widget managing user inputs (age, weight, height, gender).
// - Dynamically detects system language on startup via PlatformDispatcher.
// - Reactively updates BMI, Body Fat Percentage, and Ideal Weight upon any user input.
// - Toggles seamlessly between Imperial (lb, ft/in) and Metric (kg, cm) systems.
// - Auto-detects device type: tablet (≥600px) uses a scroll-free two-column layout;
//   phone uses the standard single-column scrollable layout.
//
// UI Components:
// - Utilizes custom `BrutalistContainer` widgets to maintain a cohesive design system.
// - Wraps the entire layout in a `Directionality` widget to support Right-to-Left (RTL)
//   languages like Arabic dynamically.
// - Contains interactive sliders, increment/decrement buttons, and a bottom sheet dialog
//   for intuitive unit and language selection.
// ============================================================================

import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/brutalist_widgets.dart';
import '../utils/bmi_logic.dart';
import '../utils/localization.dart';

/// The primary screen for the BMI Calculator.
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  int age = 25;
  double height = 170.0;
  double weight = 70.0;
  bool isMale = true;
  bool isCm = true;
  bool isKg = true;

  late String _currentLang;
  late AppLocalization _loc;

  double bmi = 0;
  String classificationKey = "cat_n";
  Color classificationColor = Colors.black;

  static const double cmPerInch = 2.54;
  static const double kgPerLb = 0.45359237;

  @override
  void initState() {
    super.initState();
    String systemLang = PlatformDispatcher.instance.locale.languageCode;
    _currentLang = AppLocalization.languages.containsKey(systemLang) ? systemLang : 'en';
    _loc = AppLocalization(_currentLang);
    _calculate();
  }

  void _calculate() {
    setState(() {
      bmi = BMICalculator.calculateBMI(height, weight);
      final result = BMICalculator.getClassification(bmi);
      classificationKey = result.key;
      classificationColor = result.color;
    });
  }

  void _changeLanguage(String langCode) {
    setState(() {
      _currentLang = langCode;
      _loc = AppLocalization(langCode);
    });
  }

  // ── Breakpoint ────────────────────────────────────────────────────────────
  static const double _tabletBreakpoint = 600;

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
      ),
    );
  }

  // ── PHONE LAYOUT (scrollable single-column) ───────────────────────────────
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

  // ── TABLET LAYOUT (two-column, no scroll) ─────────────────────────────────
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
                // Gender row — fixed height
                _genderRow(iconSize: 52, fontSize: 16),
                const SizedBox(height: 16),
                // Age + Weight — fixed height
                _ageWeightRow(),
                const SizedBox(height: 16),
                // Height — takes remaining space on left
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
                // Results dashboard — fixed height
                _resultsCard(tabletMode: true),
                const SizedBox(height: 16),
                // Classification table — fills remaining space
                Expanded(child: _classificationSection(scrollable: false)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  SHARED SECTION BUILDERS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _genderRow({double iconSize = 40, double fontSize = 14}) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildGenderCard(
              _loc.translate('male'),
              Icons.man,
              isMale,
                  () => setState(() { isMale = true; _calculate(); }),
              iconSize: iconSize,
              fontSize: fontSize,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildGenderCard(
              _loc.translate('female'),
              Icons.woman,
              !isMale,
                  () => setState(() { isMale = false; _calculate(); }),
              iconSize: iconSize,
              fontSize: fontSize,
            ),
          ),
        ),
      ],
    );
  }

  Widget _ageWeightRow() {
    return Row(
      children: [
        Expanded(
          child: _buildCounterCard(
            _loc.translate('age'),
            age,
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
              _loc.translate('weight_unit'),
              ['KG', 'LB'],
              isKg ? 'KG' : 'LB',
                  (val) => setState(() { isKg = val == 'KG'; _calculate(); }),
            ),
          ),
        ),
      ],
    );
  }

  /// [expandSlider] adds a Spacer so the slider fills vertical space on tablet.
  Widget _heightCard({bool expandSlider = false}) {
    return BrutalistContainer(
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (expandSlider) const Spacer(),
          Text(
            _loc.translate('height'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              if (isCm)
                Text(
                  height.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900),
                )
              else
                Text(
                  _formatHeightInFeet(height),
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _showUnitDialog(
                  _loc.translate('height_unit'),
                  ['CM', 'FT + IN'],
                  isCm ? 'CM' : 'FT + IN',
                      (val) => setState(() { isCm = val == 'CM'; _calculate(); }),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isCm ? 'CM' : 'FT+IN',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (expandSlider) const Spacer(),
          Slider(
            value: height,
            min: 100,
            max: 220,
            activeColor: Colors.black,
            inactiveColor: Colors.black12,
            onChanged: (val) => setState(() { height = val; _calculate(); }),
          ),
          if (expandSlider) const Spacer(),
        ],
      ),
    );
  }

  /// [tabletMode] makes the BMI number larger on tablet.
  Widget _resultsCard({bool tabletMode = false}) {
    return BrutalistContainer(
      padding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                            ? '${BMICalculator.getIdealWeightRange(height)['min']!.toStringAsFixed(1)}kg'
                            : '${(BMICalculator.getIdealWeightRange(height)['min']! / kgPerLb).toStringAsFixed(1)}lb',
                        maxLines: 1,
                        softWrap: false,
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
            Expanded(
              flex: 2,
              child: Container(
                color: const Color(0xFF5CE1E6),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('BMI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      bmi.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: tabletMode ? 64 : 48,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

  /// [scrollable] = false wraps in Expanded-friendly Column (tablet right panel).
  Widget _classificationSection({bool scrollable = true}) {
    final expandRows = !scrollable;
    final table = BrutalistContainer(
      backgroundColor: Colors.white,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _buildClassificationRow(_loc.translate('cat_vsu'), '< 16',      const Color(0xFFFF5252), expand: expandRows),
          _buildClassificationRow(_loc.translate('cat_su'),  '16 - 17',   const Color(0xFFFF7043), expand: expandRows),
          _buildClassificationRow(_loc.translate('cat_u'),   '17 - 18.5', const Color(0xFFE65100), expand: expandRows),
          _buildClassificationRow(_loc.translate('cat_n'),   '18.5 - 25', const Color(0xFF4CAF50), expand: expandRows),
          _buildClassificationRow(_loc.translate('cat_o'),   '25 - 30',   const Color(0xFFF57F17), expand: expandRows),
          _buildClassificationRow(_loc.translate('cat_o1'),  '30 - 35',   const Color(0xFFFF8A65), expand: expandRows),
          _buildClassificationRow(_loc.translate('cat_o2'),  '35 - 40',   const Color(0xFFF4511E), expand: expandRows),
          _buildClassificationRow(_loc.translate('cat_o3'),  '> 40',      const Color(0xFFD32F2F), isLast: true, expand: expandRows),
        ],
      ),
    );

    if (!scrollable) {
      // On tablet: fill remaining height without scrolling
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _loc.translate('reference'),
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Expanded(child: table),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _loc.translate('reference'),
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
        const SizedBox(height: 12),
        table,
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  HELPER WIDGETS (unchanged)
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildClassificationRow(
    String label,
    String range,
    Color color, {
    bool isLast = false,
    bool expand = false,
  }) {
    final row = Container(
      height: expand ? null : 52,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: Colors.black, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 14),
            ),
          ),
          Text(range, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
        ],
      ),
    );

    if (expand) {
      return Expanded(child: row);
    }

    return row;
  }

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

  Widget _buildCounterCard(
      String label,
      int value,
      Function(int) onChanged, {
        String unit = "",
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
                Text('$value', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
                const SizedBox(width: 4),
                if (onUnitTap != null)
                  GestureDetector(
                    onTap: onUnitTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
                      child: Text(unit, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  )
                else
                  Text(unit, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRoundButton(Icons.remove, () => onChanged(value - 1)),
              const SizedBox(width: 32),
              _buildRoundButton(Icons.add, () => onChanged(value + 1)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatHeightInFeet(double cm) {
    double totalInches = cm / cmPerInch;
    int feet = (totalInches / 12).floor();
    int inches = (totalInches % 12).round();
    return "$feet' $inches\"";
  }

  Widget _buildAdaptiveDialog(BuildContext dialogContext, Widget child) {
    final screenWidth = MediaQuery.sizeOf(dialogContext).width;
    final isTablet = screenWidth >= _tabletBreakpoint;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isTablet ? 480 : double.infinity),
          child: child,
        ),
      ),
    );
  }

  void _showUnitDialog(String title, List<String> options, String currentOption, Function(String) onSelected) {
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
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ...options.map((option) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BrutalistContainer(
                  onTap: () { onSelected(option); Navigator.pop(dialogContext); },
                  backgroundColor: option == currentOption ? const Color(0xFFFFDE59) : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      Icon(option == currentOption ? Icons.radio_button_checked : Icons.radio_button_off, color: Colors.black),
                      const SizedBox(width: 12),
                      Text(option, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
              Text(_loc.translate('select_language'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ...AppLocalization.languages.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BrutalistContainer(
                  onTap: () { _changeLanguage(entry.key); Navigator.pop(dialogContext); },
                  backgroundColor: entry.key == _currentLang ? const Color(0xFFFFDE59) : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      Icon(entry.key == _currentLang ? Icons.radio_button_checked : Icons.radio_button_off, color: Colors.black),
                      const SizedBox(width: 12),
                      Text(entry.value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildRoundButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}