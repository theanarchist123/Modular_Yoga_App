# Modular Yoga Session App 🧘‍♀️

A dynamic Flutter application that creates immersive yoga sessions by synchronizing audio guidance, visual poses, and metadata from JSON configuration files. Built as a proof-of-concept for the ArvyaX smart yoga mat platform.

## 🎯 Features

### Core Functionality
- **Dynamic JSON Parsing**: Automatically loads yoga sessions from JSON files
- **Perfect Audio-Visual Sync**: Precisely timed audio instructions with corresponding pose images
- **Modular Architecture**: Add new sessions without code changes - just add JSON, images, and audio
- **Session Flow Management**: Intro → Loop Cycles → Outro structure

### Enhanced User Experience
- **Session Preview**: Preview all poses before starting
- **Play/Pause/Resume Controls**: Full session control
- **Progress Tracking**: Visual progress bar and timer
- **Beautiful UI**: Modern, calming design with smooth animations
- **Session Information**: Detailed session metadata display

### Technical Highlights
- **State Management**: Provider pattern for reactive UI updates
- **Audio Management**: Advanced AudioPlayer integration with background playback
- **Asset Management**: Dynamic loading of images and audio files
- **Error Handling**: Robust error handling and graceful degradation

## 📱 Screenshots

The app features three main screens:
1. **Home Screen**: Beautiful welcome interface with app branding
2. **Session Preview**: Overview of the session with pose sequence
3. **Active Session**: Immersive yoga experience with synchronized media

## 🏗️ Architecture

### Project Structure
```
lib/
├── main.dart                    # App entry point and home screen
├── models/
│   └── yoga_session.dart       # Data models for session structure
├── services/
│   └── yoga_session_service.dart # JSON parsing and asset management
├── controllers/
│   └── yoga_session_controller.dart # Session state and timing logic
└── screens/
    ├── session_preview_screen.dart # Session overview UI
    └── yoga_session_screen.dart    # Active session UI
```

### Data Flow
1. **JSON Loading**: Service layer parses session configuration
2. **State Management**: Controller manages session timing and progression
3. **UI Updates**: Provider notifies UI components of state changes
4. **Media Sync**: Precise timing ensures audio-visual synchronization

## 📄 JSON Configuration Format

The app uses a sophisticated JSON structure for session definition:

```json
{
  "metadata": {
    "id": "session_identifier",
    "title": "Session Name",
    "category": "session_type",
    "defaultLoopCount": 4,
    "tempo": "slow"
  },
  "assets": {
    "images": {
      "pose_key": "image_filename.png"
    },
    "audio": {
      "segment_key": "audio_filename.mp3"
    }
  },
  "sequence": [
    {
      "type": "segment|loop",
      "name": "segment_name",
      "audioRef": "audio_key",
      "durationSec": 20,
      "script": [
        {
          "text": "Instruction text",
          "startSec": 0,
          "endSec": 10,
          "imageRef": "image_key"
        }
      ]
    }
  ]
}
```

## 🎵 Audio Structure

Following the modular design principle:

### 🔹 Intro (20-25 seconds)
Fixed opening segment with setup instructions

### 🔁 Loop (15-20 seconds each)
Repeatable breath cycles that can be configured for different durations

### 🔹 Outro (15-20 seconds)
Fixed closing segment with integration instructions

## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- Android Studio / VS Code
- Android device or emulator for testing

### Installation
1. **Clone/Download the project**
   ```bash
   cd flutter_project
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Prepare assets**
   - Place your JSON session file in the root directory
   - Add pose images to the `Images/` folder
   - Add audio files to the `Audio/` folder
   - Update `pubspec.yaml` assets section if needed

4. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Asset Management

### Adding New Sessions
1. **Create JSON configuration** following the schema
2. **Add corresponding images** to the Images folder
3. **Add audio files** to the Audio folder
4. **Update main.dart** to load your new JSON file

### Asset Naming Convention
- **Images**: Use descriptive names (e.g., `cat_pose.png`, `cow_pose.png`)
- **Audio**: Match the audioRef in JSON (e.g., `intro.mp3`, `loop.mp3`)
- **JSON**: Use semantic names (e.g., `SunSalutation.json`)

## 🎨 UI/UX Design Philosophy

### Color Scheme
- **Primary**: Deep navy (#0D1B2A) for calming background
- **Secondary**: Soft blue (#1B2B47) for cards and overlays
- **Accent**: Green (#4CAF50) for action buttons
- **Text**: White with opacity variations for hierarchy

### Typography
- **Roboto** font family for clarity and readability
- Size hierarchy: 36px (titles) → 18px (body) → 12px (labels)
- Strategic use of font weights for emphasis

### Animation & Transitions
- **Smooth fade-ins** for content transitions
- **Elastic scaling** for interactive elements
- **Progress animations** for session tracking

## 🔧 Technical Implementation

### State Management
Uses Provider pattern for:
- Session loading state
- Playback controls
- Progress tracking
- UI reactivity

### Audio Synchronization
- **Precise timing** using Timer.periodic
- **Audio lifecycle management** with AudioPlayer
- **Background playback** support
- **Pause/resume** functionality

### Error Handling
- **Graceful asset loading** with fallbacks
- **User-friendly error messages**
- **Robust exception handling**

## 🚀 Future Enhancements

### Planned Features
- **Multiple session support** with session library
- **Custom loop counts** user configuration
- **Background music layers** for enhanced experience
- **Session history** and progress tracking
- **Offline mode** with downloaded sessions

### Scalability Features
- **Plugin architecture** for different yoga styles
- **Cloud session sync** for multi-device experience
- **AI-powered session recommendations**
- **Real-time biometric integration** (for smart mat)

## 📝 Development Notes

### Performance Considerations
- **Lazy loading** of assets for memory efficiency
- **Optimized image sizes** for smooth transitions
- **Audio preloading** for seamless playback
- **State cleanup** to prevent memory leaks

### Testing Strategy
- **Unit tests** for business logic
- **Widget tests** for UI components
- **Integration tests** for complete user flows
- **Performance profiling** for smooth 60fps experience

## 🤝 Contributing

This is a proof-of-concept application demonstrating:
- **Modular architecture** principles
- **Clean code** practices
- **User-centered design** thinking
- **Scalable solution** architecture

## 📄 License

This project is a technical demonstration for the ArvyaX platform evaluation.

---

**Built with ❤️ using Flutter** | **Designed for mindful technology**
