import 'package:flutter/material.dart';
import 'package:chikitsa/theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'utils/protobuf_zstd_helper.dart';
import 'services/notification_service.dart';
import 'services/language_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

/// Global theme mode notifier
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

/// Save theme preference
Future<void> _saveThemeMode(ThemeMode mode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('theme_mode', mode.toString());
}

/// Load theme preference
Future<void> _loadThemeMode() async {
  final prefs = await SharedPreferences.getInstance();
  final String? modeStr = prefs.getString('theme_mode');
  if (modeStr != null) {
    if (modeStr == ThemeMode.dark.toString()) {
      themeNotifier.value = ThemeMode.dark;
    } else {
      themeNotifier.value = ThemeMode.light;
    }
  }
}

/// Toggle Theme
void toggleTheme() {
  if (themeNotifier.value == ThemeMode.light) {
    themeNotifier.value = ThemeMode.dark;
  } else {
    themeNotifier.value = ThemeMode.light;
  }
  _saveThemeMode(themeNotifier.value);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProtobufZstdHelper.initialize();
  await NotificationService().init();
  await _loadThemeMode();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return ValueListenableBuilder<Locale>(
          valueListenable: LanguageService.current.localeNotifier,
          builder: (context, locale, child) {
            return MaterialApp(
              title: 'Chikitsa',
              debugShowCheckedModeBanner: false,
              theme: ChikitsaTheme.lightTheme(locale),
              darkTheme: ChikitsaTheme.darkTheme(locale),
              themeMode: currentMode,
              locale: locale,
              home: const SplashWrapper(),
            );
          },
        );
      },
    );
  }
}

class SplashWrapper extends StatelessWidget {
  const SplashWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ChikitsaSplashScreen(
      onAnimationComplete: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      },
    );
  }
}
