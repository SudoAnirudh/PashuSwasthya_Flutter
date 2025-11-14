import 'package:pashu_swasthya/models/disease.dart';

class DiseaseService {
  final List<Disease> _diseases = [
    Disease(
      name: 'Foot and Mouth Disease',
      symptoms: [
        'Fever',
        'Blisters in the mouth and on the feet',
        'Drooling',
        'Lameness',
      ],
      keywords: ['foot', 'mouth', 'blisters', 'drooling', 'lame'],
      severity: DiseaseSeverity.severe,
    ),
    Disease(
      name: 'Mastitis',
      symptoms: [
        'Inflammation of the udder',
        'Swelling, heat, hardness, redness, or pain in the udder',
        'Abnormalities in milk, such as a watery appearance, flakes, or clots',
      ],
      keywords: ['mastitis', 'udder', 'swelling', 'milk', 'clots'],
      severity: DiseaseSeverity.moderate,
    ),
    Disease(
      name: 'Lumpy Skin Disease',
      symptoms: [
        'Fever',
        'Nodules or lumps on the skin',
        'Swelling of the limbs and brisket',
        'Watery eyes',
      ],
      keywords: ['lumpy', 'skin', 'nodules', 'lumps', 'swelling'],
      severity: DiseaseSeverity.severe,
    ),
  ];

  Disease? identifyDisease(String transcribedText) {
    for (final disease in _diseases) {
      for (final keyword in disease.keywords) {
        if (transcribedText.toLowerCase().contains(keyword)) {
          return disease;
        }
      }
    }
    return null;
  }
}
