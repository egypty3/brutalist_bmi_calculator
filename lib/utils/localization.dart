// ============================================================================
// File: lib/utils/localization.dart
// Description: Multi-language support and string resource management.
// 
// Supported Languages:
// - English (en), Arabic (ar), French (fr), German (de).
// 
// Design Philosophy:
// - Uses a lightweight, custom dictionary mapping rather than heavy external
//   localization dependencies (like flutter_localizations) to keep the app fast
//   and self-contained.
// - Exposes helper methods like `isRTL` to dynamically instruct the UI to flip
//   its layout for languages like Arabic.
// ============================================================================


/// A simple localization utility for the Brutalist BMI Calculator.
/// 
/// Handles translations for English, Arabic, French, and German.
/// Includes support for Right-To-Left (RTL) layouts for Arabic.
class AppLocalization {
  final String languageCode;

  AppLocalization(this.languageCode);

  /// Map of all translatable strings in the application.
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'BMI CALCULATOR',
      'male': 'MALE',
      'female': 'FEMALE',
      'age': 'AGE',
      'weight': 'WEIGHT',
      'height': 'HEIGHT',
      'ideal': 'IDEAL',
      'fat': 'FAT %',
      'enter_values': 'Enter values',
      'reference': 'CLASSIFICATION REFERENCE',
      'close': 'CLOSE',
      'weight_unit': 'WEIGHT UNIT',
      'height_unit': 'HEIGHT UNIT',
      'select_language': 'SELECT LANGUAGE',
      'cat_vsu': 'Very Severely Underweight',
      'cat_su': 'Severely Underweight',
      'cat_u': 'Underweight',
      'cat_n': 'Normal',
      'cat_o': 'Overweight',
      'cat_o1': 'Obese Class I',
      'cat_o2': 'Obese Class II',
      'cat_o3': 'Obese Class III',
    },
    'ar': {
      'title': 'حاسبة مؤشر الكتلة',
      'male': 'ذكر',
      'female': 'أنثى',
      'age': 'العمر',
      'weight': 'الوزن',
      'height': 'الطول',
      'ideal': 'المثالي',
      'fat': 'الدهون %',
      'enter_values': 'أدخل القيم',
      'reference': 'مرجع التصنيفات',
      'close': 'إغلاق',
      'weight_unit': 'وحدة الوزن',
      'height_unit': 'وحدة الطول',
      'select_language': 'اختر اللغة',
      'cat_vsu': 'نقص حاد جداً في الوزن',
      'cat_su': 'نقص حاد في الوزن',
      'cat_u': 'نقص في الوزن',
      'cat_n': 'وزن طبيعي',
      'cat_o': 'زيادة في الوزن',
      'cat_o1': 'سمنة درجة أولى',
      'cat_o2': 'سمنة درجة ثانية',
      'cat_o3': 'سمنة مفرطة',
    },
    'fr': {
      'title': 'CALCULATEUR IMC',
      'male': 'HOMME',
      'female': 'FEMME',
      'age': 'ÂGE',
      'weight': 'POIDS',
      'height': 'TAILLE',
      'ideal': 'IDÉAL',
      'fat': 'GRAS %',
      'enter_values': 'Entrez les valeurs',
      'reference': 'RÉFÉRENCE DE CLASSIFICATION',
      'close': 'FERMER',
      'weight_unit': 'UNITÉ DE POIDS',
      'height_unit': 'UNITÉ DE TAILLE',
      'select_language': 'CHOISIR LA LANGUE',
      'cat_vsu': 'Insuffisance pondérale très sévère',
      'cat_su': 'Insuffisance pondérale sévère',
      'cat_u': 'Insuffisance pondérale',
      'cat_n': 'Normal',
      'cat_o': 'Surpoids',
      'cat_o1': 'Obésité classe I',
      'cat_o2': 'Obésité classe II',
      'cat_o3': 'Obésité classe III',
    },
    'de': {
      'title': 'BMI-RECHNER',
      'male': 'MÄNNLICH',
      'female': 'WEIBLICH',
      'age': 'ALTER',
      'weight': 'GEWICHT',
      'height': 'GRÖSSE',
      'ideal': 'IDEAL',
      'fat': 'FETT %',
      'enter_values': 'Werte eingeben',
      'reference': 'KLASSIFIZIERUNGSREFERENZ',
      'close': 'SCHLIESSEN',
      'weight_unit': 'GEWICHTSEINHEIT',
      'height_unit': 'GRÖSSENEINHEIT',
      'select_language': 'SPRACHE WÄHLEN',
      'cat_vsu': 'Sehr starkes Untergewicht',
      'cat_su': 'Starkes Untergewicht',
      'cat_u': 'Untergewicht',
      'cat_n': 'Normal',
      'cat_o': 'Übergewicht',
      'cat_o1': 'Adipositas Klasse I',
      'cat_o2': 'Adipositas Klasse II',
      'cat_o3': 'Adipositas Klasse III',
    },
  };

  /// Retrieves a translated string by key.
  String translate(String key) {
    return _localizedValues[languageCode]?[key] ?? _localizedValues['en']![key]!;
  }

  /// Returns true if the current language requires RTL layout.
  bool get isRtl => languageCode == 'ar';

  /// Supported languages for the application.
  static const Map<String, String> languages = {
    'en': 'English',
    'ar': 'العربية',
    'fr': 'Français',
    'de': 'Deutsch',
  };
}
