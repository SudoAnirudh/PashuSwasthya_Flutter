import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const PashuSwasthya());
}

class PashuSwasthya extends StatelessWidget {
  const PashuSwasthya({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cattle Health Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1B5E20),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
