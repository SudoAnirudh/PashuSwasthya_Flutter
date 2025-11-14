enum DiseaseSeverity { mild, moderate, severe }

class Disease {
  final String name;
  final List<String> symptoms;
  final List<String> keywords;
  final DiseaseSeverity severity;

  Disease({
    required this.name,
    required this.symptoms,
    required this.keywords,
    required this.severity,
  });
}
