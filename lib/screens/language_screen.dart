import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? selectedLanguage;

  final List<Map<String, String>> languages = [
    {'name': 'English', 'code': 'en'},
    {'name': 'தமிழ் (Tamil)', 'code': 'ta'},
    {'name': 'हिंदी (Hindi)', 'code': 'hi'},
    {'name': 'ಕನ್ನಡ (Kannada)', 'code': 'kn'},
  ];

  void _continue() {
    if (selectedLanguage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a language')));
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F1),
      appBar: AppBar(
        title: Text(
          "Choose Language",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1B5E20),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Text(
              "Select your preferred language",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
            ...languages.map((lang) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: RadioListTile<String>(
                  activeColor: const Color(0xFF1B5E20),
                  title: Text(
                    lang['name']!,
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                  value: lang['code']!,
                  groupValue: selectedLanguage,
                  onChanged: (value) {
                    setState(() {
                      selectedLanguage = value;
                    });
                  },
                ),
              );
            }).toList(),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _continue,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B5E20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Continue",
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
