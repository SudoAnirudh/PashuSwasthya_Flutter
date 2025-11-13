import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pashu_swasthya/screens/camera_diagnosis.dart';
import 'package:pashu_swasthya/screens/voice_input.dart';
import 'package:pashu_swasthya/screens/treatment_guide.dart';

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

  /// 🔹 Card Widget
  Widget _buildHomeCard({
    required IconData icon,
    required String title,
    required Color startColor,
    required Color endColor,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.9,
        height: 90,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: endColor.withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(3, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Icon(icon, size: 30, color: Colors.white),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 18,
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  /// 🔹 Home Screen Content
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildHomeCard(
            icon: Icons.camera_alt_rounded,
            title: 'Camera Diagnosis',
            startColor: const Color(0xFF1A3D63),
            endColor: const Color(0xFF1A3D63),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CameraDiagnosisScreen(),
                ),
              );
            },
          ),
          _buildHomeCard(
            icon: Icons.mic_rounded,
            title: 'Voice Diagnosis',
            startColor: const Color(0xFF1A3D63),
            endColor: const Color(0xFF1A3D63),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VoiceInputScreen()),
              );
            },
          ),
          _buildHomeCard(
            icon: Icons.healing_rounded,
            title: 'Treatment Guides',
            startColor: const Color(0xFF1A3D63),
            endColor: const Color(0xFF1A3D63),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TreatmentGuidesScreen(),
                ),
              );
            },
          ),
          _buildHomeCard(
            icon: Icons.call_rounded,
            title: 'Vet Connect',
            startColor: const Color(0xFF1A3D63),
            endColor: const Color(0xFF1A3D63),
            //endColor: const Color(0xFF4A7FA7),
            onTap: () {
              // TODO: Add Vet Connect feature
            },
          ),
        ],
      ),
    );
  }

  /// 🔹 Full Screen Scaffold
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffB3CFE5), Color(0xffB3CFE5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // 👈 makes gradient visible behind everything
        appBar: AppBar(
          title: Text(
            'PashuSwasthya',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF0A1931),
          elevation: 3,
        ),
        body:
            _selectedIndex == 0
                ? _buildHomeContent()
                : Center(
                  child: Text(
                    '${_titles[_selectedIndex]} Page (Coming Soon)',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xFF0A1931),
          unselectedItemColor: Colors.grey,
          backgroundColor: const Color.fromARGB(
            255,
            75,
            111,
            170,
          ).withOpacity(0.9),
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'Diagnose'),
            BottomNavigationBarItem(
              icon: Icon(Icons.healing),
              label: 'Treatment',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
