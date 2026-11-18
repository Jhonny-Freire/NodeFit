import 'package:flutter/material.dart';

/// Tokens de cor (docs/PLANO.md, 6.4). Nenhum widget usa `Color(0x...)`
/// direto: tudo vem do `ColorScheme` ou de [AppSemanticColors].
abstract final class AppColors {
  static const neon = Color(0xFFCCFF00);
  static const onNeon = Color(0xFF0E0F0C);
  static const surface = Color(0xFF0E0F0C);
  static const black = Color(0xFF000000);
  static const surfaceLow = Color(0xFF161814);
  static const surfaceContainer = Color(0xFF1B1D18);
  static const surfaceHigh = Color(0xFF232620);
  static const surfaceHighest = Color(0xFF2D3029);
  static const onSurface = Color(0xFFE4E6DC);
  static const onSurfaceVariant = Color(0xFFB9BDB0);
  static const outline = Color(0xFF8E9286);
  static const outlineVariant = Color(0xFF44483D);
  static const primaryContainer = Color(0xFF3A4A00);
  static const onPrimaryContainer = Color(0xFFE6FF99);
  static const rest = Color(0xFF5BD6E6); // ciano: descanso
  static const attention = Color(0xFFFFC857); // âmbar: atenção e recorde
  static const error = Color(0xFFFFB4AB); // coral: erro e dor
  static const onError = Color(0xFF690005);
}

/// Cores com significado, além do ColorScheme.
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({required this.rest, required this.attention});
  final Color rest;
  final Color attention;

  static const dark = AppSemanticColors(
    rest: AppColors.rest,
    attention: AppColors.attention,
  );

  @override
  AppSemanticColors copyWith({Color? rest, Color? attention}) =>
      AppSemanticColors(
        rest: rest ?? this.rest,
        attention: attention ?? this.attention,
      );

  @override
  AppSemanticColors lerp(AppSemanticColors? other, double t) {
    if (other == null) return this;
    return AppSemanticColors(
      rest: Color.lerp(rest, other.rest, t)!,
      attention: Color.lerp(attention, other.attention, t)!,
    );
  }
}

extension AppThemeX on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get texts => Theme.of(this).textTheme;
  AppSemanticColors get semantic =>
      Theme.of(this).extension<AppSemanticColors>()!;
}

/// Números que mudam (timer, carga, reps) com dígitos de largura fixa,
/// para não "pularem".
const tabularFigures = [FontFeature.tabularFigures()];

ThemeData buildDarkTheme() {
  final scheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.neon,
        brightness: Brightness.dark,
      ).copyWith(
        primary: AppColors.neon,
        onPrimary: AppColors.onNeon,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.onPrimaryContainer,
        onSecondary: AppColors.onNeon,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        surfaceContainerLowest: AppColors.black,
        surfaceContainerLow: AppColors.surfaceLow,
        surfaceContainer: AppColors.surfaceContainer,
        surfaceContainerHigh: AppColors.surfaceHigh,
        surfaceContainerHighest: AppColors.surfaceHighest,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        error: AppColors.error,
        onError: AppColors.onError,
      );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    brightness: Brightness.dark,
  );

  return base.copyWith(
    scaffoldBackgroundColor: scheme.surface,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: base.textTheme.titleLarge?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: scheme.surfaceContainerLow,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    // Size(64, 56), e não Size.fromHeight: largura infinita quebra botões
    // dentro de Row.
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 56),
        textStyle: base.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surfaceContainerLow,
      indicatorColor: scheme.primaryContainer,
      labelTextStyle: WidgetStatePropertyAll(
        base.textTheme.labelMedium?.copyWith(color: scheme.onSurface),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: scheme.surfaceContainerHigh,
      showDragHandle: true,
      surfaceTintColor: Colors.transparent,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: scheme.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainer,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: scheme.surfaceContainerHighest,
      contentTextStyle: TextStyle(color: scheme.onSurface),
      actionTextColor: scheme.primary,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: scheme.onSurfaceVariant,
      minVerticalPadding: 12,
    ),
    extensions: const [AppSemanticColors.dark],
  );
}
