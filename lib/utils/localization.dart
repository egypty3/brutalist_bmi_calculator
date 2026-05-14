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
// - Exposes a helper `isRtl` to dynamically instruct the UI to flip its layout
//   for Right-to-Left languages (currently Arabic).
//
// String Keys (grouped by feature):
//   Core UI        : title, male, female, age, weight, height, ideal, fat, ...
//   Classification : cat_vsu, cat_su, cat_u, cat_n, cat_o, cat_o1, cat_o2, cat_o3
//   Diseases screen: diseases_title, diseases_subtitle, healthy_no_risk, ...
//   Tutorial       : tut_skip, tut_next, tut_done, tut1_title … tut7_desc
// ============================================================================

/// A simple localization utility for the Brutalist BMI Calculator.
///
/// Usage:
/// ```dart
/// final loc = AppLocalization('fr');
/// loc.translate('title');  // → 'CALCULATEUR IMC'
/// loc.isRtl;               // → false
/// ```
class AppLocalization {
  /// The active BCP-47 language code ('en', 'ar', 'fr', 'de').
  final String languageCode;

  AppLocalization(this.languageCode);

  // ── String database ──────────────────────────────────────────────────────
  // Each outer key is a language code; each inner key is a UI string key.
  // All language maps must contain every key to prevent null-fallback issues.
  static const Map<String, Map<String, String>> _localizedValues = {

    // ════════════════════════════════════════════════════════════════════════
    //  ENGLISH
    // ════════════════════════════════════════════════════════════════════════
    'en': {
      // ── Core UI ──────────────────────────────────────────────────────────
      'title':           'BMI CALCULATOR',
      'male':            'MALE',
      'female':          'FEMALE',
      'age':             'AGE',
      'weight':          'WEIGHT',
      'height':          'HEIGHT',
      'ideal':           'IDEAL',
      'fat':             'FAT %',
      'enter_values':    'Enter values',
      'reference':       'CLASSIFICATION REFERENCE',
      'close':           'CLOSE',
      'weight_unit':     'WEIGHT UNIT',
      'height_unit':     'HEIGHT UNIT',
      'select_language': 'SELECT LANGUAGE',

      // ── BMI Categories ───────────────────────────────────────────────────
      'cat_vsu': 'Very Severely Underweight',
      'cat_su':  'Severely Underweight',
      'cat_u':   'Underweight',
      'cat_n':   'Normal',
      'cat_o':   'Overweight',
      'cat_o1':  'Obese Class I',
      'cat_o2':  'Obese Class II',
      'cat_o3':  'Obese Class III',

      // ── Diseases Screen ──────────────────────────────────────────────────
      'diseases_title':    'BMI HEALTH RISKS',
      'diseases_subtitle': 'what each BMI range means for your health',
      'diseases_tap_hint': 'Tap any row to explore health risks →',
      'healthy_no_risk':   'Healthy range — no elevated disease risk.',

      // ── Tutorial ─────────────────────────────────────────────────────────
      'show_tutorial': 'SHOW TUTORIAL',
      'tut_skip':      'SKIP',
      'tut_next':      'NEXT  →',
      'tut_done':      '✓  GOT IT!',

      'tut1_title': 'Welcome!',
      'tut1_desc':
          'This app calculates your Body Mass Index (BMI) to help you understand your health status. Let\'s take a quick tour of the key features.',

      'tut2_title': 'Select Your Gender',
      'tut2_desc':
          'Tap MALE or FEMALE at the top of the screen. Your gender helps produce a more accurate body fat percentage estimate.',

      'tut3_title': 'Age & Weight',
      'tut3_desc':
          'Tap the round + and − buttons to set your age and weight. Tap the KG or LB badge to switch between kilograms and pounds.',

      'tut4_title': 'Your Height',
      'tut4_desc':
          'Drag the slider or tap + / − to adjust your height. Tap the CM badge to switch between centimeters and feet + inches.',

      'tut5_title': 'Your BMI Result',
      'tut5_desc':
          'The center panel shows your BMI score and category. The left shows your ideal target weight (at BMI = 25). The right shows estimated body fat %.',

      'tut6_title': 'Classification Table',
      'tut6_desc':
          'The color-coded table shows all 8 BMI categories. Tap any row to open a detailed screen showing health risks for that category.',

      'tut7_title': 'Settings & Language',
      'tut7_desc':
          'Tap the ⋮ three-dot button in the top-right corner any time to change the app language or replay this tutorial.',
    },

    // ════════════════════════════════════════════════════════════════════════
    //  ARABIC  (Right-to-Left layout)
    // ════════════════════════════════════════════════════════════════════════
    'ar': {
      // ── Core UI ──────────────────────────────────────────────────────────
      'title':           'حاسبة مؤشر الكتلة',
      'male':            'ذكر',
      'female':          'أنثى',
      'age':             'العمر',
      'weight':          'الوزن',
      'height':          'الطول',
      'ideal':           'المثالي',
      'fat':             'الدهون %',
      'enter_values':    'أدخل القيم',
      'reference':       'مرجع التصنيفات',
      'close':           'إغلاق',
      'weight_unit':     'وحدة الوزن',
      'height_unit':     'وحدة الطول',
      'select_language': 'اختر اللغة',

      // ── BMI Categories ───────────────────────────────────────────────────
      'cat_vsu': 'نقص حاد جداً في الوزن',
      'cat_su':  'نقص حاد في الوزن',
      'cat_u':   'نقص في الوزن',
      'cat_n':   'وزن طبيعي',
      'cat_o':   'زيادة في الوزن',
      'cat_o1':  'سمنة درجة أولى',
      'cat_o2':  'سمنة درجة ثانية',
      'cat_o3':  'سمنة مفرطة',

      // ── Diseases Screen ──────────────────────────────────────────────────
      'diseases_title':    'مخاطر مؤشر الكتلة الصحية',
      'diseases_subtitle': 'ما تعنيه كل فئة لصحتك',
      'diseases_tap_hint': 'اضغط على أي صف لاستعراض المخاطر الصحية ←',
      'healthy_no_risk':   'نطاق صحي — لا مخاطر مرضية مرتفعة.',

      // ── Tutorial ─────────────────────────────────────────────────────────
      'show_tutorial': 'عرض الشرح',
      'tut_skip':      'تخطي',
      'tut_next':      'التالي  ←',
      'tut_done':      '!✓  فهمت',

      'tut1_title': '!مرحباً',
      'tut1_desc':
          'يحسب هذا التطبيق مؤشر كتلة جسمك للمساعدة في فهم حالتك الصحية. دعنا نأخذ جولة سريعة على الميزات الرئيسية.',

      'tut2_title': 'اختر جنسك',
      'tut2_desc':
          'اضغط على "ذكر" أو "أنثى" في أعلى الشاشة. يساعد الجنس في حساب نسبة الدهون الجسدية بدقة أكبر.',

      'tut3_title': 'العمر والوزن',
      'tut3_desc':
          'استخدم أزرار + و − الدائرية لضبط العمر والوزن. اضغط على شارة كغ أو رطل للتبديل بين الوحدتين.',

      'tut4_title': 'طولك',
      'tut4_desc':
          'اسحب المنزلق أو اضغط + / − لضبط طولك. اضغط على شارة سم للتبديل إلى قدم + بوصة.',

      'tut5_title': 'نتيجة مؤشر كتلتك',
      'tut5_desc':
          'يُظهر اللوح الأوسط مؤشر كتلتك وفئته. اليسار يعرض الوزن المثالي المستهدف (عند مؤشر 25). اليمين يعرض نسبة الدهون التقديرية.',

      'tut6_title': 'جدول التصنيف',
      'tut6_desc':
          'يعرض الجدول الملون ثماني فئات لمؤشر كتلة الجسم. اضغط على أي صف للانتقال إلى شاشة تعرض المخاطر الصحية لتلك الفئة.',

      'tut7_title': 'الإعدادات واللغة',
      'tut7_desc':
          'اضغط على زر النقاط الثلاث ⋮ في الزاوية العلوية اليمنى في أي وقت لتغيير لغة التطبيق أو إعادة عرض هذا الشرح.',
    },

    // ════════════════════════════════════════════════════════════════════════
    //  FRENCH
    // ════════════════════════════════════════════════════════════════════════
    'fr': {
      // ── Core UI ──────────────────────────────────────────────────────────
      'title':           'CALCULATEUR IMC',
      'male':            'HOMME',
      'female':          'FEMME',
      'age':             'ÂGE',
      'weight':          'POIDS',
      'height':          'TAILLE',
      'ideal':           'IDÉAL',
      'fat':             'GRAS %',
      'enter_values':    'Entrez les valeurs',
      'reference':       'RÉFÉRENCE DE CLASSIFICATION',
      'close':           'FERMER',
      'weight_unit':     'UNITÉ DE POIDS',
      'height_unit':     'UNITÉ DE TAILLE',
      'select_language': 'CHOISIR LA LANGUE',

      // ── BMI Categories ───────────────────────────────────────────────────
      'cat_vsu': 'Insuffisance pondérale très sévère',
      'cat_su':  'Insuffisance pondérale sévère',
      'cat_u':   'Insuffisance pondérale',
      'cat_n':   'Normal',
      'cat_o':   'Surpoids',
      'cat_o1':  'Obésité classe I',
      'cat_o2':  'Obésité classe II',
      'cat_o3':  'Obésité classe III',

      // ── Diseases Screen ──────────────────────────────────────────────────
      'diseases_title':    'RISQUES SANTÉ IMC',
      'diseases_subtitle': 'ce que chaque catégorie IMC signifie pour votre santé',
      'diseases_tap_hint': 'Appuyez sur une ligne pour voir les risques →',
      'healthy_no_risk':   'Zone saine — aucun risque élevé de maladie.',

      // ── Tutorial ─────────────────────────────────────────────────────────
      'show_tutorial': 'VOIR LE TUTORIEL',
      'tut_skip':      'IGNORER',
      'tut_next':      'SUIVANT  →',
      'tut_done':      '✓  COMPRIS !',

      'tut1_title': 'Bienvenue !',
      'tut1_desc':
          'Cette app calcule votre Indice de Masse Corporelle (IMC) pour vous aider à comprendre votre état de santé. Faisons un tour rapide des fonctionnalités.',

      'tut2_title': 'Sélectionnez votre genre',
      'tut2_desc':
          'Appuyez sur HOMME ou FEMME en haut de l\'écran. Le genre améliore la précision du calcul du taux de graisse corporelle.',

      'tut3_title': 'Âge et poids',
      'tut3_desc':
          'Appuyez sur les boutons ronds + et − pour régler l\'âge et le poids. Tapez le badge KG ou LB pour changer d\'unité.',

      'tut4_title': 'Votre taille',
      'tut4_desc':
          'Glissez le curseur ou appuyez sur + / − pour régler votre taille. Tapez le badge CM pour passer en pieds + pouces.',

      'tut5_title': 'Votre résultat IMC',
      'tut5_desc':
          'Le panneau central affiche votre IMC et catégorie. Gauche : poids cible idéal (IMC = 25). Droite : taux de graisse estimé.',

      'tut6_title': 'Tableau de classification',
      'tut6_desc':
          'Ce tableau coloré présente les 8 catégories IMC. Appuyez sur une ligne pour voir les risques santé associés à cette catégorie.',

      'tut7_title': 'Paramètres et langue',
      'tut7_desc':
          'Appuyez sur ⋮ en haut à droite pour changer de langue ou revoir ce tutoriel à tout moment.',
    },

    // ════════════════════════════════════════════════════════════════════════
    //  GERMAN
    // ════════════════════════════════════════════════════════════════════════
    'de': {
      // ── Core UI ──────────────────────────────────────────────────────────
      'title':           'BMI-RECHNER',
      'male':            'MÄNNLICH',
      'female':          'WEIBLICH',
      'age':             'ALTER',
      'weight':          'GEWICHT',
      'height':          'GRÖSSE',
      'ideal':           'IDEAL',
      'fat':             'FETT %',
      'enter_values':    'Werte eingeben',
      'reference':       'KLASSIFIZIERUNGSREFERENZ',
      'close':           'SCHLIESSEN',
      'weight_unit':     'GEWICHTSEINHEIT',
      'height_unit':     'GRÖSSENEINHEIT',
      'select_language': 'SPRACHE WÄHLEN',

      // ── BMI Categories ───────────────────────────────────────────────────
      'cat_vsu': 'Sehr starkes Untergewicht',
      'cat_su':  'Starkes Untergewicht',
      'cat_u':   'Untergewicht',
      'cat_n':   'Normal',
      'cat_o':   'Übergewicht',
      'cat_o1':  'Adipositas Klasse I',
      'cat_o2':  'Adipositas Klasse II',
      'cat_o3':  'Adipositas Klasse III',

      // ── Diseases Screen ──────────────────────────────────────────────────
      'diseases_title':    'BMI-GESUNDHEITSRISIKEN',
      'diseases_subtitle': 'was jede BMI-Kategorie für Ihre Gesundheit bedeutet',
      'diseases_tap_hint': 'Zeile antippen für Gesundheitsrisiken →',
      'healthy_no_risk':   'Gesunder Bereich — kein erhöhtes Krankheitsrisiko.',

      // ── Tutorial ─────────────────────────────────────────────────────────
      'show_tutorial': 'TUTORIAL ANZEIGEN',
      'tut_skip':      'ÜBERSPRINGEN',
      'tut_next':      'WEITER  →',
      'tut_done':      '✓  VERSTANDEN!',

      'tut1_title': 'Willkommen!',
      'tut1_desc':
          'Diese App berechnet Ihren Body-Mass-Index (BMI) um Ihnen zu helfen, Ihren Gesundheitszustand besser zu verstehen. Lassen Sie uns die Hauptfunktionen erkunden.',

      'tut2_title': 'Geschlecht auswählen',
      'tut2_desc':
          'Tippen Sie MÄNNLICH oder WEIBLICH oben auf dem Bildschirm. Das Geschlecht verbessert die Genauigkeit der Körperfettschätzung.',

      'tut3_title': 'Alter & Gewicht',
      'tut3_desc':
          'Tippen Sie auf die runden + und − Tasten um Alter und Gewicht einzustellen. Tippen Sie auf KG oder LB um die Einheit zu wechseln.',

      'tut4_title': 'Ihre Körpergröße',
      'tut4_desc':
          'Schieben Sie den Regler oder drücken Sie + / − für die Größe. Tippen auf CM wechselt zu Fuß + Zoll.',

      'tut5_title': 'Ihr BMI-Ergebnis',
      'tut5_desc':
          'Das mittlere Panel zeigt Ihren BMI und Ihre Kategorie. Links: Ideal-Zielgewicht (BMI = 25). Rechts: geschätzter Körperfettanteil.',

      'tut6_title': 'Klassifizierungstabelle',
      'tut6_desc':
          'Diese farbige Tabelle zeigt alle 8 BMI-Kategorien. Tippen Sie auf eine Zeile, um die gesundheitlichen Risiken dieser Kategorie zu sehen.',

      'tut7_title': 'Einstellungen & Sprache',
      'tut7_desc':
          'Tippen Sie auf ⋮ oben rechts, um die Sprache zu ändern oder dieses Tutorial erneut anzusehen.',
    },
  };

  // ── Public API ────────────────────────────────────────────────────────────

  /// Looks up [key] in the active language's dictionary.
  ///
  /// Falls back to English if either the language or the key is missing,
  /// which prevents a blank UI during development.
  String translate(String key) {
    return _localizedValues[languageCode]?[key]
        ?? _localizedValues['en']![key]
        ?? key; // Last resort: return the raw key instead of crashing.
  }

  /// Returns `true` if the current language is a Right-to-Left script.
  ///
  /// Used by the [Directionality] widget to mirror the layout for Arabic.
  bool get isRtl => languageCode == 'ar';

  /// All language codes the app currently supports, mapped to their native
  /// display names (shown in the language picker dialog).
  static const Map<String, String> languages = {
    'en': 'English',
    'ar': 'العربية',
    'fr': 'Français',
    'de': 'Deutsch',
  };
}
