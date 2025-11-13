import 'package:flutter/material.dart';
import 'package:pashu_swasthya/services/translation_service.dart';

class LocalizationService with ChangeNotifier {
  final TranslationService _translationService = TranslationService();

  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  final Map<String, Map<String, String>> _localizedStrings = {};

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _loadLocalizedStrings();
    notifyListeners();
  }

  Future<void> _loadLocalizedStrings() async {
    if (_locale.languageCode == 'en') {
      _localizedStrings['en'] = {
        'detect_disease': 'Detect Disease',
        'identify_breed': 'Identify Breed',
        'treatment_guide': 'Treatment Guide',
        'vet_help': 'Vet Help',
      };
      return;
    }

    if (_localizedStrings.containsKey(_locale.languageCode)) {
      return;
    }

    final Map<String, String> translations = {};
    for (final key in _localizedStrings['en']!.keys) {
      final translatedText = await _translationService.translate(
        _localizedStrings['en']![key]!,
        _locale.languageCode,
      );
      translations[key] = translatedText;
    }
    _localizedStrings[_locale.languageCode] = translations;
  }

  String translate(String key) {
    return _localizedStrings[_locale.languageCode]?[key] ?? key;
  }
}
