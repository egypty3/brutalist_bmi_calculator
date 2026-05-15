// ============================================================================
// File: lib/utils/bmi_logic.dart
// Description: Centralized domain logic and mathematical calculations.
// 
// Clinical Formulas Implemented:
// - BMI Calculation: Weight(kg) / Height(m)^2.
// - Ideal Weight: Extrapolates weight bounds using healthy BMI thresholds (18.5 - 25.0).
// - Body Fat %: Uses the Deurenberg formula (1.20 × BMI + 0.23 × Age - 10.8 × Sex - 5.4).
// 
// Data Structures:
// - `BMICalculator`: A static utility class to prevent unnecessary instantiation.
// - `BMIResult`: A simple Data Transfer Object (DTO) binding a localization key
//   to its corresponding high-contrast UI color based on international BMI categories.
// ============================================================================

import 'package:flutter/material.dart';

/// Utility class providing core health calculation and classification logic.
/// 
/// This class encapsulates the mathematical formulas for:
/// * **BMI (Body Mass Index)**: A measure of body fat based on height and weight.
/// * **Ideal Weight**: Calculated using healthy BMI ranges (18.5 - 25.0).
/// * **Body Fat Percentage**: Estimated using a standard adult formula including age and gender.
///
/// All methods are static (no instance constructor needed).
/// Think of this as a pure math engine with no UI code — just numbers in, numbers out.
class BMICalculator {
  // Private unnamed constructor prevents anyone from creating an instance.
  // Since all methods are static, we never need an instance anyway.
  BMICalculator._();

  /// Calculates the Body Mass Index (BMI).
  /// 
  /// Formula used: `weight (kg) / [height (m)]^2`
  /// 
  /// Example: A person 170cm tall weighing 70kg:
  ///   height in meters = 170 / 100 = 1.70
  ///   BMI = 70 / (1.70 * 1.70) = 70 / 2.89 = 24.2
  ///
  /// * [heightCm]: The user's height in centimeters.
  /// * [weightKg]: The user's weight in kilograms.
  /// Returns: BMI value as a double (e.g., 24.2). Returns 0 for invalid inputs.
  static double calculateBMI(double heightCm, double weightKg) {
    // Prevent division by zero and invalid measurements.
    if (heightCm <= 0 || weightKg <= 0) return 0;
    // Convert cm to meters (e.g., 170 cm → 1.70 m)
    double heightM = heightCm / 100;
    // The core BMI formula
    return weightKg / (heightM * heightM);
  }

  /// Returns the single ideal target weight for a given height.
  ///
  /// The target is calculated as the weight at which the person's BMI
  /// equals **25.0** — the upper boundary of the "Normal" range and the
  /// natural "goal" value most people aim for.
  ///
  /// Formula: `idealWeight (kg) = 25 × [height (m)]²`
  ///
  /// * [heightCm]: The user's height in centimeters.
  /// Returns the ideal weight in kilograms.
  static double getIdealWeight(double heightCm) {
    double heightM = heightCm / 100;
    return 25.0 * (heightM * heightM);
  }

  /// Estimates the full healthy weight range for a given height.
  ///
  /// Calculates the weight at which BMI = 18.5 (lower healthy boundary)
  /// and BMI = 25.0 (upper healthy boundary / ideal target).
  ///
  /// * [heightCm]: The user's height in centimeters.
  /// Returns a map with 'min' (BMI=18.5) and 'max' (BMI=25) values in kilograms.
  static Map<String, double> getIdealWeightRange(double heightCm) {
    double heightM = heightCm / 100;
    return {
      'min': 18.5 * (heightM * heightM),
      'max': 25.0 * (heightM * heightM),
    };
  }

  /// Estimates Body Fat Percentage based on BMI, Age, and Gender.
  /// 
  /// Uses a widely recognized clinical formula for adults:
  /// `Fat% = (1.20 × BMI) + (0.23 × Age) - (10.8 × gender) - 5.4`
  /// 
  /// * [bmi]: The pre-calculated BMI value.
  /// * [age]: The user's age in years.
  /// * [isMale]: Gender flag used for the formula weight (Male = 1, Female = 0).
  static double estimateFatPercentage(double bmi, int age, bool isMale) {
    if (bmi <= 0) return 0;
    int genderVal = isMale ? 1 : 0;
    return (1.20 * bmi) + (0.23 * age) - (10.8 * genderVal) - 5.4;
  }

  /// Categorizes a BMI value into a standard health classification.
  /// 
  /// This method maps ranges to categories defined by international health standards
  /// (WHO, CDC, etc.). Each result includes a translation key and a color.
  ///
  /// Example:
  ///   BMI 15   → Very Severely Underweight (red)
  ///   BMI 22   → Normal (green)
  ///   BMI 28   → Overweight (yellow)
  ///   BMI 35   → Obese Class II (dark orange)
  ///
  /// The color is used throughout the app for consistent visual feedback.
  /// [bmi]: The BMI value to classify (typically 10–50).
  /// Returns: A BMIResult with a category key (for translation) and a color.
  static BMIResult getClassification(double bmi) {
    // Organize the ranges from least severe (underweight) to most severe (obese).
    // Each returns a BMIResult with a localization key and a color for UI display.

    // Underweight Categories (insufficient body mass)
    if (bmi < 16) return BMIResult('cat_vsu', const Color(0xFFFF5252)); // Very Severely Underweight (deep red)
    if (bmi < 17) return BMIResult('cat_su', const Color(0xFFFF7043));  // Severely Underweight (red)
    if (bmi < 18.5) return BMIResult('cat_u', const Color(0xFFE65100)); // Underweight (orange)

    // Healthy Range (target zone)
    if (bmi < 25) return BMIResult('cat_n', const Color(0xFF4CAF50));   // Normal (green)

    // Overweight & Obese Categories (excess body mass)
    if (bmi < 30) return BMIResult('cat_o', const Color(0xFFF57F17));   // Overweight (dark yellow)
    if (bmi < 35) return BMIResult('cat_o1', const Color(0xFFFF8A65));  // Obese Class I (light orange)
    if (bmi < 40) return BMIResult('cat_o2', const Color(0xFFF4511E));  // Obese Class II (dark orange)

    // Extreme Obesity (severe excess body mass)
    return BMIResult('cat_o3', const Color(0xFFD32F2F));                // Obese Class III (dark red)
  }
}

/// Data structure representing the outcome of a BMI classification.
///
/// This is a simple container (also called a "Data Transfer Object" or DTO in programming)
/// that bundles two related pieces of data: the category name and its color.
///
/// Example usage:
///   var result = BMICalculator.getClassification(22.5);
///   result.key    // → 'cat_n' (used to translate to "Normal", "Normal", "عادي", etc.)
///   result.color  // → Color(0xFF4CAF50) — green color for UI display
class BMIResult {
  /// The localization/translation key for the category name.
  /// Examples: 'cat_n' (normal), 'cat_o' (overweight), 'cat_o3' (obese class III).
  /// This key is looked up in AppLocalization to display the proper language word.
  final String key;
  
  /// The color associated with this health status.
  /// Used throughout the UI (text, backgrounds, badges) for visual consistency and quick recognition.
  /// High-contrast colors (red, orange, yellow, green) make it easy to see at a glance.
  final Color color;

  BMIResult(this.key, this.color);
}
