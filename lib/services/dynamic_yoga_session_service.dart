import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/yoga_session.dart';

class DynamicYogaSessionService {
  // Get all available yoga session files dynamically
  static Future<List<String>> getAvailableSessionFiles() async {
    try {
      // Load the asset manifest to get all available JSON files
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      
      // Filter for JSON files that might be yoga sessions
      final sessionFiles = manifestMap.keys
          .where((String key) => 
              key.startsWith('assets/') && 
              key.endsWith('.json') && 
              key != 'AssetManifest.json')
          .toList();
      
      return sessionFiles;
    } catch (e) {
      // Fallback: return known session files
      return [
        'assets/CatCowJson.json'
      ];
    }
  }

  // Load any yoga session dynamically
  static Future<YogaSession> loadYogaSession(String jsonPath) async {
    try {
      final String response = await rootBundle.loadString(jsonPath);
      final Map<String, dynamic> data = json.decode(response);
      return YogaSession.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load yoga session from $jsonPath: $e');
    }
  }

  // Get all available sessions with metadata
  static Future<List<YogaSessionMeta>> getAvailableSessions() async {
    final sessionFiles = await getAvailableSessionFiles();
    final List<YogaSessionMeta> sessions = [];
    
    for (final file in sessionFiles) {
      try {
        final String response = await rootBundle.loadString(file);
        final Map<String, dynamic> data = json.decode(response);
        final metadata = data['metadata'];
        
        sessions.add(YogaSessionMeta(
          filePath: file,
          id: metadata['id'],
          title: metadata['title'],
          category: metadata['category'],
          defaultLoopCount: metadata['defaultLoopCount'],
          tempo: metadata['tempo'],
        ));
      } catch (e) {
        print('Failed to load metadata from $file: $e');
      }
    }
    
    return sessions;
  }

  static String getImagePath(String imageName) {
    return 'assets/images/$imageName';
  }

  static String getAudioPath(String audioName) {
    return 'assets/audio/$audioName';
  }

  static List<YogaSequence> expandLoopableSequences(
    List<YogaSequence> sequences,
    int loopCount,
  ) {
    List<YogaSequence> expandedSequences = [];
    
    for (var sequence in sequences) {
      if (sequence.type == 'loop' && sequence.loopable == true) {
        // Add the loop sequence multiple times
        for (int i = 0; i < loopCount; i++) {
          expandedSequences.add(sequence);
        }
      } else {
        expandedSequences.add(sequence);
      }
    }
    
    return expandedSequences;
  }
}

// Metadata class for session selection
class YogaSessionMeta {
  final String filePath;
  final String id;
  final String title;
  final String category;
  final int defaultLoopCount;
  final String tempo;

  YogaSessionMeta({
    required this.filePath,
    required this.id,
    required this.title,
    required this.category,
    required this.defaultLoopCount,
    required this.tempo,
  });
}
