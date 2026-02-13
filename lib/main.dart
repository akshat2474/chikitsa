import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/bson_demo_screen.dart';
import 'utils/protobuf_zstd_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProtobufZstdHelper.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chikitsa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashWrapper(),
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
          MaterialPageRoute(builder: (_) => const BsonDemoScreen()),
        );
      },
    );
  }
}
