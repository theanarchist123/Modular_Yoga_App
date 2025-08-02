import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/yoga_session.dart';
import '../services/dynamic_yoga_session_service.dart';

class YogaSessionController extends ChangeNotifier {
  YogaSession? _yogaSession;
  List<YogaSequence>? _expandedSequences;
  int _currentSequenceIndex = 0;
  int _currentScriptIndex = 0;
  bool _isPlaying = false;
  bool _isPaused = false;
  Timer? _mainTimer;
  Timer? _audioTimer; // Timer to manage sequence audio duration
  AudioPlayer? _audioPlayer;
  AudioPlayer? _backgroundMusicPlayer;
  
  // Timing variables
  int _totalElapsedSeconds = 0;
  int _currentSequenceElapsed = 0;
  int _currentScriptElapsed = 0;
  int _totalSessionDuration = 0;

  // Getters
  YogaSession? get yogaSession => _yogaSession;
  List<YogaSequence>? get expandedSequences => _expandedSequences;
  int get currentSequenceIndex => _currentSequenceIndex;
  int get currentScriptIndex => _currentScriptIndex;
  bool get isPlaying => _isPlaying;
  bool get isPaused => _isPaused;
  int get totalElapsedSeconds => _totalElapsedSeconds;
  int get totalSessionDuration => _totalSessionDuration;
  double get sessionProgress => _totalSessionDuration > 0 
      ? _totalElapsedSeconds / _totalSessionDuration 
      : 0.0;
  
  YogaSequence? get currentSequence {
    if (_expandedSequences == null || _currentSequenceIndex >= _expandedSequences!.length) {
      return null;
    }
    return _expandedSequences![_currentSequenceIndex];
  }
  
  YogaScript? get currentScript {
    final sequence = currentSequence;
    if (sequence == null || _currentScriptIndex >= sequence.script.length) {
      return null;
    }
    return sequence.script[_currentScriptIndex];
  }

  String? get currentImagePath {
    final script = currentScript;
    if (script == null || _yogaSession == null) return null;
    
    final imageName = _yogaSession!.images[script.imageRef];
    if (imageName == null) return null;
    
    // Correct path for Image.asset
    return 'assets/images/$imageName';
  }

  // Get remaining time for current script
  int get currentScriptRemainingTime {
    final script = currentScript;
    if (script == null) return 0;
    final scriptDuration = script.endSec - script.startSec;
    return scriptDuration - _currentScriptElapsed;
  }

  // Get current script duration for progress
  int get currentScriptDuration {
    final script = currentScript;
    if (script == null) return 0;
    return script.endSec - script.startSec;
  }

  double get currentScriptProgress {
    final duration = currentScriptDuration;
    if (duration == 0) return 0.0;
    return _currentScriptElapsed / duration;
  }

  Future<void> loadSession(String jsonPath) async {
    try {
      _yogaSession = await DynamicYogaSessionService.loadYogaSession(jsonPath);
      _expandedSequences = DynamicYogaSessionService.expandLoopableSequences(
        _yogaSession!.sequence,
        _yogaSession!.defaultLoopCount,
      );
      
      // Calculate total session duration
      _totalSessionDuration = _expandedSequences!.fold(
        0,
        (sum, sequence) => sum + sequence.durationSec,
      );
      
      _audioPlayer = AudioPlayer();
      _backgroundMusicPlayer = AudioPlayer();
      
      // Set audio player options for better performance
      await _audioPlayer!.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer!.setPlayerMode(PlayerMode.mediaPlayer);
      await _backgroundMusicPlayer!.setReleaseMode(ReleaseMode.loop);

      if (kDebugMode) {
        print('Session loaded: ${_yogaSession!.title}');
        print('Total duration: $_totalSessionDuration seconds');
        print('Sequences: ${_expandedSequences!.length}');
      }
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading session: $e');
      }
      rethrow;
    }
  }

  Future<void> startSession() async {
    if (_yogaSession == null || _expandedSequences == null) return;
    
    _isPlaying = true;
    _isPaused = false;
    _currentSequenceIndex = 0;
    _currentScriptIndex = 0;
    _totalElapsedSeconds = 0;
    _currentSequenceElapsed = 0;
    _currentScriptElapsed = 0;
    
    if (kDebugMode) {
      print('Starting session...');
    }
    
    // Disable background music for now to focus on sequence audio synchronization
    // _playBackgroundMusic();
    notifyListeners();
    await _startCurrentSequence();
  }

  Future<void> pauseSession() async {
    if (!_isPlaying) return;
    
    _isPaused = true;
    _isPlaying = false;
    _mainTimer?.cancel();
    
    // Pause audio players
    await _audioPlayer?.pause();
    await _backgroundMusicPlayer?.pause();
    
    if (kDebugMode) {
      print('Session paused at: ${_totalElapsedSeconds}s (Sequence: ${_currentSequenceElapsed}s)');
    }
    
    notifyListeners();
  }

  Future<void> resumeSession() async {
    if (!_isPaused) return;
    
    _isPaused = false;
    _isPlaying = true;
    
    // Resume background music
    await _backgroundMusicPlayer?.resume();
    
    // For main audio, we need to restart from current script position with seeking
    final sequence = currentSequence;
    final script = currentScript;
    if (sequence != null && script != null) {
      await _playSequenceAudioForScript(script, sequence);
    }
    
    // Restart the main timer
    _startMainTimer();
    
    if (kDebugMode) {
      print('Session resumed at: ${_totalElapsedSeconds}s (Sequence: ${_currentSequenceElapsed}s)');
    }
    
    notifyListeners();
  }

  Future<void> stopSession() async {
    _isPlaying = false;
    _isPaused = false;
    _mainTimer?.cancel();
    _audioTimer?.cancel();
    await _audioPlayer?.stop();
    await _backgroundMusicPlayer?.stop();
    
    _currentSequenceIndex = 0;
    _currentScriptIndex = 0;
    _totalElapsedSeconds = 0;
    _currentSequenceElapsed = 0;
    _currentScriptElapsed = 0;
    
    if (kDebugMode) {
      print('Session stopped and reset');
    }
    
    notifyListeners();
  }

  Future<void> _startCurrentSequence() async {
    final sequence = currentSequence;
    if (sequence == null) {
      await _sessionComplete();
      return;
    }

    if (kDebugMode) {
      print('🚀 === STARTING SEQUENCE: ${sequence.name} ===');
      print('⏱️  Duration: ${sequence.durationSec}s');
      print('🎵 Audio: ${sequence.audioRef}');
      print('📝 Scripts: ${sequence.script.length}');
      for (int i = 0; i < sequence.script.length; i++) {
        final script = sequence.script[i];
        print('  [$i] ${script.startSec}-${script.endSec}s: ${script.imageRef} - "${script.text.length > 30 ? script.text.substring(0, 30) + '...' : script.text}"');
      }
    }

    // Cancel any existing audio timer
    _audioTimer?.cancel();

    // Always stop any currently playing audio first
    await _audioPlayer?.stop();

    // For precise synchronization, we'll handle audio per script instead of per sequence
    // This prevents audio bleed and ensures each script's audio matches exactly
    if (kDebugMode) {
      print('🎵 Audio will be managed per script for precise synchronization');
    }

    _currentScriptIndex = -1; // Reset to ensure the first script triggers an update
    _currentSequenceElapsed = 0;
    _currentScriptElapsed = 0;
    
    // Immediately find and set the first script (at 0 seconds)
    _updateCurrentScript();
    
    _startMainTimer();
  }

  void _startMainTimer() {
    _mainTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _totalElapsedSeconds++;
      _currentSequenceElapsed++;
      _currentScriptElapsed++;
      
      // Check for script changes first (before logging)
      _updateCurrentScript();
      
      // Show timing info every 5 seconds for better tracking
      if (kDebugMode && _totalElapsedSeconds % 5 == 0) {
        print('⏰ === TIMING STATUS ===');
        print('🕐 Total: ${_totalElapsedSeconds}s, Sequence: ${_currentSequenceElapsed}s, Script: ${_currentScriptElapsed}s');
        final seq = currentSequence;
        final script = currentScript;
        if (seq != null && script != null) {
          print('📍 Current: ${seq.name} → ${script.imageRef} (${script.startSec}-${script.endSec}s)');
          print('💬 Text: "${script.text.length > 40 ? script.text.substring(0, 40) + '...' : script.text}"');
        }
        print('========================');
      }
      
      // Check if current sequence is complete
      final sequence = currentSequence;
      if (sequence != null && _currentSequenceElapsed >= sequence.durationSec) {
        if (kDebugMode) {
          print('✅ Sequence "${sequence.name}" complete. Duration: ${sequence.durationSec}s, Elapsed: ${_currentSequenceElapsed}s');
        }
        _moveToNextSequence();
      }
      
      notifyListeners();
    });
  }

  void _updateCurrentScript() {
    final sequence = currentSequence;
    if (sequence == null) return;

    // Find the script that should be active at the current sequence time
    // Use precise timing to ensure immediate image switches at startSec
    int newScriptIndex = -1;
    for (int i = 0; i < sequence.script.length; i++) {
      final script = sequence.script[i];
      // Use >= for startSec to ensure immediate transition at exact timing
      if (_currentSequenceElapsed >= script.startSec && _currentSequenceElapsed < script.endSec) {
        newScriptIndex = i;
        break;
      }
    }
    
    if (newScriptIndex != -1 && _currentScriptIndex != newScriptIndex) {
      final oldScriptIndex = _currentScriptIndex;
      _currentScriptIndex = newScriptIndex;
      final script = sequence.script[_currentScriptIndex];
      _currentScriptElapsed = _currentSequenceElapsed - script.startSec;
      
      if (kDebugMode) {
        final message = script.text.length > 30 
            ? '${script.text.substring(0, 30)}...' 
            : script.text;
        print('⏰ [${_currentSequenceElapsed}s] 🔄 SCRIPT TRANSITION $oldScriptIndex → $_currentScriptIndex');
        print('📸 Image: ${script.imageRef} (${script.startSec}-${script.endSec}s)');
        print('💬 Text: "$message"');
        print('⏱️  Script elapsed: ${_currentScriptElapsed}s / ${script.endSec - script.startSec}s');
        print('🎵 Audio will restart for this script to prevent bleed');
      }
      
      // Start audio for this specific script timing
      _playSequenceAudioForScript(script, sequence);

      // Immediately notify listeners for precise image switching
      notifyListeners();
    }
  }

  Future<void> _playSequenceAudioForScript(YogaScript script, YogaSequence sequence) async {
    // Stop any currently playing audio to prevent bleed
    await _audioPlayer?.stop();
    _audioTimer?.cancel();

    // Get the sequence audio
    final audioName = _yogaSession!.audio[sequence.audioRef];
    if (audioName == null) return;

    try {
      final audioPath = 'audio/$audioName';
      final scriptDuration = script.endSec - script.startSec;
      final seekPosition = Duration(seconds: script.startSec);
      
      if (kDebugMode) {
        print('🎵 Starting audio for script at ${script.startSec}s-${script.endSec}s (${scriptDuration}s duration)');
        print('🎵 Audio file: $audioPath');
        print('⏰ Seeking to position: ${script.startSec}s');
      }
      
      // Play the audio file and seek to the correct position for this script
      await _audioPlayer?.play(AssetSource(audioPath));
      
      // Seek to the script's start position in the audio file
      await _audioPlayer?.seek(seekPosition);
      
      // Set a timer to stop the audio when this script's duration is reached
      // This is critical to prevent audio bleeding into the next script
      _audioTimer = Timer(Duration(seconds: scriptDuration), () async {
        if (kDebugMode) {
          print('🔇 Script audio timer expired (${scriptDuration}s), stopping to prevent bleed');
        }
        await _audioPlayer?.stop();
      });
      
      if (kDebugMode) {
        print('✅ Audio started at ${script.startSec}s for script duration: ${scriptDuration}s');
        print('🔇 Audio will auto-stop in ${scriptDuration}s to prevent bleed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error playing audio "$audioName": $e');
      }
    }
  }



  void _moveToNextSequence() {
    _mainTimer?.cancel();
    _audioTimer?.cancel();
    
    if (_currentSequenceIndex >= _expandedSequences!.length - 1) {
      _sessionComplete();
      return;
    }

    if (kDebugMode) {
      print('=== SEQUENCE TRANSITION ===');
      print('Moving from sequence $_currentSequenceIndex to ${_currentSequenceIndex + 1}');
      print('Previous sequence elapsed: ${_currentSequenceElapsed}s');
    }

    _currentSequenceIndex++;
    _currentScriptIndex = 0;
    _currentSequenceElapsed = 0;
    _currentScriptElapsed = 0;
    
    // Start the new sequence (this will handle stopping old audio and starting new audio)
    _startCurrentSequence();
  }

  void nextStep() {
    if (currentScript == null || _expandedSequences == null) return;

    final sequence = currentSequence!;
    
    // If there's a next script in the current sequence
    if (_currentScriptIndex < sequence.script.length - 1) {
      final nextScript = sequence.script[_currentScriptIndex + 1];
      
      // Calculate time to jump forward
      final timeJump = nextScript.startSec - _currentSequenceElapsed;
      
      // Update timers
      _totalElapsedSeconds += timeJump;
      _currentSequenceElapsed = nextScript.startSec;
      _currentScriptElapsed = 0; // We are at the beginning of the new script
      
      // Set the new script index
      _currentScriptIndex++;
      
      if (kDebugMode) {
        print('Next Step: Jumping to script $_currentScriptIndex at ${nextScript.startSec}s');
      }
      
      // Re-sync audio and visuals for the new state
      _syncStateToCurrentTime();
    } else {
      // Otherwise, move to the beginning of the next sequence
      if (kDebugMode) {
        print('Next Step: End of sequence, moving to next one.');
      }
      _moveToNextSequence();
    }
    notifyListeners();
  }

  void previousStep() {
    if (currentScript == null || _expandedSequences == null) return;

    // If we are more than a second into the current script, just rewind to its beginning
    if (_currentScriptElapsed > 0) {
      if (kDebugMode) {
        print('Previous Step: Rewinding to start of current script.');
      }
      // Update timers
      _totalElapsedSeconds -= _currentScriptElapsed;
      _currentSequenceElapsed -= _currentScriptElapsed;
      _currentScriptElapsed = 0;
      
      // Re-sync audio and visuals
      _syncStateToCurrentTime();
    } 
    // If we are at the start of a script, go to the previous one
    else if (_currentScriptIndex > 0) {
      if (kDebugMode) {
        print('Previous Step: Moving to previous script.');
      }
      // Set new script index
      _currentScriptIndex--;
      final prevScript = currentSequence!.script[_currentScriptIndex];
      
      // Calculate how much time to rewind
      final timeToRewind = _currentSequenceElapsed - prevScript.startSec;

      // Update timers
      _totalElapsedSeconds -= timeToRewind;
      _currentSequenceElapsed = prevScript.startSec;
      _currentScriptElapsed = 0;
      
      // Re-sync audio and visuals
      _syncStateToCurrentTime();
    } 
    // If we are at the first script of a sequence, go to the previous sequence
    else if (_currentSequenceIndex > 0) {
      if (kDebugMode) {
        print('Previous Step: Moving to previous sequence.');
      }
      _mainTimer?.cancel();
      
      // Move to previous sequence
      _currentSequenceIndex--;
      final prevSequence = currentSequence!;
      final lastScript = prevSequence.script.last;
      
      // Calculate the new total elapsed time
      int newTotalElapsed = 0;
      for (int i = 0; i < _currentSequenceIndex; i++) {
        newTotalElapsed += _expandedSequences![i].durationSec;
      }
      
      // Set time to the start of the last script in the previous sequence
      _currentSequenceElapsed = lastScript.startSec;
      _totalElapsedSeconds = newTotalElapsed + _currentSequenceElapsed;
      _currentScriptIndex = prevSequence.script.length - 1;
      _currentScriptElapsed = 0;

      // Restart the sequence logic (plays audio, starts timer)
      _startCurrentSequence();
    }
    notifyListeners();
  }

  /// This method re-synchronizes the UI and audio to the current time variables.
  /// It's useful after manual navigation (next/previous).
  void _syncStateToCurrentTime() {
    final sequence = currentSequence;
    final script = currentScript;
    if (sequence == null || script == null) return;

    if (kDebugMode) {
      print('Syncing state: Current sequence=${sequence.name}, script time=${_currentSequenceElapsed}s');
    }
    
    // Start audio for the current script with seeking to maintain precise sync
    _playSequenceAudioForScript(script, sequence);
    
    notifyListeners();
  }

  Future<void> _sessionComplete() async {
    _isPlaying = false;
    _mainTimer?.cancel();
    await _audioPlayer?.stop();
    
    if (kDebugMode) {
      print('Session completed!');
    }
    
    notifyListeners();
  }

  Future<void> testAudio(String audioRef) async {
    final audioName = _yogaSession?.audio[audioRef];
    if (audioName != null && _audioPlayer != null) {
      try {
        final audioPath = 'audio/$audioName';
        if (kDebugMode) {
          print('Testing audio: $audioPath');
        }
        await _audioPlayer!.play(AssetSource(audioPath));
        if (kDebugMode) {
          print('Test audio playing successfully.');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error testing audio $audioName: $e');
        }
      }
    } else {
      if (kDebugMode) {
        print('Could not test audio. Audio name or player is null.');
      }
    }
  }

  @override
  void dispose() {
    _mainTimer?.cancel();
    _audioTimer?.cancel();
    _audioPlayer?.dispose();
    _backgroundMusicPlayer?.dispose();
    super.dispose();
  }
}
