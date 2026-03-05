import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── SYNAP COLOR PALETTE ─────────────────────────
class SynapColors {
  // Backgrounds — Dark
  static const Color bgPrimary = Color(0xFF0A0A12);
  static const Color bgSecondary = Color(0xFF14141E);
  static const Color bgTertiary = Color(0xFF1C1C28);
  static const Color bgCard = Color(0xFF151520);

  // Backgrounds — Light
  static const Color bgPrimaryLight = Color(0xFFF5F5F7);
  static const Color bgSecondaryLight = Color(0xFFFFFFFF);
  static const Color bgTertiaryLight = Color(0xFFEEEFF1);
  static const Color bgCardLight = Color(0xFFFFFFFF);

  // Accent (Synap Brand Palette)
  static const Color accent = Color(0xFF7B61FF);      // Premium Purple
  static const Color accentSecondary = Color(0xFF00E5FF); // Electric Cyan
  static const Color accentGreen = Color(0xFF22C55E);
  static const Color accentRed = Color(0xFFEF4444);
  static const Color accentOrange = Color(0xFFF97316);

  // Text — Dark
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF999999);
  static const Color textMuted = Color(0xFF666666);

  // Text — Light
  static const Color textPrimaryLight = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textMutedLight = Color(0xFF9CA3AF);

  // Border
  static const Color border = Color(0xFF333333);
  static const Color divider = Color(0xFF2A2A2A);
  static const Color borderLight = Color(0xFFE2E4E9);
  static const Color dividerLight = Color(0xFFEEEFF1);
}

// ─── THEME ────────────────────────────────────────
class SynapTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: SynapColors.bgPrimary,
      primaryColor: SynapColors.accent,
      colorScheme: const ColorScheme.dark(
        primary: SynapColors.accent,
        secondary: SynapColors.accentGreen,
        surface: Color(0xFF151520), // matching SynapColors.bgCard
        error: SynapColors.accentRed,
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.syne(fontSize: 26, fontWeight: FontWeight.w800, color: SynapColors.textPrimary, letterSpacing: -0.5),
        headlineMedium: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w700, color: SynapColors.textPrimary),
        bodyLarge: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w400, color: SynapColors.textPrimary),
        bodyMedium: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500, color: SynapColors.textPrimary),
        bodySmall: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w400, color: SynapColors.textSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent, // Reveal background
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: SynapColors.bgCard,
        contentTextStyle: const TextStyle(color: SynapColors.textPrimary, fontSize: 14),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: SynapColors.bgPrimaryLight,
      primaryColor: SynapColors.accent,
      colorScheme: ColorScheme.light(
        primary: SynapColors.accent,
        secondary: SynapColors.accentGreen,
        surface: Colors.white.withOpacity(0.7), // Glass-like surface for light mode
        error: SynapColors.accentRed,
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w700, color: SynapColors.textPrimaryLight),
        bodyLarge: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w400, color: SynapColors.textPrimaryLight),
        bodyMedium: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500, color: SynapColors.textPrimaryLight),
        bodySmall: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w400, color: SynapColors.textSecondaryLight),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent, // Reveal background
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: SynapColors.textPrimaryLight),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: SynapColors.bgCardLight,
        contentTextStyle: const TextStyle(color: SynapColors.textPrimaryLight, fontSize: 14),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
// ─── THEME HELPERS ───────────────────────────────
class SynapStyles {
  static bool isDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

  static Color bgPrimary(BuildContext context) => isDark(context) ? SynapColors.bgPrimary.withOpacity(0.1) : SynapColors.bgPrimaryLight.withOpacity(0.2);
  static Color bgSecondary(BuildContext context) => isDark(context) ? SynapColors.bgSecondary.withOpacity(0.5) : SynapColors.bgSecondaryLight.withOpacity(0.6);
  static Color bgTertiary(BuildContext context) => isDark(context) ? SynapColors.bgTertiary.withOpacity(0.4) : SynapColors.bgTertiaryLight.withOpacity(0.5);
  static Color bgCard(BuildContext context) => isDark(context) ? SynapColors.bgCard.withOpacity(0.6) : SynapColors.bgCardLight.withOpacity(0.7);

  static Color textPrimary(BuildContext context) => isDark(context) ? SynapColors.textPrimary : SynapColors.textPrimaryLight;
  static Color textSecondary(BuildContext context) => isDark(context) ? SynapColors.textSecondary : SynapColors.textSecondaryLight;
  static Color textMuted(BuildContext context) => isDark(context) ? SynapColors.textMuted : SynapColors.textMutedLight;

  static Color border(BuildContext context) => isDark(context) ? SynapColors.border : SynapColors.borderLight;
  static Color divider(BuildContext context) => isDark(context) ? SynapColors.divider : SynapColors.dividerLight;
}
