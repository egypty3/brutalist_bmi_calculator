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
/// The "Neo-Brutalist" aesthetic is achieved through:
/// * **Hard Shadows**: A solid black box ([Container]) offset from the content.
/// * **Thick Borders**: A black stroke around the main content.
/// * **High Contrast**: Clean backgrounds and sharp edges.
class BrutalistContainer extends StatelessWidget {
  /// The main content of the container.
  final Widget child;
  
  /// The fill color for the content layer.
  final Color backgroundColor;
  
  /// The corner radius for both the content box and its shadow.
  final double borderRadius;
  
  /// The thickness of the defining black border.
  final double borderWidth;
  
  /// The (x, y) distance the shadow is shifted. Positive values move it right and down.
  final Offset shadowOffset;
  
  /// Internal spacing between the border and the [child].
  final EdgeInsets padding;
  
  /// Optional tap interaction. If provided, the container acts as a button.
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
      onTap: onTap,
      child: Stack(
        children: [
          // --- SHADOW LAYER ---
          // This is a simple black container positioned behind the main content.
          Container(
            margin: EdgeInsets.only(left: shadowOffset.dx, top: shadowOffset.dy),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            // The shadow container must match the size of the content.
            // We use an invisible [child] inside to ensure identical dimensions.
            child: Opacity(opacity: 0, child: Padding(padding: padding, child: child)),
          ),
          
          // --- CONTENT LAYER ---
          // The visible part of the widget with the background color and border.
          Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: Colors.black, width: borderWidth),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// A specialized button widget pre-styled with Neo-Brutalist aesthetics.
/// 
/// It wraps a [BrutalistContainer] and provides a bold, centered text label.
class BrutalistButton extends StatelessWidget {
  /// The text displayed on the button.
  final String label;
  
  /// The function executed when the button is pressed.
  final VoidCallback onTap;
  
  /// The background color of the button.
  final Color color;

  const BrutalistButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color = const Color(0xFFFFDE59),
  });

  @override
  Widget build(BuildContext context) {
    return BrutalistContainer(
      onTap: onTap,
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            // Logic to ensure text visibility regardless of button color.
            color: color == Colors.black ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
