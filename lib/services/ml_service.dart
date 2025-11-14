import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:math' as math;

/// ML Service for disease classification using TensorFlow Lite
class MLService {
  Interpreter? _interpreter;
  bool _isModelLoaded = false;
  
  // Model configuration - Update these based on your model
  static const String _modelPath = 'assets/models/disease_classifier.tflite';
  static const String _labelsPath = 'assets/models/labels.txt';
  
  // Model input/output dimensions - Update these based on your model
  static const int _inputSize = 224; // Common sizes: 224, 256, 299, 512
  static const int _numChannels = 3; // RGB
  static const int _numClasses = 10; // Update based on your disease classes
  
  List<String> _labels = [];
  
  /// Initialize and load the ML model
  Future<bool> initialize() async {
    try {
      // Load labels
      await _loadLabels();
      
      // Load model
      final modelData = await rootBundle.load(_modelPath);
      final modelBytes = modelData.buffer.asUint8List();
      
      // Create interpreter
      _interpreter = Interpreter.fromBuffer(modelBytes);
      
      // Get input/output shapes
      final inputShape = _interpreter!.getInputTensor(0).shape;
      final outputShape = _interpreter!.getOutputTensor(0).shape;
      
      print('Model loaded successfully!');
      print('Input shape: $inputShape');
      print('Output shape: $outputShape');
      
      _isModelLoaded = true;
      return true;
    } catch (e) {
      print('Error loading ML model: $e');
      _isModelLoaded = false;
      return false;
    }
  }
  
  /// Load disease labels from file
  Future<void> _loadLabels() async {
    try {
      final labelsData = await rootBundle.loadString(_labelsPath);
      _labels = labelsData.split('\n').where((label) => label.isNotEmpty).toList();
      print('Loaded ${_labels.length} disease labels');
    } catch (e) {
      print('Error loading labels: $e');
      // Fallback labels if file doesn't exist
      _labels = [
        'Healthy',
        'Foot and Mouth Disease',
        'Mastitis',
        'Lumpy Skin Disease',
        'Brucellosis',
        'Anthrax',
        'Blackleg',
        'Fever',
        'Skin Infection',
        'Other'
      ];
    }
  }
  
  /// Classify disease from image file
  Future<DiseasePrediction> classifyImage(File imageFile) async {
    if (!_isModelLoaded || _interpreter == null) {
      throw Exception('Model not loaded. Call initialize() first.');
    }
    
    try {
      // Preprocess image
      final inputBuffer = await _preprocessImage(imageFile);
      
      // Prepare output buffer
      final outputBuffer = List<List<double>>.filled(
        1,
        List<double>.filled(_numClasses, 0.0),
      );
      
      // Run inference
      _interpreter!.run(inputBuffer, outputBuffer);
      
      // Get predictions
      final predictions = outputBuffer[0];
      
      // Find top prediction
      double maxScore = 0.0;
      int maxIndex = 0;
      for (int i = 0; i < predictions.length; i++) {
        if (predictions[i] > maxScore) {
          maxScore = predictions[i];
          maxIndex = i;
        }
      }
      
      // Convert to percentage
      final confidence = (maxScore * 100).clamp(0.0, 100.0);
      
      // Get top 3 predictions
      final topPredictions = _getTopPredictions(predictions, 3);
      
      return DiseasePrediction(
        diseaseName: _labels[maxIndex],
        confidence: confidence,
        topPredictions: topPredictions,
      );
    } catch (e) {
      print('Error during classification: $e');
      rethrow;
    }
  }
  
  /// Preprocess image for model input
  Future<List<List<List<List<double>>>>> _preprocessImage(File imageFile) async {
    // Read image
    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes);
    
    if (image == null) {
      throw Exception('Failed to decode image');
    }
    
    // Resize image to model input size
    final resizedImage = img.copyResize(
      image,
      width: _inputSize,
      height: _inputSize,
      interpolation: img.Interpolation.linear,
    );
    
    // Convert to normalized float array [1, height, width, channels]
    final inputBuffer = List.generate(
      1,
      (_) => List.generate(
        _inputSize,
        (_) => List.generate(
          _inputSize,
          (_) => List.generate(_numChannels, (_) => 0.0),
        ),
      ),
    );
    
    // Extract pixel values and normalize to [0, 1]
    for (int y = 0; y < _inputSize; y++) {
      for (int x = 0; x < _inputSize; x++) {
        final pixel = resizedImage.getPixel(x, y);
        
        // Extract RGB values from Pixel object
        final r = pixel.r;
        final g = pixel.g;
        final b = pixel.b;
        
        // Normalize RGB values to [0, 1]
        inputBuffer[0][y][x][0] = r / 255.0;
        inputBuffer[0][y][x][1] = g / 255.0;
        inputBuffer[0][y][x][2] = b / 255.0;
      }
    }
    
    return inputBuffer;
  }
  
  /// Get top N predictions with their labels
  List<PredictionItem> _getTopPredictions(List<double> predictions, int topN) {
    final indexed = List.generate(
      predictions.length,
      (index) => MapEntry(index, predictions[index]),
    );
    
    indexed.sort((a, b) => b.value.compareTo(a.value));
    
    return indexed.take(topN).map((entry) {
      return PredictionItem(
        label: _labels[entry.key],
        confidence: (entry.value * 100).clamp(0.0, 100.0),
      );
    }).toList();
  }
  
  /// Dispose resources
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isModelLoaded = false;
  }
  
  bool get isModelLoaded => _isModelLoaded;
}

/// Disease prediction result
class DiseasePrediction {
  final String diseaseName;
  final double confidence;
  final List<PredictionItem> topPredictions;
  
  DiseasePrediction({
    required this.diseaseName,
    required this.confidence,
    required this.topPredictions,
  });
  
  String get formattedResult {
    if (confidence < 50.0) {
      return 'Unable to determine disease. Please consult a veterinarian.';
    }
    
    return '$diseaseName (${confidence.toStringAsFixed(1)}% confidence)';
  }
  
  String get detailedResult {
    final buffer = StringBuffer();
    buffer.writeln('Primary Diagnosis: $diseaseName');
    buffer.writeln('Confidence: ${confidence.toStringAsFixed(1)}%');
    buffer.writeln('\nTop Predictions:');
    for (int i = 0; i < topPredictions.length; i++) {
      buffer.writeln(
        '${i + 1}. ${topPredictions[i].label}: ${topPredictions[i].confidence.toStringAsFixed(1)}%',
      );
    }
    return buffer.toString();
  }
}

/// Individual prediction item
class PredictionItem {
  final String label;
  final double confidence;
  
  PredictionItem({
    required this.label,
    required this.confidence,
  });
}

