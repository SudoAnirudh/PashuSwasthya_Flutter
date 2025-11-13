import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pashu_swasthya/screens/camera_diagnosis.dart';
import 'package:pashu_swasthya/screens/settings_screen.dart';
import 'package:pashu_swasthya/screens/voice_input.dart';
import 'package:pashu_swasthya/screens/treatment_guide.dart';
import 'package:pashu_swasthya/services/localization_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<String> _titles = [
    'Home',
    'Voice Diagnose',
    'Treatment',
    'Profile',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildGridCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFFE0F2F1),
                child: Icon(icon, size: 30, color: const Color(0xFF00796B)),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Home Screen Content
  Widget _buildHomeContent(LocalizationService localizationService) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.8,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return _buildGridCard(
              icon: Icons.healing,
              title: localizationService.translate('detect_disease'),
              subtitle: 'Scan symptoms to identify potential illness.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CameraDiagnosisScreen(),
                  ),
                );
              },
            );
          case 1:
            return _buildGridCard(
              icon: Icons.camera_alt,
              title: localizationService.translate('identify_breed'),
              subtitle: 'Use your camera to find out the cattle breed.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VoiceInputScreen(
                      localeId: localizationService.locale.toString(),
                    ),
                  ),
                );
              },
            );
          case 2:
            return _buildGridCard(
              icon: Icons.book,
              title: localizationService.translate('treatment_guide'),
              subtitle: 'Access offline guides for common treatments.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TreatmentGuidesScreen(),
                  ),
                );
              },
            );
          case 3:
            return _buildGridCard(
              icon: Icons.call,
              title: localizationService.translate('vet_help'),
              subtitle: 'Connect with a certified vet for expert advice.',
              onTap: () {
                // TODO: Add Vet Connect feature
              },
            );
          default:
            return Container();
        }
      },
    );
  }

  /// 🔹 Full Screen Scaffold
  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationService>(
      builder: (context, localizationService, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
        ),
        title: Column(
          children: [
            Text(
              'PashuSwasthya',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'Offline Mode',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VoiceInputScreen(
                    localeId: localizationService.locale.toString(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _buildHomeContent(localizationService),
        );
      },
    );
  }
}
