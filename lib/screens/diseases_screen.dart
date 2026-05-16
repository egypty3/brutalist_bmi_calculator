// ============================================================================
// File: lib/screens/diseases_screen.dart
// Description: Educational screen showing health risks per BMI category.
//
// Navigation:
// - Opened when the user taps any row in the Classification Reference table
//   on the calculator screen.
// - [highlightCategoryKey] identifies which category was tapped so the screen
//   auto-scrolls to it and highlights it in a colored background.
// - Also accessible from the tutorial (page 6).
//
// UI Layout:
// - AppBar with back button and localized title.
// - Vertically scrollable list of [BrutalistContainer] cards.
// - Normal category shows a "healthy / no risk" checkmark card.
// - All other categories list bullet-point health risks from [DiseaseData].
// - Highlighted card has a tinted background and larger shadow.
// - Cards animate in with a staggered fade+slide for visual polish.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/localization.dart';
import '../utils/disease_data.dart';
import '../widgets/brutalist_widgets.dart';

// ── Internal metadata for each category ──────────────────────────────────
// Keeps all the display info for a single BMI category alongside its logic key.
// Think of this as a "mini-struct" that groups related data together.
//
// Why not use strings and ints scattered around? This class makes the code
// more organized and less error-prone (you can't accidentally mix up a color and a range).
class _CategoryMeta {
  /// The localization + disease-data key (e.g., 'cat_o1').
  /// Used to:
  ///   - Look up the category name in AppLocalization (to get translated text)
  ///   - Fetch the health risks from DiseaseData.getRisks()
  ///   - Identify which category the user tapped
  final String key;

  /// Human-readable BMI range string shown in the header badge.
  /// Examples: '< 16', '16 - 17', '18.5 - 25', '> 40'
  /// Purely for display in the UI — not used for logic.
  final String range;

  /// The official category color used throughout the app.
  /// Provides visual consistency: green (normal), orange (overweight), red (obese), etc.
  /// Same color used in the main calculator, classification table, and here.
  final Color color;

  /// True only for the 'cat_n' (normal/healthy) category.
  /// This flag determines how the card content is rendered:
  ///   - If true: show a friendly "✓ Healthy range — no elevated disease risk." message
  ///   - If false: show a bullet list of health risks
  final bool isNormal;

  const _CategoryMeta(this.key, this.range, this.color, this.isNormal);
}

/// Displays health risks associated with each BMI classification.
///
/// **How it works:**
/// - Shows all 8 BMI categories in a scrollable list.
/// - Each category card displays:
///   * Its name (e.g., "OVERWEIGHT"), color indicator, and BMI range (e.g., "25 - 30")
///   * For the normal category: a friendly "✓ Healthy range" message in green
///   * For all other categories: a bulleted list of health risks (e.g., "Increased risk of Type 2 diabetes")
///
/// **Navigation & Highlighting:**
/// - If [highlightCategoryKey] is provided (user tapped a row from the calculator),
///   the screen auto-scrolls so that specific category is visible at the top.
/// - The highlighted card gets a tinted background and larger shadow for emphasis.
///
/// **Example flow:**
/// 1. User on CalculatorScreen taps the "OVERWEIGHT" row in the classification table
/// 2. DiseasesScreen opens with highlightCategoryKey = 'cat_o'
/// 3. Page auto-scrolls to show the Overweight card prominently
/// 4. User reads: "Increased risk of Type 2 diabetes", "High blood pressure", etc.
/// 5. User taps back arrow to return to the calculator
class DiseasesScreen extends StatefulWidget {
  /// The BMI category key that the user tapped to open this screen, or null.
  ///
  /// If provided (e.g., 'cat_o'), the screen will auto-scroll to show
  /// that category and highlight it visually.
  ///
  /// If null, the screen simply shows the full list without pre-scrolling.
  final String? highlightCategoryKey;

  /// The app's current localization bundle (for translated strings and RTL layout).
  /// Ensures all category names and health risk text appear in the user's language.
  final AppLocalization localization;

  const DiseasesScreen({
    super.key,
    this.highlightCategoryKey,
    required this.localization,
  });

  @override
  State<DiseasesScreen> createState() => _DiseasesScreenState();
}

class _DiseasesScreenState extends State<DiseasesScreen> {
  // GlobalKeys map each category key to its rendered widget so we can call
  // Scrollable.ensureVisible() to jump to the highlighted card.
  final Map<String, GlobalKey> _categoryKeys = {};

  // ── Full category list (order: normal at top, then by risk severity) ────
  static const List<_CategoryMeta> _allCategories = [
    _CategoryMeta('cat_n',   '18.5 – 25', Color(0xFF4CAF50), true),
    _CategoryMeta('cat_vsu', '< 16',       Color(0xFFFF5252), false),
    _CategoryMeta('cat_su',  '16 – 17',    Color(0xFFFF7043), false),
    _CategoryMeta('cat_u',   '17 – 18.5',  Color(0xFFE65100), false),
    _CategoryMeta('cat_o',   '25 – 30',    Color(0xFFF57F17), false),
    _CategoryMeta('cat_o1',  '30 – 35',    Color(0xFFFF8A65), false),
    _CategoryMeta('cat_o2',  '35 – 40',    Color(0xFFF4511E), false),
    _CategoryMeta('cat_o3',  '> 40',       Color(0xFFD32F2F), false),
  ];

  @override
  void initState() {
    super.initState();

    // Create a GlobalKey for every category so we can query its position.
    for (final cat in _allCategories) {
      _categoryKeys[cat.key] = GlobalKey();
    }

    // After the first frame has rendered, scroll so the highlighted card
    // is visible. addPostFrameCallback() runs after build() completes.
    if (widget.highlightCategoryKey != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final key = _categoryKeys[widget.highlightCategoryKey];
        if (key?.currentContext != null) {
          // ensureVisible scrolls the nearest Scrollable ancestor just enough
          // to make the target widget fully (or mostly) visible.
          Scrollable.ensureVisible(
            key!.currentContext!,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            // alignment 0.0 = align to start, 1.0 = align to end.
            alignment: 0.2, // Show a little of the card above the highlighted one.
          );
        }
      });
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final loc = widget.localization;

    return Directionality(
      textDirection: loc.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          // Back button (uses the platform-appropriate arrow icon).
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            loc.translate('diseases_title'),
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
          ),
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Subtitle strip under the AppBar — sets context for the list.
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                loc.translate('diseases_subtitle'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            // Scrollable list of category risk cards.
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
                itemCount: _allCategories.length,
                itemBuilder: (context, index) {
                  final cat = _allCategories[index];
                  final isHighlighted =
                      cat.key == widget.highlightCategoryKey;
                  final risks = DiseaseData.getRisks(
                      cat.key, loc.languageCode);
                  return Padding(
                    // Attach the GlobalKey to the outer Padding so
                    // ensureVisible can find its render object.
                    key: _categoryKeys[cat.key],
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildCategoryCard(
                        cat, risks, isHighlighted, index, loc),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds an individual BMI category risk card.
  ///
  /// [cat]           — category metadata (key, range, color, isNormal).
  /// [risks]         — translated list of health risk strings.
  /// [isHighlighted] — if true, shows a tinted background & larger shadow.
  /// [index]         — used for staggered entry animation delay.
  /// [loc]           — localization bundle.
  Widget _buildCategoryCard(
    _CategoryMeta cat,
    List<String> risks,
    bool isHighlighted,
    int index,
    AppLocalization loc,
  ) {
    final bodyTextColor = isHighlighted ? Colors.white : const Color(0xFF1A1A1A);
    final dividerColor = isHighlighted ? Colors.white24 : Colors.black12;

    return BrutalistContainer(
      // Tint the background with a very faint version of the category color
      // to visually highlight the card the user tapped.
      // withValues() is the modern API for per-channel color manipulation.
      backgroundColor: isHighlighted
          ? cat.color.withValues(alpha: 0.12)
          : Colors.white,
      // A slightly bigger shadow further emphasizes the highlighted card.
      shadowOffset: isHighlighted ? const Offset(6, 6) : const Offset(4, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── CARD HEADER ────────────────────────────────────────────
          Row(
            children: [
              // Colored circle indicator matching the category color.
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: cat.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
              ),
              const SizedBox(width: 10),

              // Category name (translated + upper-cased).
              Expanded(
                child: Text(
                  loc.translate(cat.key).toUpperCase(),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: cat.color,
                  ),
                ),
              ),

              // BMI range badge (black pill in top-right of header).
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  cat.range,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          // Thin divider between header and risk list.
          const SizedBox(height: 10),
          Divider(color: dividerColor, height: 1),
          const SizedBox(height: 10),

          // ── RISK CONTENT ────────────────────────────────────────────
          if (cat.isNormal)
            // Normal category → green "all good" message.
            Row(
              children: [
                const Icon(Icons.check_circle_outline,
                    color: Color(0xFF4CAF50), size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    loc.translate('healthy_no_risk'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ),
              ],
            )
          else
            // Non-normal category → bullet-list of health risks.
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: risks
                  .map(
                    (risk) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Colored bullet dot (matches category color).
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: cat.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              risk,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.45,
                                color: bodyTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    )
        // Staggered entry: each card fades in slightly after the previous one.
        // index * 60ms gives a cascading waterfall effect without being slow.
        .animate()
        .fadeIn(
          duration: 400.ms,
          delay: Duration(milliseconds: index * 55),
        )
        .slideX(begin: 0.08, end: 0, curve: Curves.easeOut);
  }
}

