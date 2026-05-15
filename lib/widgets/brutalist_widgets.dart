// ============================================================================
// File: lib/widgets/brutalist_widgets.dart
// Description: Reusable UI components defining the application's visual identity.
// 
// Neo-Brutalist Design System:
// - This file encapsulates the core styling rules of Brutalism on the web/mobile.
// - `BrutalistContainer`: The foundational building block. It uses a Stack to separate
//   a purely black shadow box from the foreground content box, creating an artificial,
//   harsh 3D depth effect (offset by dx/dy).
// - `BrutalistButton`: An interactive extension that handles tap states. It includes
//   dynamic text color inversion (switching to white text if the button background
//   is black) to guarantee legibility across themes.
// ============================================================================

import 'package:flutter/material.dart';

/// A custom container that implements the Neo-Brutalist design style.
/// 
/// **What is Neo-Brutalism?**
/// Neo-Brutalism is a design movement that brings the stark, geometric aesthetic
/// of Brutalist architecture (think concrete, geometric shapes, raw materials)
/// to digital interfaces. Key characteristics:
/// * **Hard Shadows**: Solid black boxes offset from the content (fake 3D effect).
/// * **Thick Borders**: Bold, visible black outlines create strong definition.
/// * **High Contrast**: Clean, bold colors without gradients or soft shadows.
/// * **Raw, Geometric**: Everything is deliberately angular and unrefined-looking.
///
/// This container achieves the look by:
/// 1. Creating an invisible shadow box positioned slightly down-right.
/// 2. Stacking the visible content box on top of it.
/// 3. Adding a thick black border around everything.
///
/// The result: a distinctive "punched out" or "stamped" appearance.
class BrutalistContainer extends StatelessWidget {
  /// The main content of the container — can be text, icons, buttons, or any widget.
  final Widget child;
  
  /// The fill color for the content layer.
  /// Examples: Colors.white (default), Colors.yellow (#FFDE59), Colors.cyan (#5CE1E6).
  final Color backgroundColor;
  
  /// The corner radius for the box (0 = sharp corners, 12 = slightly rounded, 20 = very rounded).
  /// Applied to both the shadow layer and the content layer so they align perfectly.
  final double borderRadius;
  
  /// The thickness of the black border (in logical pixels).
  /// Defaults to 3px — thin enough for normal use, thick enough to be clearly visible.
  final double borderWidth;
  
  /// The (x, y) distance the shadow is offset. Defaults to (4, 4).
  /// Positive values move the shadow right and down, creating that "popped out" effect.
  /// Try [const Offset(6, 6)] for a more dramatic shadow, or [const Offset(2, 2)] for subtle.
  final Offset shadowOffset;
  
  /// Internal spacing between the border and the [child] content.
  /// Defaults to all(16) = 16 pixels on all sides. Change for more/less breathing room.
  final EdgeInsets padding;
  
  /// Optional tap interaction. If provided, the container becomes tappable.
  /// When tapped, the callback [onTap] is executed. If null, the container is not interactive.
  final VoidCallback? onTap;

  const BrutalistContainer({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.borderRadius = 12.0,
    this.borderWidth = 3.0,
    this.shadowOffset = const Offset(4, 4),
    this.padding = const EdgeInsets.all(16.0),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,  // If onTap is set, this makes the container respond to taps
      child: Stack(
        // Stack layers the shadow behind the content
        children: [
          // --- SHADOW LAYER (bottom, invisible) ---
          // This black box is positioned offset from the content box.
          // It's invisible (see the `child` with opacity 0) but takes up space
          // to ensure the shadow box is exactly the same size as the content.
          Container(
            // Shift this layer right and down by [shadowOffset]
            // E.g., shadowOffset = (4, 4) means "move 4px right, 4px down"
            margin: EdgeInsets.only(left: shadowOffset.dx, top: shadowOffset.dy),
            decoration: BoxDecoration(
              color: Colors.black,  // Solid black for the shadow
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            // The shadow container must match the size of the content content.
            // We use an invisible [child] inside to ensure identical dimensions.
            child: Opacity(opacity: 0, child: Padding(padding: padding, child: child)),
          ),
          
          // --- CONTENT LAYER (top, visible) ---
          // The visible part of the widget with the background color and border.
          Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor,  // Fill color (white, yellow, cyan, etc.)
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: Colors.black, width: borderWidth),  // Bold black outline
            ),
            child: child,  // Display the actual content here
          ),
        ],
      ),
    );
  }
}

/// A specialized button widget pre-styled with Neo-Brutalist aesthetics.
/// 
/// This widget wraps a [BrutalistContainer] and adds:
/// * A bold, centered text label
/// * Intelligent text color: Black text on light backgrounds, white on dark backgrounds
///   (This ensures the label is always readable.)
/// * Larger padding for an obvious tap target
///
/// Behind the scenes, a [BrutalistContainer] handles the visual style (shadow, border, etc.).
/// This button just adds text and automatic contrast adjustment.
class BrutalistButton extends StatelessWidget {
  /// The text displayed on the button.
  /// Examples: 'NEXT ��', 'CLOSE', '✓ GOT IT!', 'SHOW TUTORIAL'
  final String label;
  
  /// The function executed when the button is pressed.
  /// Example: `onTap: () => Navigator.pop(context)` to close a dialog.
  final VoidCallback onTap;
  
  /// The background color of the button.
  /// Common choices: Color(0xFFFFDE59) (yellow), Color(0xFF5CE1E6) (cyan), Colors.black
  /// The text color is automatically chosen based on this background color.
  final Color color;

  const BrutalistButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color = const Color(0xFFFFDE59),  // Default: brand yellow
  });

  @override
  Widget build(BuildContext context) {
    return BrutalistContainer(
      onTap: onTap,
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),  // Generous padding for easy tapping
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,  // Very bold: weight 900 on a scale of 100-900
            // Smart text color: Dark text on light backgrounds, light text on dark.
            // If the button is black, use white text so it's readable.
            // Otherwise, use black text (works on yellow, cyan, white, etc.).
            color: color == Colors.black ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
