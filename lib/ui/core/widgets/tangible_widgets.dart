import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PastelPalette {
  PastelPalette._();

  static const Color canvas = Color(0xFFFBF8F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF282B37);
  static const Color textMuted = Color(0xFF7A7F92);

  static const Color mint = Color(0xFF7ED9A4);
  static const Color mintBevel = Color(0xFF4FA876);
  static const Color mintText = Color(0xFF144D29);

  static const Color peach = Color(0xFFFF9F85);
  static const Color peachBevel = Color(0xFFE06F51);
  static const Color peachText = Color(0xFF5B1F11);

  static const Color lavender = Color(0xFFBDB2FF);
  static const Color lavenderBevel = Color(0xFF9080E8);
  static const Color lavenderText = Color(0xFF332766);

  static const Color butter = Color(0xFFFFDE6A);
  static const Color butterBevel = Color(0xFFE5BC32);
  static const Color butterText = Color(0xFF523D00);

  static const Color sky = Color(0xFF8DE0F0);
  static const Color skyBevel = Color(0xFF53B5C9);
  static const Color skyText = Color(0xFF0F4754);

  static const Color neutral = Color(0xFFFFFFFF);
  static const Color neutralBevel = Color(0xFFDFD9CF);
  static const Color neutralBorder = Color(0xFFEDE8DE);

  static const Color locked = Color(0xFFE8E4DC);
  static const Color lockedBevel = Color(0xFFCBC4B7);
  static const Color lockedText = Color(0xFF8C867B);

  static const Color boardTray = Color(0xFFECE7DC);
  static const Color boardBed = Color(0xFFE0DAD0);
}

class TangibleButton extends StatefulWidget {
  const TangibleButton({
    super.key,
    required this.child,
    this.onPressed,
    this.color = PastelPalette.mint,
    this.bevelColor = PastelPalette.mintBevel,
    this.height = 56,
    this.width,
    this.elevation = 5,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
  });

  final Widget child;
  final VoidCallback? onPressed;
  final Color color;
  final Color bevelColor;
  final double height;
  final double? width;
  final double elevation;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  State<TangibleButton> createState() => _TangibleButtonState();
}

class _TangibleButtonState extends State<TangibleButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails _) {
    if (widget.onPressed == null) return;
    HapticFeedback.lightImpact();
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails _) {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
    widget.onPressed!();
  }

  void _onTapCancel() {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null;
    final Color currentColor = isEnabled ? widget.color : PastelPalette.locked;
    final Color currentBevel = isEnabled ? widget.bevelColor : PastelPalette.lockedBevel;
    final double currentElevation = isEnabled ? (_isPressed ? 1.0 : widget.elevation) : 2.0;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: widget.elevation,
              child: Container(
                decoration: BoxDecoration(
                  color: currentBevel,
                  borderRadius: widget.borderRadius,
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 60),
              curve: Curves.easeOut,
              left: 0,
              right: 0,
              top: widget.elevation - currentElevation,
              bottom: currentElevation,
              child: Container(
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: currentColor,
                  borderRadius: widget.borderRadius,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TangibleIconButton extends StatefulWidget {
  const TangibleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color = PastelPalette.neutral,
    this.bevelColor = PastelPalette.neutralBevel,
    this.iconColor = PastelPalette.textDark,
    this.size = 46,
    this.elevation = 4,
    this.borderRadius = const BorderRadius.all(Radius.circular(15)),
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color color;
  final Color bevelColor;
  final Color iconColor;
  final double size;
  final double elevation;
  final BorderRadius borderRadius;

  @override
  State<TangibleIconButton> createState() => _TangibleIconButtonState();
}

class _TangibleIconButtonState extends State<TangibleIconButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails _) {
    if (widget.onPressed == null) return;
    HapticFeedback.lightImpact();
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails _) {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
    widget.onPressed!();
  }

  void _onTapCancel() {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null;
    final Color currentColor = isEnabled ? widget.color : PastelPalette.locked;
    final Color currentBevel = isEnabled ? widget.bevelColor : PastelPalette.lockedBevel;
    final double currentElevation = isEnabled ? (_isPressed ? 1.0 : widget.elevation) : 2.0;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: widget.elevation,
              child: Container(
                decoration: BoxDecoration(
                  color: currentBevel,
                  borderRadius: widget.borderRadius,
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 60),
              curve: Curves.easeOut,
              left: 0,
              right: 0,
              top: widget.elevation - currentElevation,
              bottom: currentElevation,
              child: Container(
                decoration: BoxDecoration(
                  color: currentColor,
                  borderRadius: widget.borderRadius,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  widget.icon,
                  color: isEnabled ? widget.iconColor : PastelPalette.lockedText,
                  size: widget.size * 0.52,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TangibleBadge extends StatelessWidget {
  const TangibleBadge({
    super.key,
    required this.child,
    this.color = PastelPalette.surface,
    this.bevelColor = PastelPalette.neutralBevel,
    this.elevation = 3,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  final Widget child;
  final Color color;
  final Color bevelColor;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bevelColor,
        borderRadius: borderRadius,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: elevation),
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.7),
            width: 1.5,
          ),
        ),
        child: child,
      ),
    );
  }
}

class TangibleCard extends StatelessWidget {
  const TangibleCard({
    super.key,
    required this.child,
    this.color = PastelPalette.surface,
    this.bevelColor = PastelPalette.neutralBevel,
    this.elevation = 4,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.padding = const EdgeInsets.all(20),
    this.borderWidth = 1.5,
  });

  final Widget child;
  final Color color;
  final Color bevelColor;
  final double elevation;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bevelColor,
        borderRadius: borderRadius,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: elevation),
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.8),
            width: borderWidth,
          ),
        ),
        child: child,
      ),
    );
  }
}
