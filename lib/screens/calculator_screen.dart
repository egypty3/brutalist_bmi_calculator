// ============================================================================
// File: lib/screens/calculator_screen.dart
// Description: The core interface and state manager of the BMI Calculator.
// 
// Architecture & State Management:
// - Stateful Widget managing user inputs (age, weight, height, gender).
// - Dynamically detects system language on startup via PlatformDispatcher.
// - Reactively updates BMI, Body Fat Percentage, and Ideal Weight upon any user input.
// - Toggles seamlessly between Imperial (lb, ft/in) and Metric (kg, cm) systems.
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
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/brutalist_widgets.dart';
import '../utils/bmi_logic.dart';
import '../utils/localization.dart';

/// The primary screen for the BMI Calculator.
/// It manages the user interface and logic for inputting physical metrics
/// and displaying real-time health data in a Neo-Brutalist style.
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // --- State Variables for User Inputs ---
  
  /// User's age in years.
  int age = 25;
  
  /// User's height in centimeters (internal storage is always metric).
  double height = 170.0;
  
  /// User's weight in kilograms (internal storage is always metric).
  double weight = 70.0;
  
  /// Boolean flag for gender selection: true for Male, false for Female.
  bool isMale = true;

  // --- State Variables for Unit Systems ---
  
  /// Flag for height unit: true for Centimeters (CM), false for Feet + Inches (FT+IN).
  bool isCm = true;
  
  /// Flag for weight unit: true for Kilograms (KG), false for Pounds (LB).
  bool isKg = true;

  // --- State Variables for Localization ---
  
  /// Current language code (en, ar, fr, de).
  late String _currentLang;
  
  /// Localization helper instance.
  late AppLocalization _loc;

  // --- State Variables for Calculated Results ---
  
  /// Calculated Body Mass Index value.
  double bmi = 0;
  
  /// Translation key for the health category.
  String classificationKey = "cat_n";
  
  /// The color associated with the current health classification.
  Color classificationColor = Colors.black;

  // --- Physical Conversion Constants ---
  
  /// Number of centimeters in one inch.
  static const double cmPerInch = 2.54;
  
  /// Number of kilograms in one pound.
  static const double kgPerLb = 0.45359237;

  @override
  void initState() {
    super.initState();
    // Detect system language and set as default if supported
    String systemLang = PlatformDispatcher.instance.locale.languageCode;
    _currentLang = AppLocalization.languages.containsKey(systemLang) ? systemLang : 'en';
    _loc = AppLocalization(_currentLang);
    
    // Perform an initial calculation to populate results on startup.
    _calculate();
  }

  /// Recalculates all health metrics based on the current state variables.
  /// This is called every time a user interacts with any input control.
  void _calculate() {
    setState(() {
      // BMI Logic: (Weight in KG) / (Height in Meters)^2
      bmi = BMICalculator.calculateBMI(height, weight);
      
      // Fetch classification key and theme color from the logic utility
      final result = BMICalculator.getClassification(bmi);
      classificationKey = result.key;
      classificationColor = result.color;
    });
  }

  /// Switches the application language and updates the state.
  void _changeLanguage(String langCode) {
    setState(() {
      _currentLang = langCode;
      _loc = AppLocalization(langCode);
    });
  }

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
            // Language selection menu triggered by 3 dots
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () => _showLanguageDialog(),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- GENDER SELECTION SECTION ---
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildGenderCard(
                        _loc.translate('male'),
                        Icons.man,
                        isMale,
                        () => setState(() {
                          isMale = true;
                          _calculate();
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20), // Matches spacing of Age/Weight row
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildGenderCard(
                        _loc.translate('female'),
                        Icons.woman,
                        !isMale,
                        () => setState(() {
                          isMale = false;
                          _calculate();
                        }),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- AGE & WEIGHT INPUT SECTION ---
              Row(
                children: [
                  Expanded(
                    child: _buildCounterCard(
                      _loc.translate('age'),
                      age,
                      (val) => setState(() {
                        age = val;
                        _calculate();
                      }),
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
                        (val) => setState(() {
                          isKg = val == 'KG';
                          _calculate();
                        }),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- HEIGHT ADJUSTMENT SECTION ---
              BrutalistContainer(
                backgroundColor: Colors.white,
                child: Column(
                  children: [
                    Text(
                      _loc.translate('height'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
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
                            (val) => setState(() {
                              isCm = val == 'CM';
                              _calculate();
                            }),
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
                    Slider(
                      value: height,
                      min: 100,
                      max: 220,
                      activeColor: Colors.black,
                      inactiveColor: Colors.black12,
                      onChanged: (val) {
                        setState(() {
                          height = val;
                          _calculate();
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- CORE RESULTS DASHBOARD ---
              BrutalistContainer(
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
                              Text(_loc.translate('ideal'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(
                                isKg 
                                  ? '${BMICalculator.getIdealWeightRange(height)['min']!.toStringAsFixed(1)}kg'
                                  : '${(BMICalculator.getIdealWeightRange(height)['min']! / kgPerLb).toStringAsFixed(1)}lb',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
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
                              const Text(
                                'BMI',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                bmi.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900),
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
                                    fontSize: 11,
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
                              Text(_loc.translate('fat'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(
                                '${BMICalculator.estimateFatPercentage(bmi, age, isMale).toStringAsFixed(1)}%',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // --- CLASSIFICATION REFERENCE TABLE ---
              Text(
                _loc.translate('reference'),
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
              const SizedBox(height: 12),
              BrutalistContainer(
                backgroundColor: Colors.white,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildClassificationRow(_loc.translate('cat_vsu'), '< 16', const Color(0xFFFF5252)),
                    _buildClassificationRow(_loc.translate('cat_su'), '16 - 17', const Color(0xFFFF7043)),
                    _buildClassificationRow(_loc.translate('cat_u'), '17 - 18.5', const Color(0xFFE65100)),
                    _buildClassificationRow(_loc.translate('cat_n'), '18.5 - 25', const Color(0xFF4CAF50)),
                    _buildClassificationRow(_loc.translate('cat_o'), '25 - 30', const Color(0xFFF57F17)),
                    _buildClassificationRow(_loc.translate('cat_o1'), '30 - 35', const Color(0xFFFF8A65)),
                    _buildClassificationRow(_loc.translate('cat_o2'), '35 - 40', const Color(0xFFF4511E)),
                    _buildClassificationRow(_loc.translate('cat_o3'), '> 40', const Color(0xFFD32F2F), isLast: true),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper: Builds a single row in the classification guide table.
  Widget _buildClassificationRow(String label, String range, Color color, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          Text(
            range,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
          ),
        ],
      ),
    );
  }

  /// Helper: Builds a selectable Gender card (Male/Female).
  Widget _buildGenderCard(String label, IconData icon, bool selected, VoidCallback onTap) {
    return BrutalistContainer(
      onTap: onTap,
      backgroundColor: selected ? const Color(0xFFFFDE59) : Colors.white,
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.black),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// Helper: Builds a counter card with +/- controls for Age and Weight.
  Widget _buildCounterCard(String label, int value, Function(int) onChanged, {String unit = "", VoidCallback? onUnitTap}) {
    return BrutalistContainer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$value',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
              ),
              const SizedBox(width: 4),
              // If onUnitTap is provided, the unit label acts as a button
              if (onUnitTap != null)
                GestureDetector(
                  onTap: onUnitTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      unit, 
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              else
                Text(unit, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
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

  /// Utility: Converts internal height (cm) to a readable "Feet' Inches\"" string.
  String _formatHeightInFeet(double cm) {
    double totalInches = cm / cmPerInch;
    int feet = (totalInches / 12).floor();
    int inches = (totalInches % 12).round();
    return "$feet' $inches\"";
  }

  /// UI: Displays a themed Neo-Brutalist selection dialog for unit switching.
  void _showUnitDialog(String title, List<String> options, String currentOption, Function(String) onSelected) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: BrutalistContainer(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Option list generated dynamically
              ...options.map((option) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BrutalistContainer(
                  onTap: () {
                    onSelected(option);
                    Navigator.pop(context); // Close dialog on selection
                  },
                  backgroundColor: option == currentOption ? const Color(0xFFFFDE59) : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      Icon(
                        option == currentOption ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        option,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              )),
              const SizedBox(height: 8),
              // Attractive bold Close button
              BrutalistButton(
                label: _loc.translate('close'),
                color: const Color(0xFFD32F2F), // Signature Red for dismissal
                onTap: () => Navigator.pop(context),
              ).animate().fadeIn(),
            ],
          ),
        ),
      ),
    );
  }

  /// UI: Displays a themed Neo-Brutalist dialog for language selection.
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: BrutalistContainer(
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
              ...AppLocalization.languages.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BrutalistContainer(
                  onTap: () {
                    _changeLanguage(entry.key);
                    Navigator.pop(context);
                  },
                  backgroundColor: entry.key == _currentLang ? const Color(0xFFFFDE59) : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      Icon(
                        entry.key == _currentLang ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        entry.value,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              )),
              const SizedBox(height: 8),
              BrutalistButton(
                label: _loc.translate('close'),
                color: const Color(0xFFD32F2F),
                onTap: () => Navigator.pop(context),
              ).animate().fadeIn(),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper: Builds a circular button for numeric increments or decrements.
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
