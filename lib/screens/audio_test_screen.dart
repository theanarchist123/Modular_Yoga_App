import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioTestScreen extends StatefulWidget {
  const AudioTestScreen({super.key});

  @override
  State<AudioTestScreen> createState() => _AudioTestScreenState();
}

class _AudioTestScreenState extends State<AudioTestScreen> {
  AudioPlayer? _audioPlayer;
  String _currentStatus = 'Ready to test';
  
  final List<String> _audioFiles = [
    'cat_cow_intro.mp3',
    'cat_cow_loop.mp3',
    'cat_cow_outro.mp3',
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  Future<void> _testAudio(String fileName) async {
    try {
      setState(() {
        _currentStatus = 'Testing: $fileName';
      });
      
      await _audioPlayer?.stop();
      
      // Try with audio/ prefix first
      try {
        await _audioPlayer?.play(AssetSource('audio/$fileName'));
        setState(() {
          _currentStatus = 'Playing: audio/$fileName';
        });
        if (kDebugMode) {
          print('Successfully playing: audio/$fileName');
        }
      } catch (e1) {
        if (kDebugMode) {
          print('Failed with audio/ prefix: $e1');
        }
        // Try without prefix
        try {
          await _audioPlayer?.play(AssetSource(fileName));
          setState(() {
            _currentStatus = 'Playing: $fileName (direct)';
          });
          if (kDebugMode) {
            print('Successfully playing: $fileName');
          }
        } catch (e2) {
          throw e2;
        }
      }
    } catch (e) {
      setState(() {
        _currentStatus = 'Error: $e';
      });
      
      if (kDebugMode) {
        print('Audio error: $e');
      }
    }
  }

  Future<void> _stopAudio() async {
    await _audioPlayer?.stop();
    setState(() {
      _currentStatus = 'Stopped';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Audio Test',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Status: $_currentStatus',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Audio test buttons
            ..._audioFiles.map((fileName) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                onPressed: () => _testAudio(fileName),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Test $fileName',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            )),
            
            const SizedBox(height: 20),
            
            // Stop button
            ElevatedButton(
              onPressed: _stopAudio,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Stop Audio',
                style: TextStyle(fontSize: 16),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Audio Test Instructions:',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1. Tap each audio file to test playback\n'
                    '2. Check the status message above\n'
                    '3. Use Stop Audio to halt playback\n'
                    '4. If audio fails, check device volume and permissions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
