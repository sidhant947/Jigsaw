import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppSkin {
  pastel('Pastel', 'Classic light pastel look'),
  dark('Dark Slate', 'Sleek dark mode theme'),
  cyber('Cyber Sunset', 'Vibrant neon cyberpunk vibes'),
  forest('Nordic Forest', 'Calm earthy forest tones');

  const AppSkin(this.title, this.subtitle);
  final String title;
  final String subtitle;
}

class AppPaletteData {
  const AppPaletteData({
    required this.canvas,
    required this.surface,
    required this.textDark,
    required this.textMuted,
    required this.mint,
    required this.mintBevel,
    required this.mintText,
    required this.peach,
    required this.peachBevel,
    required this.peachText,
    required this.lavender,
    required this.lavenderBevel,
    required this.lavenderText,
    required this.butter,
    required this.butterBevel,
    required this.butterText,
    required this.sky,
    required this.skyBevel,
    required this.skyText,
    required this.neutral,
    required this.neutralBevel,
    required this.neutralBorder,
    required this.locked,
    required this.lockedBevel,
    required this.lockedText,
    required this.boardTray,
    required this.boardBed,
  });

  final Color canvas;
  final Color surface;
  final Color textDark;
  final Color textMuted;
  final Color mint;
  final Color mintBevel;
  final Color mintText;
  final Color peach;
  final Color peachBevel;
  final Color peachText;
  final Color lavender;
  final Color lavenderBevel;
  final Color lavenderText;
  final Color butter;
  final Color butterBevel;
  final Color butterText;
  final Color sky;
  final Color skyBevel;
  final Color skyText;
  final Color neutral;
  final Color neutralBevel;
  final Color neutralBorder;
  final Color locked;
  final Color lockedBevel;
  final Color lockedText;
  final Color boardTray;
  final Color boardBed;

  factory AppPaletteData.forSkin(AppSkin skin) {
    switch (skin) {
      case AppSkin.pastel:
        return const AppPaletteData(
          canvas: Color(0xFFFBF8F2),
          surface: Color(0xFFFFFFFF),
          textDark: Color(0xFF282B37),
          textMuted: Color(0xFF7A7F92),
          mint: Color(0xFF7ED9A4),
          mintBevel: Color(0xFF4FA876),
          mintText: Color(0xFF144D29),
          peach: Color(0xFFFF9F85),
          peachBevel: Color(0xFFE06F51),
          peachText: Color(0xFF5B1F11),
          lavender: Color(0xFFBDB2FF),
          lavenderBevel: Color(0xFF9080E8),
          lavenderText: Color(0xFF332766),
          butter: Color(0xFFFFDE6A),
          butterBevel: Color(0xFFE5BC32),
          butterText: Color(0xFF523D00),
          sky: Color(0xFF8DE0F0),
          skyBevel: Color(0xFF53B5C9),
          skyText: Color(0xFF0F4754),
          neutral: Color(0xFFFFFFFF),
          neutralBevel: Color(0xFFDFD9CF),
          neutralBorder: Color(0xFFEDE8DE),
          locked: Color(0xFFE8E4DC),
          lockedBevel: Color(0xFFCBC4B7),
          lockedText: Color(0xFF8C867B),
          boardTray: Color(0xFFECE7DC),
          boardBed: Color(0xFFE0DAD0),
        );
      case AppSkin.dark:
        return const AppPaletteData(
          canvas: Color(0xFF181A20),
          surface: Color(0xFF262832),
          textDark: Color(0xFFF2F4F8),
          textMuted: Color(0xFFA0A6B8),
          mint: Color(0xFF2DD4BF),
          mintBevel: Color(0xFF14B8A6),
          mintText: Color(0xFF042F2C),
          peach: Color(0xFFF87171),
          peachBevel: Color(0xFFEF4444),
          peachText: Color(0xFF450A0A),
          lavender: Color(0xFFA78BFA),
          lavenderBevel: Color(0xFF8B5CF6),
          lavenderText: Color(0xFF1E0B40),
          butter: Color(0xFFFBBF24),
          butterBevel: Color(0xFFF59E0B),
          butterText: Color(0xFF451A03),
          sky: Color(0xFF38BDF8),
          skyBevel: Color(0xFF0284C7),
          skyText: Color(0xFF0C4A6E),
          neutral: Color(0xFF262832),
          neutralBevel: Color(0xFF3B3E4F),
          neutralBorder: Color(0xFF4B4F64),
          locked: Color(0xFF323545),
          lockedBevel: Color(0xFF232532),
          lockedText: Color(0xFF9CA3AF),
          boardTray: Color(0xFF20222B),
          boardBed: Color(0xFF14151B),
        );
      case AppSkin.cyber:
        return const AppPaletteData(
          canvas: Color(0xFF120E1E),
          surface: Color(0xFF1E1730),
          textDark: Color(0xFFFAFAFE),
          textMuted: Color(0xFFAC9EC0),
          mint: Color(0xFF00F5D4),
          mintBevel: Color(0xFF00BB9C),
          mintText: Color(0xFF003830),
          peach: Color(0xFFFF007F),
          peachBevel: Color(0xFFC70063),
          peachText: Color(0xFFFFFFFF),
          lavender: Color(0xFF9D4EDD),
          lavenderBevel: Color(0xFF7B2CBF),
          lavenderText: Color(0xFFFFFFFF),
          butter: Color(0xFFFFB703),
          butterBevel: Color(0xFFFB8500),
          butterText: Color(0xFF3D2000),
          sky: Color(0xFF00BBF9),
          skyBevel: Color(0xFF0096C7),
          skyText: Color(0xFF002B36),
          neutral: Color(0xFF1E1730),
          neutralBevel: Color(0xFF352B52),
          neutralBorder: Color(0xFF453967),
          locked: Color(0xFF2A2142),
          lockedBevel: Color(0xFF1A132D),
          lockedText: Color(0xFF9E8DB8),
          boardTray: Color(0xFF181227),
          boardBed: Color(0xFF0F0A1A),
        );
      case AppSkin.forest:
        return const AppPaletteData(
          canvas: Color(0xFFF3F5F1),
          surface: Color(0xFFFFFFFF),
          textDark: Color(0xFF1C2D27),
          textMuted: Color(0xFF677B73),
          mint: Color(0xFF52A478),
          mintBevel: Color(0xFF3B7C59),
          mintText: Color(0xFF102A1C),
          peach: Color(0xFFE07A5F),
          peachBevel: Color(0xFFC85A3F),
          peachText: Color(0xFF42150A),
          lavender: Color(0xFF81B29A),
          lavenderBevel: Color(0xFF60937C),
          lavenderText: Color(0xFF1D3B2E),
          butter: Color(0xFFF2CC8F),
          butterBevel: Color(0xFFDDA15E),
          butterText: Color(0xFF4A3008),
          sky: Color(0xFF61A5C2),
          skyBevel: Color(0xFF468FAF),
          skyText: Color(0xFF0C2B38),
          neutral: Color(0xFFFFFFFF),
          neutralBevel: Color(0xFFCFD7CC),
          neutralBorder: Color(0xFFDFE6DD),
          locked: Color(0xFFD8E0D5),
          lockedBevel: Color(0xFFBEC8BB),
          lockedText: Color(0xFF7E8A7C),
          boardTray: Color(0xFFE4ECE2),
          boardBed: Color(0xFFD6E0D4),
        );
    }
  }
}

class PastelPalette {
  PastelPalette._();

  static AppSkin currentSkin = AppSkin.pastel;

  static AppPaletteData get current => AppPaletteData.forSkin(currentSkin);

  static Color get canvas => current.canvas;
  static Color get surface => current.surface;
  static Color get textDark => current.textDark;
  static Color get textMuted => current.textMuted;

  static Color get mint => current.mint;
  static Color get mintBevel => current.mintBevel;
  static Color get mintText => current.mintText;

  static Color get peach => current.peach;
  static Color get peachBevel => current.peachBevel;
  static Color get peachText => current.peachText;

  static Color get lavender => current.lavender;
  static Color get lavenderBevel => current.lavenderBevel;
  static Color get lavenderText => current.lavenderText;

  static Color get butter => current.butter;
  static Color get butterBevel => current.butterBevel;
  static Color get butterText => current.butterText;

  static Color get sky => current.sky;
  static Color get skyBevel => current.skyBevel;
  static Color get skyText => current.skyText;

  static Color get neutral => current.neutral;
  static Color get neutralBevel => current.neutralBevel;
  static Color get neutralBorder => current.neutralBorder;

  static Color get locked => current.locked;
  static Color get lockedBevel => current.lockedBevel;
  static Color get lockedText => current.lockedText;

  static Color get boardTray => current.boardTray;
  static Color get boardBed => current.boardBed;
}

class TangibleButton extends StatefulWidget {
  const TangibleButton({
    super.key,
    required this.child,
    this.onPressed,
    this.color,
    this.bevelColor,
    this.height = 56,
    this.width,
    this.elevation = 5,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
  });

  final Widget child;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? bevelColor;
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
    final Color btnColor = widget.color ?? PastelPalette.mint;
    final Color btnBevel = widget.bevelColor ?? PastelPalette.mintBevel;
    final Color currentColor = isEnabled ? btnColor : PastelPalette.locked;
    final Color currentBevel = isEnabled ? btnBevel : PastelPalette.lockedBevel;
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
    this.color,
    this.bevelColor,
    this.iconColor,
    this.size = 46,
    this.elevation = 4,
    this.borderRadius = const BorderRadius.all(Radius.circular(15)),
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? bevelColor;
  final Color? iconColor;
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
    final Color btnColor = widget.color ?? PastelPalette.neutral;
    final Color btnBevel = widget.bevelColor ?? PastelPalette.neutralBevel;
    final Color btnIconColor = widget.iconColor ?? PastelPalette.textDark;
    final Color currentColor = isEnabled ? btnColor : PastelPalette.locked;
    final Color currentBevel = isEnabled ? btnBevel : PastelPalette.lockedBevel;
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
                  color: isEnabled ? btnIconColor : PastelPalette.lockedText,
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
    this.color,
    this.bevelColor,
    this.elevation = 3,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  final Widget child;
  final Color? color;
  final Color? bevelColor;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final Color badgeColor = color ?? PastelPalette.surface;
    final Color badgeBevel = bevelColor ?? PastelPalette.neutralBevel;

    return Container(
      decoration: BoxDecoration(
        color: badgeBevel,
        borderRadius: borderRadius,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: elevation),
        padding: padding,
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: borderRadius,
          border: Border.all(
            color: PastelPalette.neutralBorder,
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
    this.color,
    this.bevelColor,
    this.elevation = 4,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.padding = const EdgeInsets.all(20),
    this.borderWidth = 1.5,
  });

  final Widget child;
  final Color? color;
  final Color? bevelColor;
  final double elevation;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final Color cardColor = color ?? PastelPalette.surface;
    final Color cardBevel = bevelColor ?? PastelPalette.neutralBevel;

    return Container(
      decoration: BoxDecoration(
        color: cardBevel,
        borderRadius: borderRadius,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: elevation),
        padding: padding,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: borderRadius,
          border: Border.all(
            color: PastelPalette.neutralBorder,
            width: borderWidth,
          ),
        ),
        child: child,
      ),
    );
  }
}
