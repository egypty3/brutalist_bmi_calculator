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
import 'dart:math';

/// Utility class providing core health calculation and classification logic.
/// 
/// This class encapsulates the mathematical formulas for:
/// * **BMI (Body Mass Index)**: A measure of body fat based on height and weight.
/// * **Ideal Weight**: Calculated using healthy BMI ranges (18.5 - 25.0).
/// * **Body Fat Percentage**: Estimated using a standard adult formula including age and gender.
class BMICalculator {
  /// Calculates the Body Mass Index (BMI).
  /// 
  /// Formula used: `weight (kg) / [height (m)]^2`
  /// 
  /// * [heightCm]: The user's height in centimeters.
  /// * [weightKg]: The user's weight in kilograms.
  static double calculateBMI(double heightCm, double weightKg) {
    if (heightCm <= 0 || weightKg <= 0) return 0;
    double heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  /// Estimates the healthy weight range for a given height.
  /// 
  /// The "Ideal Weight" is determined by calculating the weight at which
  /// a person's BMI would be 18.5 (minimum healthy) and 25.0 (maximum healthy).
  /// 
  /// * [heightCm]: The user's height in centimeters.
  /// Returns a map with 'min' and 'max' weight values in kilograms.
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
  /// This method maps ranges to categories defined by international health standards.
  /// Each result includes a translation key and a high-contrast color for the UI.
  static BMIResult getClassification(double bmi) {
    // Underweight Categories
    if (bmi < 16) return BMIResult('cat_vsu', const Color(0xFFFF5252));
    if (bmi < 17) return BMIResult('cat_su', const Color(0xFFFF7043));
    if (bmi < 18.5) return BMIResult('cat_u', const Color(0xFFE65100)); // Darker Orange
    
    // Healthy Range
    if (bmi < 25) return BMIResult('cat_n', const Color(0xFF4CAF50));
    
    // Overweight & Obese Categories
    if (bmi < 30) return BMIResult('cat_o', const Color(0xFFF57F17)); // Darker Amber/Gold
    if (bmi < 35) return BMIResult('cat_o1', const Color(0xFFFF8A65));
    if (bmi < 40) return BMIResult('cat_o2', const Color(0xFFF4511E));
    
    // Extreme Obesity
    return BMIResult('cat_o3', const Color(0xFFD32F2F));
  }
}

/// Data structure representing the outcome of a BMI classification.
class BMIResult {
  /// The translation key for the category name (e.g., "cat_n").
  final String key;
  
  /// The specific color associated with this health status.
  final Color color;

  BMIResult(this.key, this.color);
}
