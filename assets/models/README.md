# ML Model Setup Instructions

## Required Files

Place your TensorFlow Lite model files in this directory:

1. **disease_classifier.tflite** - Your trained TensorFlow Lite model
2. **labels.txt** - Text file with disease class labels (one per line)

## Model Requirements

- **Format**: TensorFlow Lite (.tflite)
- **Input Size**: 224x224 pixels (configurable in `ml_service.dart`)
- **Input Channels**: 3 (RGB)
- **Input Type**: Float32 normalized to [0, 1]
- **Output**: Softmax probabilities for each disease class

## Labels File Format

Create a `labels.txt` file with one disease name per line:

```
Healthy
Foot and Mouth Disease
Mastitis
Lumpy Skin Disease
Brucellosis
Anthrax
Blackleg
Fever
Skin Infection
Other
```

## Model Configuration

Update these constants in `lib/services/ml_service.dart` to match your model:

- `_inputSize`: Image input size (default: 224)
- `_numChannels`: Number of color channels (default: 3 for RGB)
- `_numClasses`: Number of disease classes (default: 10)

## Converting Your Model to TensorFlow Lite

If you have a TensorFlow/Keras model, convert it using:

```python
import tensorflow as tf

# Load your model
model = tf.keras.models.load_model('your_model.h5')

# Convert to TensorFlow Lite
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

# Save the model
with open('disease_classifier.tflite', 'wb') as f:
    f.write(tflite_model)
```

## Testing

After adding your model files, run:
```bash
flutter pub get
flutter run
```

The app will automatically load the model on startup.

