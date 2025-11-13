# ML Model Integration Guide

## ✅ What's Been Set Up

Your Flutter app now has a complete ML integration system for disease classification:

### 1. **ML Service** (`lib/services/ml_service.dart`)
   - TensorFlow Lite model loading
   - Image preprocessing (resize, normalize)
   - Disease classification inference
   - Top-N predictions with confidence scores
   - Error handling and fallback mode

### 2. **Updated Camera Diagnosis Screen**
   - Integrated ML model for real-time classification
   - Loading indicators during analysis
   - Beautiful result display with confidence scores
   - Fallback mode if model isn't available
   - Professional UI with medical icons

### 3. **Dependencies Added**
   - `tflite_flutter: ^0.12.1` - TensorFlow Lite integration
   - `image: ^4.1.7` - Image preprocessing utilities

## 📁 File Structure

```
assets/
  models/
    ├── disease_classifier.tflite  ← Your ML model (add this)
    ├── labels.txt                 ← Disease class labels (created)
    └── README.md                  ← Setup instructions (created)

lib/
  services/
    └── ml_service.dart            ← ML inference service (created)
  screens/
    └── camera_diagnosis.dart      ← Updated with ML integration
```

## 🚀 Next Steps

### Step 1: Add Your ML Model

1. Convert your trained model to TensorFlow Lite format:
   ```python
   import tensorflow as tf
   
   # Load your model
   model = tf.keras.models.load_model('your_model.h5')
   
   # Convert to TFLite
   converter = tf.lite.TFLiteConverter.from_keras_model(model)
   tflite_model = converter.convert()
   
   # Save
   with open('disease_classifier.tflite', 'wb') as f:
       f.write(tflite_model)
   ```

2. Place `disease_classifier.tflite` in `assets/models/` directory

### Step 2: Configure Model Parameters

Edit `lib/services/ml_service.dart` and update these constants to match your model:

```dart
static const int _inputSize = 224;      // Your model's input size
static const int _numChannels = 3;       // RGB = 3, Grayscale = 1
static const int _numClasses = 10;       // Number of disease classes
```

### Step 3: Update Labels

Edit `assets/models/labels.txt` to match your disease classes (one per line).

### Step 4: Test

```bash
flutter pub get
flutter run
```

## 🔧 Model Requirements

Your TensorFlow Lite model should:
- Accept input: `[1, height, width, channels]` (batch, height, width, channels)
- Input values normalized to [0, 1] range
- Output: Softmax probabilities for each class
- Output shape: `[1, num_classes]`

## 📊 How It Works

1. **Image Capture**: User takes/selects photo
2. **Preprocessing**: 
   - Image resized to model input size (224x224)
   - Converted to RGB
   - Normalized to [0, 1] range
3. **Inference**: Model runs on preprocessed image
4. **Post-processing**: 
   - Get top predictions with confidence scores
   - Format results for display
5. **Display**: Show diagnosis with confidence percentage

## 🎨 Features

- ✅ **Offline-first**: Works without internet
- ✅ **Fast inference**: Optimized TensorFlow Lite
- ✅ **Error handling**: Graceful fallback if model fails
- ✅ **User-friendly**: Loading states, clear results
- ✅ **Medical disclaimer**: Reminds users to consult vets

## 🐛 Troubleshooting

### Model not loading?
- Check file path: `assets/models/disease_classifier.tflite`
- Verify model is valid TensorFlow Lite format
- Check console for error messages

### Wrong predictions?
- Verify input size matches your model
- Check normalization (should be [0, 1])
- Ensure labels.txt matches model output order

### Performance issues?
- Consider using quantized model (INT8)
- Reduce input size if possible
- Use GPU delegate for faster inference

## 📝 Example Model Configuration

For a model with:
- Input: 224x224 RGB images
- Output: 5 disease classes
- Quantized: INT8

Update in `ml_service.dart`:
```dart
static const int _inputSize = 224;
static const int _numChannels = 3;
static const int _numClasses = 5;
```

## 🔐 Best Practices

1. **Always validate model on test set before deployment**
2. **Include confidence thresholds** (already implemented)
3. **Show disclaimers** (already added)
4. **Handle edge cases** (low confidence, errors)
5. **Test on real device** for performance

## 📚 Additional Resources

- [TensorFlow Lite Documentation](https://www.tensorflow.org/lite)
- [Flutter TFLite Plugin](https://pub.dev/packages/tflite_flutter)
- [Model Optimization](https://www.tensorflow.org/lite/performance/model_optimization)

---

**Your ML integration is ready! Just add your model file and you're good to go! 🎉**

