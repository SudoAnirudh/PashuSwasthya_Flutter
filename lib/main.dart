import 'package:flutter/material.dart';
import 'package:pashu_swasthya/screens/login_screen.dart';
import 'package:pashu_swasthya/services/localization_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocalizationService(),
      child: const PashuSwasthya(),
    ),
  );
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
      home: const LoginScreen(),
    );
  }
}
