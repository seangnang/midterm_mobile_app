import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color primary = Color(0xFF2563EB); // Professional Blue
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryContainer = Color(0xFFEFF6FF);

  // Secondary & Dark Navy
  static const Color secondary = Color(0xFF0F172A); // Dark Navy
  static const Color secondaryLight = Color(0xFF1E293B);
  static const Color slate = Color(0xFF334155);

  // Background & Surfaces
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color inputBackground = Color(0xFFF8FAFC);

  // Typography Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderFocused = Color(0xFF2563EB);
  static const Color divider = Color(0xFFF1F5F9);

  // Status & Feedback Colors
  static const Color success = Color(0xFF10B981);
  static const Color successContainer = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningContainer = Color(0xFFFFFBEB);
  static const Color error = Color(0xFFEF4444);
  static const Color errorContainer = Color(0xFFFEF2F2);
  static const Color info = Color(0xFF0284C7);
  static const Color infoContainer = Color(0xFFF0F9FF);

  // Shadows
  static BoxShadow cardShadow = BoxShadow(
    color: const Color(0xFF0F172A).withValues(alpha: 0.05),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );

  static BoxShadow elevatedShadow = BoxShadow(
    color: const Color(0xFF0F172A).withValues(alpha: 0.08),
    blurRadius: 16,
    offset: const Offset(0, 8),
  );
}

