import 'package:flutter/material.dart';
import 'package:chikitsa/theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'utils/protobuf_zstd_helper.dart';
import 'services/notification_service.dart';

/// Global theme mode notifier — accessed from anywhere to toggle light/dark
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProtobufZstdHelper.initialize();
  await NotificationService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: 'Chikitsa',
          debugShowCheckedModeBanner: false,
          theme: ChikitsaTheme.lightTheme,
          darkTheme: ChikitsaTheme.darkTheme,
          themeMode: currentMode,
          home: const SplashWrapper(),
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
