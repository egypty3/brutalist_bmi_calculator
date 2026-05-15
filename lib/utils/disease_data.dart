// ============================================================================
// File: lib/utils/disease_data.dart
// Description: Static database of health risks associated with each BMI category.
//
// Structure:
// - Top-level class `DiseaseData` with a single static method `getRisks`.
// - Data is stored as a nested Map: outer key = BMI category key (matches
//   localization keys), inner key = language code, value = list of risk strings.
// - Calling `getRisks('cat_o', 'fr')` returns the French risk list for Overweight.
// - If the requested language has no data, the method falls back to English ('en').
// ============================================================================

/// Provides translated lists of health risks for each non-normal BMI category.
///
/// **What this does:**
/// This is a pure data class — it has no constructor, no state, and no UI code.
/// It is used exclusively by [DiseasesScreen] to populate the risk bullet points
/// that users see when they tap a category.
///
/// **Data structure:**
/// ```
/// DiseaseData._risks = {
///   'cat_vsu': {  // Very Severely Underweight category
///     'en': ['Organ failure due to...', 'Severe malnutrition...', ...],
///     'ar': ['فشل الأعضاء...', 'سوء التغذية...', ...],
///     'fr': ['Défaillance organique...', 'Malnutrition s��vère...', ...],
///     'de': ['Organversagen...', 'Schwere Mangelernährung...', ...],
///   },
///   'cat_su': { ... },
///   ...
/// }
/// ```
///
/// **How to use:**
/// ```dart
/// List<String> risks = DiseaseData.getRisks('cat_o', 'fr');
/// // → French risks for Overweight category
/// // → ['Risque accru de diabète de type 2', 'Hypertension artérielle', ...]
/// ```
///
/// **Language fallback:**
/// If a language code has no data for a category, the method falls back to English.
/// This ensures we never return null or crash — the UI just shows English text instead.
///
/// **Note:** The 'cat_n' (Normal) category has no entry because healthy people have no risks!
class DiseaseData {
  // Private constructor prevents anyone from creating an instance of this class.
  // All data is accessed through the static [getRisks] method below.
  DiseaseData._();

  // ── Internal data store ───────────────────────────────────────────────────
  // Structure: { categoryKey: { languageCode: [ riskString, ... ] } }
  // Each inner list should have 4-6 concise risk items for best UI fit.
  static const Map<String, Map<String, List<String>>> _risks = {
    // ── VERY SEVERELY UNDERWEIGHT (BMI < 16) ────────────────────────────────
    'cat_vsu': {
      'en': [
        'Organ failure due to extreme nutrient deprivation',
        'Severe malnutrition & electrolyte imbalance',
        'Cardiac arrest risk from heart-muscle wasting',
        'Severely compromised immune system',
        'Bone fractures from extreme density loss',
        'Infertility & hormonal shutdown',
      ],
      'ar': [
        'فشل الأعضاء بسبب الحرمان الشديد من المغذيات',
        'سوء التغذية الحاد واختلال الشوارد الكهربائية',
        'خطر توقف القلب من ضمور عضلة القلب',
        'ضعف حاد في الجهاز المناعي',
        'كسور العظام بسبب الفقدان الشديد لكثافتها',
        'العقم وتوقف الجهاز الهرموني',
      ],
      'fr': [
        'Défaillance organique par privation extrême de nutriments',
        'Malnutrition sévère et déséquilibre électrolytique',
        'Risque d\'arrêt cardiaque par fonte musculaire cardiaque',
        'Système immunitaire gravement compromis',
        'Fractures osseuses par perte extrême de densité',
        'Infertilité et arrêt hormonal',
      ],
      'de': [
        'Organversagen durch extremen Nährstoffentzug',
        'Schwere Mangelernährung & Elektrolyt-Ungleichgewicht',
        'Herzstillstandsrisiko durch Herzmuskelabbau',
        'Schwer beeinträchtigtes Immunsystem',
        'Knochenbrüche durch extremen Dichtigkeitsverlust',
        'Unfruchtbarkeit & hormoneller Zusammenbruch',
      ],
    },

    // ── SEVERELY UNDERWEIGHT (BMI 16–17) ────────────────────────────────────
    'cat_su': {
      'en': [
        'Severe malnutrition with vitamin & mineral deficiencies',
        'Anemia (iron & B12 deficiency)',
        'Osteoporosis and stress fracture risk',
        'Hormonal imbalance affecting menstrual cycles & fertility',
        'Significant muscle wasting',
        'Weakened heart muscle and irregular heartbeat',
      ],
      'ar': [
        'سوء تغذية شديد مع نقص الفيتامينات والمعادن',
        'فقر الدم (نقص الحديد وفيتامين ب12)',
        'هشاشة العظام وخطر كسور الإجهاد',
        'اختلال هرموني يؤثر على الدورة الشهرية والخصوبة',
        'ضمور عضلي ملحوظ',
        'ضعف عضلة القلب واضطراب النبض',
      ],
      'fr': [
        'Malnutrition sévère avec carences en vitamines et minéraux',
        'Anémie (carence en fer et B12)',
        'Ostéoporose et risque de fractures de stress',
        'Déséquilibre hormonal affectant cycles et fertilité',
        'Fonte musculaire significative',
        'Cœur affaibli et arythmie cardiaque',
      ],
      'de': [
        'Schwere Mangelernährung mit Vitamin- & Mineralstoffmangel',
        'Anämie (Eisen- & B12-Mangel)',
        'Osteoporose und Stressfrakturrisiko',
        'Hormonelles Ungleichgewicht mit Auswirkungen auf Zyklus & Fruchtbarkeit',
        'Erheblicher Muskelschwund',
        'Geschwächter Herzmuskel und unregelmäßiger Herzschlag',
      ],
    },

    // ── UNDERWEIGHT (BMI 17–18.5) ────────────────────────────────────────────
    'cat_u': {
      'en': [
        'Iron-deficiency anemia causing fatigue',
        'Nutrient deficiencies (vitamins D, B12, calcium)',
        'Weakened immune system — frequent illness',
        'Reduced bone mineral density',
        'Difficulty concentrating and low energy levels',
      ],
      'ar': [
        'فقر الدم بسبب نقص الحديد مما يسبب التعب',
        'نقص المغذيات (فيتامين د، ب12، الكالسيوم)',
        'ضعف الجهاز المناعي — الإصابة المتكررة بالأمراض',
        'انخفاض كثافة معادن العظام',
        'صعوبة التركيز وانخفاض مستوى الطاقة',
      ],
      'fr': [
        'Anémie ferriprive causant de la fatigue',
        'Carences nutritionnelles (vitamines D, B12, calcium)',
        'Système immunitaire affaibli — maladies fréquentes',
        'Densité minérale osseuse réduite',
        'Difficultés de concentration et faiblesse',
      ],
      'de': [
        'Eisenmangelanämie mit Erschöpfung',
        'Nährstoffmangel (Vitamin D, B12, Kalzium)',
        'Geschwächtes Immunsystem — häufige Erkrankungen',
        'Reduzierte Knochenmineraldichte',
        'Konzentrationsschwierigkeiten und niedrige Energie',
      ],
    },

    // ── OVERWEIGHT (BMI 25–30) ───────────────────────────────────────────────
    'cat_o': {
      'en': [
        'Increased risk of Type 2 diabetes',
        'High blood pressure (hypertension)',
        'Elevated cardiovascular disease risk',
        'Sleep apnea and breathing difficulties',
        'Joint pain, especially in knees and hips',
        'Higher risk of fatty liver disease',
      ],
      'ar': [
        'زيادة خطر الإصابة بالسكري من النوع 2',
        'ضغط الدم المرتفع',
        'ارتفاع خطر أمراض القلب والأوعية الدموية',
        'انقطاع التنفس أثناء النوم وصعوبات التنفس',
        'آلام المفاصل، خاصة في الركبتين والوركين',
        'خطر أعلى للإصابة بالكبد الدهني',
      ],
      'fr': [
        'Risque accru de diabète de type 2',
        'Hypertension artérielle',
        'Risque cardiovasculaire élevé',
        'Apnée du sommeil et difficultés respiratoires',
        'Douleurs articulaires (genoux et hanches)',
        'Risque accru de stéatose hépatique',
      ],
      'de': [
        'Erhöhtes Typ-2-Diabetes-Risiko',
        'Bluthochdruck (Hypertonie)',
        'Erhöhtes Herz-Kreislauf-Erkrankungs­risiko',
        'Schlafapnoe und Atemschwierigkeiten',
        'Gelenkschmerzen, besonders Knie und Hüften',
        'Höheres Risiko einer Fettleber',
      ],
    },

    // ── OBESE CLASS I (BMI 30–35) ────────────────────────────────────────────
    'cat_o1': {
      'en': [
        'Type 2 diabetes (significantly elevated risk)',
        'Heart disease and coronary artery narrowing',
        'Non-alcoholic fatty liver disease (NAFLD)',
        'Obstructive sleep apnea',
        'Increased stroke risk',
        'Osteoarthritis and chronic joint pain',
      ],
      'ar': [
        'السكري من النوع 2 (خطر مرتفع بشكل ملحوظ)',
        'أمراض القلب وتضيق الشرايين التاجية',
        'مرض الكبد الدهني غير الكحولي',
        'انقطاع التنفس الانسدادي',
        'زيادة خطر السكتة الدماغية',
        'التهاب المفاصل العظمي وآلام المفاصل المزمنة',
      ],
      'fr': [
        'Diabète de type 2 (risque significativement élevé)',
        'Maladie cardiaque et rétrécissement coronarien',
        'Stéatohépatite non alcoolique (NASH)',
        'Apnée obstructive du sommeil',
        'Risque accru d\'AVC',
        'Arthrose et douleurs articulaires chroniques',
      ],
      'de': [
        'Typ-2-Diabetes (deutlich erhöhtes Risiko)',
        'Herzerkrankung und Koronarstenose',
        'Nicht-alkoholische Fettleber (NAFLD)',
        'Obstruktive Schlafapnoe',
        'Erhöhtes Schlaganfallrisiko',
        'Arthrose und chronische Gelenkschmerzen',
      ],
    },

    // ── OBESE CLASS II (BMI 35–40) ───────────────────────────────────────────
    'cat_o2': {
      'en': [
        'Severe cardiovascular disease risk',
        'High stroke probability',
        'Advanced Type 2 diabetes complications',
        'Elevated cancer risk (colon, breast, kidney)',
        'Severe obstructive sleep apnea',
        'Chronic kidney disease risk',
      ],
      'ar': [
        'خطر شديد للأمراض القلبية الوعائية',
        'احتمال مرتفع للسكتة الدماغية',
        'مضاعفات متقدمة لداء السكري من النوع 2',
        'ارتفاع خطر السرطان (القولون، الثدي، الكلى)',
        'انقطاع التنفس الانسدادي الشديد',
        'خطر الإصابة بأمراض الكلى المزمنة',
      ],
      'fr': [
        'Risque cardiovasculaire sévère',
        'Probabilité élevée d\'AVC',
        'Complications avancées du diabète de type 2',
        'Risque élevé de cancer (côlon, sein, rein)',
        'Apnée sévère du sommeil',
        'Risque de maladie rénale chronique',
      ],
      'de': [
        'Schweres Herz-Kreislauf-Erkrankungs­risiko',
        'Hohe Schlaganfallwahrscheinlichkeit',
        'Fortgeschrittene Typ-2-Diabetes-Komplikationen',
        'Erhöhtes Krebsrisiko (Darm, Brust, Niere)',
        'Schwere obstruktive Schlafapnoe',
        'Chronisches Nierenerkrankungs­risiko',
      ],
    },

    // ── OBESE CLASS III (BMI > 40) ───────────────────────────────────────────
    'cat_o3': {
      'en': [
        'Extremely high risk of fatal heart disease',
        'Very high stroke & blood clot risk',
        'Severe, life-threatening diabetes complications',
        'Multiple organ strain (heart, kidneys, liver)',
        'Respiratory failure and sleep apnea',
        'Significantly reduced life expectancy',
      ],
      'ar': [
        'خطر مرتفع جداً لأمراض القلب المميتة',
        'خطر شديد جداً للسكتة الدماغية والجلطات الدموية',
        'مضاعفات قاتلة للسكري',
        'إجهاد متعدد الأعضاء (القلب، الكلى، الكبد)',
        'فشل تنفسي وانقطاع التنفس الحاد',
        'انخفاض ملحوظ جداً في متوسط العمر المتوقع',
      ],
      'fr': [
        'Risque extrêmement élevé de maladie cardiaque mortelle',
        'Risque très élevé d\'AVC et de caillots sanguins',
        'Complications diabétiques graves potentiellement mortelles',
        'Sollicitation multi-organes (cœur, reins, foie)',
        'Insuffisance respiratoire et apnée sévère',
        'Espérance de vie significativement réduite',
      ],
      'de': [
        'Extrem hohes Risiko tödlicher Herzerkrankung',
        'Sehr hohes Schlaganfall- und Thromboserisiko',
        'Schwere, lebensbedrohliche Diabetes-Komplikationen',
        'Multi-Organ-Belastung (Herz, Nieren, Leber)',
        'Atemversagen und schwere Schlafapnoe',
        'Erheblich verkürzte Lebenserwartung',
      ],
    },
  };

  /// Returns the list of health risk strings for [categoryKey] in [languageCode].
  ///
  /// **Algorithm:**
  /// 1. Look up the category in `_risks` (e.g., 'cat_o1')
  /// 2. If the category doesn't exist, return an empty list (e.g., 'cat_n' — no risks)
  /// 3. If the category exists, look for the language (e.g., 'fr' for French)
  /// 4. If the language has no data, fall back to English ('en')
  /// 5. Return the list of risk strings, or an empty list if nothing is found
  ///
  /// **Returns:**
  /// A list of translated health risk descriptions, or an empty list if:
  ///   - The category doesn't exist (category known to have no risks)
  ///   - Neither the requested language nor English have data (shouldn't happen)
  ///
  /// **Examples:**
  /// ```dart
  /// DiseaseData.getRisks('cat_o', 'fr')
  /// // → ['Risque accru de diabète de type 2', 'Hypertension artérielle', ...]
  ///
  /// DiseaseData.getRisks('cat_n', 'en')
  /// // → [] (empty list — normal category has no risks)
  ///
  /// DiseaseData.getRisks('cat_o1', 'xx')  // 'xx' not supported
  /// // → English version is used as fallback
  /// ```
  static List<String> getRisks(String categoryKey, String languageCode) {
    // Try to find this category in our data
    final categoryData = _risks[categoryKey];
    if (categoryData == null) return []; // No data for this category (e.g., 'cat_n')

    // Try to find the language, or fall back to English
    return categoryData[languageCode] ?? categoryData['en'] ?? [];
  }
}

