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
//
// Why a custom class? Because defining pages as plain data (not Widgets)
// keeps the code clean and makes it easy to add/remove pages.
class _TutorialPage {
  /// The icon displayed in the large brutalist box at the top of the page.
  /// Example: Icons.monitor_weight_outlined, Icons.people_alt_outlined, Icons.height
  final IconData icon;

  /// Background color of the page scaffold (alternates for visual interest).
  /// This is the big background color that fills the screen behind all content.
  final Color bgColor;

  /// Background color of the icon container (contrasts with [bgColor]).
  /// So if bgColor is yellow, iconBgColor is typically white or cyan for contrast.
  final Color iconBgColor;

  /// Localization key for the bold page title (looked up in AppLocalization).
  /// Example: 'tut1_title' → translates to 'Welcome!', '!مرحباً', 'Bienvenue !', etc.
  final String titleKey;

  /// Localization key for the description paragraph.
  /// Example: 'tut1_desc' → long sentence explaining the feature in the user's language.
  final String descKey;

  /// Accent icon shown above the tutorial message card (decorative).
  /// Example: Icons.waving_hand_rounded, Icons.people_alt_rounded, Icons.language_rounded
  final IconData messageIcon;

  /// Accent color used for the message icon/badge (the small circle above text).
  /// Helps make the message card stand out visually.
  final Color messageAccentColor;

  const _TutorialPage({
    required this.icon,
    required this.bgColor,
    required this.iconBgColor,
    required this.titleKey,
    required this.descKey,
    required this.messageIcon,
    required this.messageAccentColor,
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
  // the "Next" button is tapped, or skip to a specific page.
  // (Without storing it, we'd have to rely only on user swipes.)
  final PageController _pageController = PageController();

  // Tracks which page (0-based index) is currently visible.
  // When the user swipes or taps "Next", this number updates.
  // State updates trigger a setState() so the dots and button label re-render.
  // Pages are numbered: 0 (Welcome), 1 (Gender), 2 (Age & Weight), ..., 6 (Settings)
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
      messageIcon: Icons.waving_hand_rounded,
      messageAccentColor: Color(0xFF5CE1E6),
    ),
    // Page 2 — Gender selection
    _TutorialPage(
      icon: Icons.people_alt_outlined,
      bgColor: Colors.white,
      iconBgColor: Color(0xFF5CE1E6), // Brand cyan
      titleKey: 'tut2_title',
      descKey: 'tut2_desc',
      messageIcon: Icons.people_alt_rounded,
      messageAccentColor: Color(0xFFFFDE59),
    ),
    // Page 3 — Age & Weight
    _TutorialPage(
      icon: Icons.tune,
      bgColor: Color(0xFFFFDE59),
      iconBgColor: Colors.white,
      titleKey: 'tut3_title',
      descKey: 'tut3_desc',
      messageIcon: Icons.balance_rounded,
      messageAccentColor: Color(0xFF5CE1E6),
    ),
    // Page 4 — Height
    _TutorialPage(
      icon: Icons.height,
      bgColor: Color(0xFF5CE1E6),
      iconBgColor: Colors.white,
      titleKey: 'tut4_title',
      descKey: 'tut4_desc',
      messageIcon: Icons.straighten_rounded,
      messageAccentColor: Color(0xFFFFDE59),
    ),
    // Page 5 — Results card
    _TutorialPage(
      icon: Icons.analytics_outlined,
      bgColor: Colors.white,
      iconBgColor: Color(0xFFFFDE59),
      titleKey: 'tut5_title',
      descKey: 'tut5_desc',
      messageIcon: Icons.insights_rounded,
      messageAccentColor: Color(0xFF5CE1E6),
    ),
    // Page 6 — Classification table
    _TutorialPage(
      icon: Icons.table_chart_outlined,
      bgColor: Color(0xFFFFDE59),
      iconBgColor: Color(0xFF5CE1E6),
      titleKey: 'tut6_title',
      descKey: 'tut6_desc',
      messageIcon: Icons.touch_app_rounded,
      messageAccentColor: Colors.white,
    ),
    // Page 7 — Settings & language
    _TutorialPage(
      icon: Icons.settings_outlined,
      bgColor: Color(0xFF5CE1E6),
      iconBgColor: Colors.white,
      titleKey: 'tut7_title',
      descKey: 'tut7_desc',
      messageIcon: Icons.language_rounded,
      messageAccentColor: Color(0xFFFFDE59),
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
                          color: Colors.black87,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
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
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
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
                          width: i == _currentPage ? 34 : 10,
                          height: 10,
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
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── ICON BOX ────────────────────────────────────────────────
          // The BrutalistContainer provides the bold-bordered hard-shadow look.
          // flutter_animate adds the elastic scale-in and shimmer on first render.
          BrutalistContainer(
            backgroundColor: page.iconBgColor,
            padding: const EdgeInsets.all(28),
            child: Icon(page.icon, size: 92, color: Colors.black),
          )
              .animate()
              .scale(
                duration: 550.ms,
                curve: Curves.elasticOut, // Bouncy "pop" effect
              )
              .shimmer(delay: 700.ms, duration: 1000.ms),

          const SizedBox(height: 36),

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
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.4,
                color: Colors.black,
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 200.ms)
              .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),

          const SizedBox(height: 20),

          // ── DESCRIPTION ────────────────────────────────────────────
          // Slightly muted color (black87) keeps focus on the title without
          // losing legibility. Line height 1.5 improves readability on mobile.
          BrutalistContainer(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: page.messageAccentColor,
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(page.messageIcon, color: Colors.black, size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  loc.translate(page.descKey),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    height: 1.65,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.12, end: 0),
        ],
      ),
    );
  }
}

