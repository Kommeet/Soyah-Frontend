import 'package:flutter/material.dart';

class ContinueButtonWidget extends StatelessWidget {
  final double? width; // Optional, will be calculated if not provided
  final double? height; // Optional, will be calculated if not provided
  final double borderRadius;
  final Color borderColor;
  final Color iconColor;
  final IconData icon;
  final String label;
  final Color labelColor;
  final Color labelBackgroundColor;
  final VoidCallback? onTap;
  final double maxWidth;
  final double minWidth;

  const ContinueButtonWidget({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 30.0,
    this.borderColor = Colors.red,
    this.iconColor = Colors.red,
    this.icon = Icons.keyboard_arrow_right,
    this.label = 'CONTINUE',
    this.labelColor = Colors.red,
    this.labelBackgroundColor = Colors.white,
    this.onTap,
    this.minWidth = 120.0, 
    this.maxWidth = 240.0, 
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive dimensions
        final screenWidth = MediaQuery.of(context).size.width;
        final calculatedWidth = width ?? (screenWidth * 0.4).clamp(minWidth, maxWidth);
        final calculatedHeight = height ?? (screenWidth * 0.15).clamp(50.0, 70.0);
        final iconSize = calculatedHeight * 0.5;
        final textScaleFactor = (screenWidth < 360) ? 0.9 : 1.0; 

        return GestureDetector(
          onTap: onTap,
          child: Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: minWidth,
                maxWidth: maxWidth,
                minHeight: calculatedHeight,
              ),
              child: SizedBox(
                width: calculatedWidth,
                height: calculatedHeight,
                child: Stack(
                  clipBehavior: Clip.none, 
                  children: [
                    Container(
                      width: calculatedHeight, 
                      height: calculatedHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        border: Border.all(color: borderColor),
                      ),
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: iconSize,
                      ),
                    ),
                    // Label
                    Positioned(
                      left: calculatedHeight * 0.6,
                      bottom: calculatedHeight * 0.35,
                      right: 0, // Allow it to extend to the right edge
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        color: labelBackgroundColor,
                        child: Text(
                          label,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                color: labelColor,
                                fontSize: 14 * textScaleFactor,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}