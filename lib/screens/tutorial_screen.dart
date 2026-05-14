// ============================================================================
// File: lib/screens/tutorial_screen.dart
// Description: Animated first-launch tutorial walkthrough screen.
//
// Features:
// - 7 swipeable pages — each explaining one core feature of the app.
// - Neo-Brutalist visual style consistent with the rest of the app.
// - Animated icon entry (scale bounce + fade) using flutter_animate.
// - Page indicator: an expanding pill-dot shows the current step.
// - "Skip" button top-left to exit at any time.
// - "Next →" / "✓ Got It!" button at the bottom (last page changes label).
// - Accepts an [AppLocalization] so all text follows the current language.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/localization.dart';
import '../widgets/brutalist_widgets.dart';

// ── Internal data model ───────────────────────────────────────────────────
// This private class stores everything needed to render one tutorial page.
// It is 'const' which makes it very efficient — Flutter won't rebuild it.
class _TutorialPage {
  /// The icon displayed in the large brutalist box.
  final IconData icon;

  /// Background color of the page scaffold (alternates for visual interest).
  final Color bgColor;

  /// Background color of the icon container (contrasts with [bgColor]).
  final Color iconBgColor;

  /// Localization key for the bold page title (looked up in AppLocalization).
  final String titleKey;

  /// Localization key for the description paragraph.
  final String descKey;

  const _TutorialPage({
    required this.icon,
    required this.bgColor,
    required this.iconBgColor,
    required this.titleKey,
    required this.descKey,
  });
}

/// The full-screen animated tutorial that plays on the app's first launch.
///
/// It is pushed onto the navigation stack by [CalculatorScreen] after confirming
/// (via [SharedPreferences]) that the user has not yet seen it.
/// Completing or skipping the tutorial pops this route, returning to the calculator.
///
/// [localization] must be provided so all strings appear in the user's chosen language.
class TutorialScreen extends StatefulWidget {
  /// The app's current localization bundle.
  final AppLocalization localization;

  const TutorialScreen({super.key, required this.localization});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  // PageController manages the swipeable PageView.
  // We hold a reference so we can programmatically jump to the next page when
  // the "Next" button is tapped.
  final PageController _pageController = PageController();

  // Tracks which page (0-based index) is currently visible.
  // State updates trigger a setState() so the dots and button label re-render.
  int _currentPage = 0;

  // ── Tutorial page definitions ────────────────────────────────────────────
  // 7 pages: one for each major feature of the BMI calculator.
  // Colors alternate between the three brand colors: yellow, cyan, white.
  static const List<_TutorialPage> _pages = [
    // Page 1 — Welcome
    _TutorialPage(
      icon: Icons.monitor_weight_outlined,
      bgColor: Color(0xFFFFDE59),   // Brand yellow
      iconBgColor: Colors.white,
      titleKey: 'tut1_title',
      descKey: 'tut1_desc',
    ),
    // Page 2 — Gender selection
    _TutorialPage(
      icon: Icons.people_alt_outlined,
      bgColor: Colors.white,
      iconBgColor: Color(0xFF5CE1E6), // Brand cyan
      titleKey: 'tut2_title',
      descKey: 'tut2_desc',
    ),
    // Page 3 — Age & Weight
    _TutorialPage(
      icon: Icons.tune,
      bgColor: Color(0xFFFFDE59),
      iconBgColor: Colors.white,
      titleKey: 'tut3_title',
      descKey: 'tut3_desc',
    ),
    // Page 4 — Height
    _TutorialPage(
      icon: Icons.height,
      bgColor: Color(0xFF5CE1E6),
      iconBgColor: Colors.white,
      titleKey: 'tut4_title',
      descKey: 'tut4_desc',
    ),
    // Page 5 — Results card
    _TutorialPage(
      icon: Icons.analytics_outlined,
      bgColor: Colors.white,
      iconBgColor: Color(0xFFFFDE59),
      titleKey: 'tut5_title',
      descKey: 'tut5_desc',
    ),
    // Page 6 — Classification table
    _TutorialPage(
      icon: Icons.table_chart_outlined,
      bgColor: Color(0xFFFFDE59),
      iconBgColor: Color(0xFF5CE1E6),
      titleKey: 'tut6_title',
      descKey: 'tut6_desc',
    ),
    // Page 7 — Settings & language
    _TutorialPage(
      icon: Icons.settings_outlined,
      bgColor: Color(0xFF5CE1E6),
      iconBgColor: Colors.white,
      titleKey: 'tut7_title',
      descKey: 'tut7_desc',
    ),
  ];

  @override
  void dispose() {
    // Always dispose controllers to avoid memory leaks.
    _pageController.dispose();
    super.dispose();
  }

  // ── Navigation logic ─────────────────────────────────────────────────────

  /// Advances to the next page, or pops back to the calculator on the last page.
  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      // Animate smoothly to the next page.
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Last page — the user has seen the whole tutorial.
      Navigator.of(context).pop();
    }
  }

  /// Immediately closes the tutorial without completing it.
  void _skip() => Navigator.of(context).pop();

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final loc = widget.localization;

    // Determine whether we're on the final page to change the action button label.
    final bool isLastPage = _currentPage == _pages.length - 1;

    return Directionality(
      // Respect RTL languages (e.g., Arabic).
      textDirection: loc.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        // The scaffold background animates between page colors via AnimatedContainer.
        backgroundColor: _pages[_currentPage].bgColor,
        body: SafeArea(
          child: Column(
            children: [
              // ── TOP BAR ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Skip button — always visible, lets user exit early.
                    TextButton(
                      onPressed: _skip,
                      child: Text(
                        loc.translate('tut_skip'),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    // Page counter badge: "3 / 7"
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_currentPage + 1} / ${_pages.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── PAGE CONTENT ─────────────────────────────────────────
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  // Called every time the user swipes or we call nextPage().
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPageContent(_pages[index], loc);
                  },
                ),
              ),

              // ── BOTTOM CONTROLS ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
                child: Column(
                  children: [
                    // Dot progress indicator.
                    // The active dot expands to a pill shape; inactive dots are small circles.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pages.length, (i) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == _currentPage ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == _currentPage
                                ? Colors.black
                                : Colors.black26,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),

                    // Action button — label changes on final page.
                    BrutalistButton(
                      label: isLastPage
                          ? loc.translate('tut_done')
                          : loc.translate('tut_next'),
                      // Cyan on last page signals "completion"; yellow means "keep going".
                      color: isLastPage
                          ? const Color(0xFF5CE1E6)
                          : const Color(0xFFFFDE59),
                      onTap: _nextPage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the content for a single tutorial page.
  ///
  /// Layout (top to bottom):
  /// 1. Large icon in a [BrutalistContainer] with a bounce-in animation.
  /// 2. Bold title on a colored strip.
  /// 3. Descriptive text paragraph.
  Widget _buildPageContent(_TutorialPage page, AppLocalization loc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── ICON BOX ────────────────────────────────────────────────
          // The BrutalistContainer provides the bold-bordered hard-shadow look.
          // flutter_animate adds the elastic scale-in and shimmer on first render.
          BrutalistContainer(
            backgroundColor: page.iconBgColor,
            padding: const EdgeInsets.all(24),
            child: Icon(page.icon, size: 80, color: Colors.black),
          )
              .animate()
              .scale(
                duration: 550.ms,
                curve: Curves.elasticOut, // Bouncy "pop" effect
              )
              .shimmer(delay: 700.ms, duration: 1000.ms),

          const SizedBox(height: 32),

          // ── TITLE ──────────────────────────────────────────────────
          // The title sits on a colored pill/strip so it always stands out,
          // regardless of the page background color.
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: page.iconBgColor, // Contrasting color for the strip
              border: Border.all(color: Colors.black, width: 3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              loc.translate(page.titleKey),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 200.ms)
              .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),

          const SizedBox(height: 24),

          // ── DESCRIPTION ────────────────────────────────────────────
          // Slightly muted color (black87) keeps focus on the title without
          // losing legibility. Line height 1.5 improves readability on mobile.
          Text(
            loc.translate(page.descKey),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              height: 1.6,
            ),
          ).animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }
}

