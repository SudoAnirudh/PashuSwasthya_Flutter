import 'package:flutter/material.dart';

class TreatmentGuidesScreen extends StatefulWidget {
  const TreatmentGuidesScreen({super.key});

  @override
  State<TreatmentGuidesScreen> createState() => _TreatmentGuidesScreenState();
}

class _TreatmentGuidesScreenState extends State<TreatmentGuidesScreen> {
  final TextEditingController _observationController = TextEditingController();
  final List<String> _observations = [];

  final List<Map<String, dynamic>> diseases = [
    {
      "name": "Lumpy Skin Disease",
      "code": "LSD",
      "keywords": [
        "lumpy skin",
        "skin lumps",
        "nodules",
        "body lumps",
        "fever with lumps",
        "skin infection",
        "reduced milk",
        "eye discharge",
        "nose discharge",
        "ticks disease",
      ],
    },
    {
      "name": "Foot and Mouth Disease",
      "code": "FMD",
      "keywords": [
        "mouth ulcers",
        "foot ulcers",
        "blisters in mouth",
        "drooling saliva",
        "hoof infection",
        "cannot walk",
        "hoof peeling",
        "tongue wounds",
        "fever mouth disease",
        "highly contagious",
      ],
    },
    {
      "name": "Mastitis",
      "code": "MAST",
      "keywords": [
        "swollen udder",
        "udder pain",
        "blood in milk",
        "clotted milk",
        "yellow milk",
        "udder infection",
        "hot udder",
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _observationController.addListener(() {
      setState(() {}); // update button state
    });
  }

  @override
  void dispose() {
    _observationController.dispose();
    super.dispose();
  }

  void _insertKeyword(String keyword) {
    _observationController.text =
        _observationController.text.isEmpty
            ? keyword
            : '${_observationController.text}, $keyword';
    _observationController.selection = TextSelection.fromPosition(
      TextPosition(offset: _observationController.text.length),
    );
  }

  void _addObservation() {
    final text = _observationController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _observations.add(text);
      _observationController.clear();
    });
  }

  void _saveObservations() {
    if (_observations.isEmpty) return;

    print('Saved Observations: $_observations');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Observations saved successfully')),
    );

    setState(() {
      _observations.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Treatment Guides'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Input field
            TextField(
              controller: _observationController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Enter observation',
                hintText: 'Type symptoms or details here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // Add Observation button
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        _observationController.text.trim().isEmpty
                            ? null
                            : _addObservation,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Observation'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Display added observations
            if (_observations.isNotEmpty)
              SizedBox(
                height: 120, // limit height
                child: ListView.builder(
                  itemCount: _observations.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(_observations[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _observations.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 10),

            // Disease keywords
            Expanded(
              child: ListView.builder(
                itemCount: diseases.length,
                itemBuilder: (context, index) {
                  final disease = diseases[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ExpansionTile(
                      title: Text(
                        disease["name"],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: List<Widget>.from(
                              disease["keywords"].map(
                                (keyword) => ActionChip(
                                  label: Text(keyword),
                                  onPressed: () => _insertKeyword(keyword),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Save all observations button
            ElevatedButton.icon(
              onPressed: _observations.isEmpty ? null : _saveObservations,
              icon: const Icon(Icons.save),
              label: const Text('Save Observations'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
