# 🧘‍♀️ Modular Yoga App

A dynamic Flutter application that provides guided yoga sessions with synchronized audio, visual poses, and customizable flows. Built with modularity in mind - easily add new poses without code changes!

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-blue?style=for-the-badge)

## ✨ Features

### 🎯 Core Features
- **Guided Yoga Sessions** - Audio-synchronized pose instructions
- **Visual Pose Display** - Clear image guidance for each position
- **Dynamic Session Loading** - Automatically discovers new yoga sessions
- **Customizable Loop Counts** - Adjust repetitions based on user preference
- **Progress Tracking** - Real-time session progress and timing
- **Session Exit Control** - Confirmation dialog prevents accidental exits

### 🔄 Modular Architecture
- **Zero-Code Pose Addition** - Add new sessions via JSON configuration
- **Dynamic Asset Loading** - Automatically detects images, audio, and metadata
- **Template-Based Structure** - Consistent format for all yoga flows
- **Flexible Timing Control** - Custom durations for intro, loops, and outro

### 🎨 User Experience
- **Modern Dark Theme** - Eye-friendly interface design
- **Smooth Animations** - Fade and scale transitions
- **Intuitive Navigation** - Session selection and preview screens
- **Audio Controls** - Play, pause, and navigation controls
- **Responsive Design** - Works on various screen sizes

## 📋 Prerequisites

Before running this application, ensure you have:

- **Flutter SDK** (3.0.0 or higher)
- **Dart SDK** (2.17.0 or higher)
- **Android Studio** or **VS Code** with Flutter extensions
- **Git** for version control

## 🚀 Setup Instructions

### For Recruiters/Developers downloading ZIP file:

#### 1. **Extract and Navigate**
```bash
# Extract the ZIP file to your desired location
# Navigate to the project directory
cd flutter_project
```

#### 2. **Install Flutter Dependencies**
```bash
# Get all required packages
flutter pub get
```

#### 3. **Verify Flutter Installation**
```bash
# Check if Flutter is properly configured
flutter doctor
```

#### 4. **Run the Application**
```bash
# For Android device/emulator
flutter run

# For specific platform
flutter run -d android
flutter run -d ios
```

### For Development Setup:

#### 1. **Clone Repository** (if using Git)
```bash
git clone <repository-url>
cd flutter_project
```

#### 2. **Install Dependencies**
```bash
flutter pub get
```

#### 3. **Configure IDE**
- **VS Code**: Install Flutter and Dart extensions
- **Android Studio**: Install Flutter plugin

#### 4. **Setup Device**
- **Android**: Enable Developer Options and USB Debugging
- **iOS**: Configure Xcode and iOS Simulator

## 📦 Required Dependencies

The following packages are automatically installed via `pubspec.yaml`:

### Core Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2        # iOS-style icons
  audioplayers: ^5.0.0           # Audio playback functionality
  provider: ^6.0.5               # State management
```

### Development Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0          # Code linting and formatting
```

### Platform Requirements
- **Minimum Android API**: 21 (Android 5.0)
- **Minimum iOS Version**: 11.0
- **Flutter Version**: 3.0.0+

## 📁 Project Structure

```
flutter_project/
├── lib/
│   ├── main.dart                     # App entry point
│   ├── controllers/
│   │   └── yoga_session_controller.dart
│   ├── models/
│   │   └── yoga_session.dart
│   ├── services/
│   │   └── dynamic_yoga_session_service.dart
│   └── screens/
│       ├── session_selection_screen.dart
│       ├── session_preview_screen.dart
│       └── yoga_session_screen.dart
└── assets/
    ├── CatCowJson.json              # Sample yoga session
    ├── audio/
    │   ├── cat_cow_intro.mp3
    │   ├── cat_cow_loop.mp3
    │   └── cat_cow_outro.mp3
    └── images/
        ├── Base.png
        ├── Cat.png
        └── Cow.png
```

## 🆕 How to Add a New Yoga Pose

Follow these steps to add a new yoga session without any code changes:

### Step 1: Create JSON Configuration File

Create a new JSON file in the `assets/` directory (e.g., `BridgePoseJson.json`):

```json
{
  "metadata": {
    "id": "asana_bridge_v1",
    "title": "Bridge Pose Flow",
    "category": "back_strengthening",
    "defaultLoopCount": 5,
    "tempo": "slow"
  },
  "assets": {
    "images": {
      "lying": "Lying.png",
      "bridge": "Bridge.png"
    },
    "audio": {
      "intro": "bridge_intro.mp3",
      "loop": "bridge_loop.mp3",
      "outro": "bridge_outro.mp3"
    }
  },
  "sequence": [
    {
      "type": "segment",
      "name": "intro",
      "audioRef": "intro",
      "durationSec": 20,
      "script": [
        {
          "text": "Lie on your back, knees bent, feet hip-width apart.",
          "startSec": 0,
          "endSec": 8,
          "imageRef": "lying"
        },
        {
          "text": "Prepare to lift your hips, creating a bridge with your body.",
          "startSec": 8,
          "endSec": 20,
          "imageRef": "lying"
        }
      ]
    },
    {
      "type": "loop",
      "name": "bridge_cycle",
      "audioRef": "loop",
      "durationSec": 12,
      "iterations": "{{loopCount}}",
      "loopable": true,
      "script": [
        {
          "text": "Inhale, lift your hips up into bridge pose.",
          "startSec": 0,
          "endSec": 6,
          "imageRef": "bridge"
        },
        {
          "text": "Exhale, slowly lower back down.",
          "startSec": 6,
          "endSec": 12,
          "imageRef": "lying"
        }
      ]
    },
    {
      "type": "segment",
      "name": "outro",
      "audioRef": "outro",
      "durationSec": 15,
      "script": [
        {
          "text": "Rest in lying position, feeling the warmth in your back muscles.",
          "startSec": 0,
          "endSec": 15,
          "imageRef": "lying"
        }
      ]
    }
  ]
}
```

### Step 2: Add Image Assets

Add your pose images to `assets/images/`:
- `Lying.png` - Starting position
- `Bridge.png` - Bridge pose position

**Image Requirements:**
- **Format**: PNG or JPG
- **Size**: 512x512px recommended
- **Background**: Transparent or white
- **Style**: Clear, instructional pose images

### Step 3: Add Audio Assets

Add your audio files to `assets/audio/`:
- `bridge_intro.mp3` - Introduction/setup instructions
- `bridge_loop.mp3` - Main exercise loop audio
- `bridge_outro.mp3` - Cool-down/completion audio

**Audio Requirements:**
- **Format**: MP3
- **Quality**: 128kbps minimum
- **Length**: Match your JSON timing
- **Content**: Clear, calm instructional voice

### Step 4: Update pubspec.yaml

Add your new JSON file to the assets list:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/CatCowJson.json
    - assets/BridgePoseJson.json     # Add your new JSON file
    - assets/audio/
    - assets/images/
```

### Step 5: Test Your New Pose

1. Run `flutter pub get` to update assets
2. Hot restart the app (`flutter run`)
3. Your new pose will automatically appear in the session selection screen!

## 🔧 JSON Configuration Reference

### Metadata Fields
- `id`: Unique identifier for the session
- `title`: Display name in the app
- `category`: Grouping category (e.g., "spinal_mobility", "strength")
- `defaultLoopCount`: Default number of loop repetitions
- `tempo`: Pace indicator ("slow", "medium", "fast")

### Script Timing
- `startSec`: When the instruction begins (in seconds)
- `endSec`: When the instruction ends (in seconds)
- `imageRef`: Which image to display during this instruction
- `text`: The spoken/displayed instruction text

### Audio Synchronization
- Audio files should match the total duration of their corresponding segments
- Loop audio should match the `durationSec` of the loop segment
- Use fade-in/fade-out for smooth transitions

## 🐛 Troubleshooting

### Common Issues

#### 1. **"Failed to load yoga session" Error**
- **Cause**: JSON syntax error or missing assets
- **Solution**: Validate JSON format and ensure all referenced images/audio exist

#### 2. **Audio Not Playing**
- **Cause**: Missing audio files or incorrect file paths
- **Solution**: Check file names match exactly (case-sensitive)

#### 3. **Images Not Displaying**
- **Cause**: Image files not found or incorrect format
- **Solution**: Ensure images are in `assets/images/` and listed in pubspec.yaml

#### 4. **App Won't Start**
- **Cause**: Missing dependencies or Flutter setup issues
- **Solution**: Run `flutter doctor` and `flutter pub get`

### Debug Commands
```bash
# Check for Flutter issues
flutter doctor

# Reinstall dependencies
flutter clean
flutter pub get

# Run with verbose logging
flutter run --verbose

# Check for analysis issues
flutter analyze
```

## 📱 Platform-Specific Notes

### Android
- Requires Android 5.0 (API level 21) or higher
- Automatically handles audio focus and background playback
- Uses native Android audio controls

### iOS
- Requires iOS 11.0 or higher
- Handles audio session management for background playback
- Integrates with iOS media controls

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- AudioPlayers plugin contributors
- Provider package maintainers
- Yoga community for pose inspiration

---

**Made with ❤️ using Flutter**

*For technical support or questions, please open an issue in the repository.*
